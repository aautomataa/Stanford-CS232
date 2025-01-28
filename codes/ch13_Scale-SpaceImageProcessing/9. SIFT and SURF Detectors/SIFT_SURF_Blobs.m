% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% SURF and SIFT blob detection

clear, clc, close all

% Add path for SIFT
addpath '../vlfeat-0.9.16/toolbox'
vl_setup;

images = {'dog.jpg', 'sunflower.jpg'};
SIFTPeakThresh = [20 9.6];
SIFTEdgeThresh = [5 10];
SURFNumPoints = [200 150];
for nImage = 1:length(images)
    
    warning off;

    % Detect SIFT keypoints for dog image
    img = imread(images{nImage});
    if size(img,3) > 1
        imgGray = rgb2gray(img);
    else
        imgGray = img;
    end
    [frames, d] = vl_sift(single(imgGray), ...
        'PeakThresh', SIFTPeakThresh(nImage), ...
        'EdgeThresh', SIFTEdgeThresh(nImage));
    frames = frames';
    plotBlob(img, frames);
    set(gcf, 'Color', 'w');
    disp(sprintf('%d SIFT keypoints', size(frames,1)));
    
    % Detect SURF keypoints
    points = detectSURFFeatures(imgGray);
    points = points.selectStrongest(SURFNumPoints(nImage));
    frames = zeros(SURFNumPoints(nImage), 3);
    alpha = 1.3;
    for n = 1 : size(points, 1)
        frames(n, 1 : 2) = points(n).Location;
        frames(n, 3) = points(n).Scale * alpha;
    end
    plotBlob(img, frames);
    set(gcf, 'Color', 'w');
    disp(sprintf('%d SURF keypoints', size(frames,1)));
    
    warning on;

end % nImage