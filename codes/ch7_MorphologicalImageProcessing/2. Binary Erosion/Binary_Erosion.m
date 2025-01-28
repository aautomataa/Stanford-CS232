% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Erosion

clear, clc, close all

% Load test image
img = imread('bacteria.png');

% Perform dilation with small disk
se1 = strel('disk', 3);
BW1 = imerode(img,se1);

% Perform dilation with larger disk
se2 = strel('disk', 7);
BW2 = imerode(img, se2);

% Show images
subplot(1, 3, 1), imshow(img); title('Original Image');
subplot(1, 3, 2), imshow(BW1); title('Erosion by Small Disk');
subplot(1, 3, 3), imshow(BW2); title('Eorsion by Larger Disk');

% Save images
imwrite(BW1, 'Erosion_disk_3.png');
imwrite(BW2, 'Erosion_disk_7.png')





