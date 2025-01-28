% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Example: chain link fence hole detection

clear, clc, close all

% Load test image and binarize
img = imread('fence.jpg');
img = rgb2gray(img);
imgSize = size(img)
level = graythresh(img)
BW = im2bw(img, level);

% Perform erosion with cross structuring element
length = 151;
NHOOD = zeros(length);
NHOOD(ceil(length/2), :) = 1;
NHOOD(:, ceil(length/2)) = 1;
se = strel('arbitrary', NHOOD);
BW1 = imerode(BW, se);
figure(1); clf;
imshow(NHOOD);

% Show images
figure(2); clf;
subplot(1, 3, 1), imshow(img); title('Original Image');
subplot(1, 3, 2), imshow(BW); title('Binarized Image');
subplot(1, 3, 3), imshow(BW1); title('Eroded Image');

% Save images
imwrite(BW, 'Binary_Erosion_Fence_bw.png');
imwrite(BW1, 'Binary_Erosion_Fence_detect.png');

