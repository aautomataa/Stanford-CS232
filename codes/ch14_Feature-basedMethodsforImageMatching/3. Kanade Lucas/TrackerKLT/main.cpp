#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <stdlib.h>
#include <stdio.h>
#include <string>

using namespace cv;
using namespace std;

int main(int argc, char *argv[])
{
    // Open video
    string sInputVideoFile = "C:\\Users\\David Chen\\Desktop\\Test\\crew_4cif.mp4";
    CvCapture* capture = cvCreateFileCapture(sInputVideoFile.c_str());
    IplImage* new_bgr_frame = cvQueryFrame(capture);
    double fps = cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);
    CvSize frame_size = cvSize(
        (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH),
        (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT)
        );

    // Convert 1st frame to grayscale
    IplImage* prev_gray_frame = cvCreateImage(frame_size, IPL_DEPTH_8U, 1);
    cvCvtColor(new_bgr_frame, prev_gray_frame, CV_BGR2GRAY);
    IplImage* new_gray_frame = cvCreateImage(frame_size, IPL_DEPTH_8U, 1);

    // Define tracking parameters
    const int max_sparse_corners = 500;
    const int dense_corners_x = 60;
    const int dense_corners_y = 60;
    const int max_dense_corners = dense_corners_x * dense_corners_y;
    int window_size = 10;
    IplImage* marked_frame = cvCreateImage(frame_size, IPL_DEPTH_8U, 3);
    IplImage* eig_image = cvCreateImage(frame_size, IPL_DEPTH_32F, 1);
    IplImage* temp_image = cvCreateImage(frame_size, IPL_DEPTH_32F, 1);
    IplImage* frame_diff = cvCreateImage(frame_size, IPL_DEPTH_8U, 1);
    IplImage* max_frame_diff = cvCreateImage(frame_size, IPL_DEPTH_8U, 1);
    cvSet(max_frame_diff, cvScalar(0));
    CvPoint2D32f* sparse_prev_corners = new CvPoint2D32f[max_sparse_corners];
    CvPoint2D32f* sparse_new_corners = new CvPoint2D32f[max_sparse_corners];
    CvPoint2D32f* dense_prev_corners = new CvPoint2D32f[dense_corners_x * dense_corners_y];
    CvPoint2D32f* dense_new_corners = new CvPoint2D32f[dense_corners_x * dense_corners_y];
    char features_found[std::max(max_sparse_corners, max_dense_corners)];
    float feature_errors[std::max(max_sparse_corners, max_dense_corners)];
    CvSize pyramid_size = cvSize(prev_gray_frame->width+8, prev_gray_frame->height/3);
    IplImage* prev_gray_pyramid = cvCreateImage(pyramid_size, IPL_DEPTH_32F, 1);
    IplImage* new_gray_pyramid = cvCreateImage(pyramid_size, IPL_DEPTH_32F, 1);
    IplImage* harris_cornerness = cvCreateImage(frame_size, IPL_DEPTH_32F, 1);

    // Process frames in video
    cvNamedWindow("Video Window 1");
    int frame_number = 2;
    int num_frames_to_write = 700;
    int num_frames_to_skip = 2;
    string sOutputVideoFile = "C:\\Users\\David Chen\\Desktop\\Test\\crew_4cif_KL.avi";
    double output_fps = 30;
    CvVideoWriter* writer = cvCreateVideoWriter(
        sOutputVideoFile.c_str(),
        CV_FOURCC('M','J','P','G'),
        output_fps,
        frame_size
    );
    int sparseMaxMotion = 20;
    int denseMaxMotion = 20; // 10;
    bool useShiTomasi = false;
    float cornerness_threshold = 0.00000001; // 0.000001
    while ( ((new_bgr_frame = cvQueryFrame(capture)) != NULL) && (frame_number <= num_frames_to_write) )
    {
        printf("Frame %d \n", frame_number);

        // Convert new frame to grayscale
        cvCvtColor(new_bgr_frame, new_gray_frame, CV_BGR2GRAY);
        cvCopy(new_bgr_frame, marked_frame);

        // Find good feature points to track using Shi-Tomasi criteria
        int corner_count = 0;
        CvPoint2D32f* prev_corners = NULL;
        CvPoint2D32f* new_corners = NULL;
        if (useShiTomasi)
        {
            corner_count = max_sparse_corners;
            cvGoodFeaturesToTrack(prev_gray_frame, eig_image, temp_image, sparse_prev_corners, &corner_count,
                0.01, 5.0, 0, 3, 0, 0.04
                );
            cvFindCornerSubPix(prev_gray_frame, sparse_prev_corners, corner_count, cvSize(window_size, window_size),
                cvSize(-1, -1), cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03)
                );
            prev_corners = sparse_prev_corners;
            new_corners = sparse_new_corners;
        }
        else
        {
            cvCornerHarris(prev_gray_frame, harris_cornerness, 10);
            // cvCornerMinEigenVal(prev_gray_frame, harris_cornerness, 5);

            corner_count = 0;
            float delta_x = float(frame_size.width) / dense_corners_x;
            float delta_y = float(frame_size.height) / dense_corners_y;
            char* harris_cornerness_ptr = harris_cornerness->imageData;
            for (int ny = 0; ny < dense_corners_y; ny++)
            {
                float cy = delta_y/2 + ny*delta_y;
                int cyr = int(cy + 0.5);
                for (int nx = 0; nx < dense_corners_x; nx++)
                {
                    float cx = delta_x/2 + nx*delta_x;
                    int cxr = int(cx + 0.5);

                    harris_cornerness_ptr = harris_cornerness->imageData + harris_cornerness->widthStep*cyr + cxr*4;
                    float cornerness = *((float*)harris_cornerness_ptr);
                    // printf("(%d, %d), %f \n", cxr, cyr, cornerness);
                    if (cornerness > cornerness_threshold)
                    {
                        dense_prev_corners[corner_count].x = cx;
                        dense_prev_corners[corner_count].y = cy;
                        corner_count++;
                    }
                } // nx
            } // ny
            prev_corners = dense_prev_corners;
            new_corners = dense_new_corners;
        }

        // Track feature points using Lucas-Kanade algorithm
        int flags = 0;
        cvCalcOpticalFlowPyrLK(prev_gray_frame, new_gray_frame, prev_gray_pyramid, new_gray_pyramid,
            prev_corners, new_corners, corner_count, cvSize(window_size, window_size), 5,
            features_found, feature_errors, cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.3),
            flags
            );

        // Draw optical flow
        for (int i = 0; i < corner_count; i++)
        {
            // Skip feature that was not tracked successfully
            if ( (features_found[i] == 0) || (feature_errors[i] > 200) )
            {
                continue;
            }

            // Determine motion orientation
            CvPoint p0 = cvPoint( cvRound(prev_corners[i].x), cvRound(prev_corners[i].y) );
            CvPoint p1 = cvPoint( cvRound(new_corners[i].x), cvRound(new_corners[i].y) );
            CvPoint p0_bg, p1_bg;
            p0_bg.x = p0.x - 1;
            p0_bg.y = p0.y - 1;
            float x_moved = prev_corners[i].x - new_corners[i].x;
            float y_moved = prev_corners[i].y - new_corners[i].y;
            double angle = atan2( (double)y_moved, (double)x_moved );
            float dist_moved = sqrt(x_moved*x_moved + y_moved*y_moved);

            if (dist_moved < ((useShiTomasi) ? sparseMaxMotion : denseMaxMotion))
            {
                // Make arrow longer for easy visibility
                float scale_factor = (useShiTomasi) ? 1 + exp(-dist_moved/10) : 1;
                p1.x = (int)(p0.x - scale_factor * dist_moved * cos(angle));
                p1.y = (int)(p0.y - scale_factor * dist_moved * sin(angle));
                p1_bg.x = p1.x - 1;
                p1_bg.y = p1.y - 1;

                // Draw arrow body
                CvScalar line_color = CV_RGB(255,255,0);
                CvScalar bg_line_color = CV_RGB(0,0,0);
                int line_thickness = 1;
                cvLine(marked_frame, p0_bg, p1_bg, bg_line_color, line_thickness, CV_AA, 0);
                cvLine(marked_frame, p0, p1, line_color, line_thickness, CV_AA, 0);

                // Draw arrow tip
                double pi = 3.14159;
                float arrow_tip_scale = (useShiTomasi) ? 4 : 2;
                p0.x = (int)(p1.x + arrow_tip_scale*cos(angle + pi/4));
                p0.y = (int)(p1.y + arrow_tip_scale*sin(angle + pi/4));
                p0_bg.x = p0.x - 1;
                p0_bg.y = p0.y - 1;
                cvLine(marked_frame, p0_bg, p1_bg, bg_line_color, line_thickness, CV_AA, 0);
                cvLine(marked_frame, p0, p1, line_color, line_thickness, CV_AA, 0);
                p0.x = (int)(p1.x + arrow_tip_scale*cos(angle - pi/4));
                p0.y = (int)(p1.y + arrow_tip_scale*sin(angle - pi/4));
                p0_bg.x = p0.x - 1;
                p0_bg.y = p0.y - 1;
                cvLine(marked_frame, p0_bg, p1_bg, bg_line_color, line_thickness, CV_AA, 0);
                cvLine(marked_frame, p0, p1, line_color, line_thickness, CV_AA, 0);
            }
        } // i

        cvShowImage("Video Window 1", marked_frame);
        cvWaitKey(1);

        // Save frame to file
        if (frame_number > num_frames_to_skip)
        {
            cvWriteFrame(writer, marked_frame);
        }

        // Save new frame for next iteration
        cvCopy(new_gray_frame, prev_gray_frame);
        cvCopy(new_gray_pyramid, prev_gray_pyramid);

        frame_number++;

    } // while
    cvReleaseVideoWriter(&writer);

    // Clean up
    cvReleaseImage(&prev_gray_frame);
    cvReleaseImage(&new_gray_frame);
    cvReleaseImage(&marked_frame);
    cvReleaseImage(&eig_image);
    cvReleaseImage(&temp_image);
    cvReleaseImage(&frame_diff);
    cvReleaseImage(&max_frame_diff);
    cvReleaseImage(&prev_gray_pyramid);
    cvReleaseImage(&new_gray_pyramid);
    cvReleaseImage(&harris_cornerness);
    cvReleaseCapture(&capture);
    delete [] sparse_prev_corners;
    delete [] sparse_new_corners;
    delete [] dense_prev_corners;
    delete [] dense_new_corners;
    return 0;

}
