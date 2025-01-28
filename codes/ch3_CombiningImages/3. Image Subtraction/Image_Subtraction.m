% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Image subtraction

clear, clc, close all

% Load test images
maskImg = im2double(imread('mask.jpg'));
liveImg = im2double(imread('live.jpg'));

% Calculate difference image and enhance contrast
diffImg = abs(maskImg - liveImg);
histeqDiffImg = adapthisteq(diffImg, 'ClipLimit', 0.005);

% Show images
subplot(1, 4, 1), imshow(liveImg);
title('Live image');
subplot(1, 4, 2), imshow(maskImg);
title('Mask image');
subplot(1, 4, 3), imshow(diffImg);
title('Difference image');
subplot(1, 4, 4), imshow(histeqDiffImg);
title('Histogram equalized difference image');

% Save images
imwrite(diffImg, 'Image_Subtraction_diff.png');
imwrite(histeqDiffImg, 'Image_Subtraction_histeqdiff.png');
