% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Determinant of Hessian keypoint detector

clear, clc, close all

imageFiles = {'35-a.jpg', '35-b.jpg'};
for nImage = 1:length(imageFiles)

    % Load image
    img = imread(imageFiles{nImage});
    img = im2double(img);
    imgGray = rgb2gray(img);
    figure(1); clf;
    imshow(img); title('Original Image');

    % Create filters
    sigma = 2;
    g = fspecial('gaussian', [10*sigma+1, 10*sigma+1], sigma);
    s = fspecial('sobel');
    filterXG = imfilter(imfilter(g,s.','replicate'),s.','replicate');
    filterYG = imfilter(imfilter(g,s,'replicate'),s,'replicate');
    filterXYG = imfilter(imfilter(g,s.','replicate'),s,'replicate');
    figure(2);
    subplot(1,3,1); imshow(filterXG,[-0.2 0.2]); title('Filter x');
    subplot(1,3,2); imshow(filterYG,[-0.2 0.2]); title('Filter y');
    subplot(1,3,3); imshow(filterXYG,[-0.2 0.2]); title('Filter x-y');

    % Calculate determinant of Hessian
    imgDxx = imfilter(imgGray, filterXG, 'replicate');
    imgDyy = imfilter(imgGray, filterYG, 'replicate');
    imgDxy = imfilter(imgGray, filterXYG, 'replicate');
    imgFilt = imgDxx.*imgDyy - imgDxy.^2;
    figure(3); clf;
    imshow(imgFilt,[-1 1]); title('Determinant of Hessian Response');

    % Find extrema
    imgFilt(find(imgFilt < 0.05*max(imgFilt(:)))) = 0;
    imgExt = imregionalmax(imgFilt);
    figure(4); clf;
    imshow(imgFilt,[-1 1]); title('Thresholded Response');
    figure(5); clf;
    imshow(imdilate(imgExt, ones(3,3))); title('Local Maxima (Dilated)');

    % Show strongest keypoints
    numCorners = sum(imgExt(:))
    figure(6); clf;
    imshow(img); hold on;
    [row,col] = find(imgExt == 1);
    responses = zeros(1,numel(row));
    for n = 1:numel(row)
        responses(n) = imgFilt(row(n), col(n));
    end % n
    [responses, sortIdx] = sort(responses, 'descend');
    for n = 1:600 % numel(row)
        h = plot(col(sortIdx(n)), row(sortIdx(n)), 'y+');
        set(h, 'MarkerSize', 3, 'MarkerFaceColor', 'y');
    end % n

    pause;

end % nImage