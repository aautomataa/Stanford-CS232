% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Example: chain link fence hole detection

clear, clc, close all

% Load test image
img = im2double(imread('fence.jpg'));
img = rgb2gray(img);
imgSize = size(img)
level = graythresh(img)

% Perform erosion with cross structuring element
length = 151;
NHOOD = zeros(length);
NHOOD(ceil(length/2), :) = 1;
NHOOD(:, ceil(length/2)) = 1;
se = strel('arbitrary', NHOOD);
erodedImg = imerode(img, se);

% Perform thresholding
BW = erodedImg > level;

% Show images
subplot(1, 3, 1), imshow(img); title('Original Image');
subplot(1, 3, 2), imshow(erodedImg); title('Eroded Image');
subplot(1, 3, 3), imshow(BW); title('Thresholded Result');

% Save images
imwrite(erodedImg, 'Graylevel_Erosion_Fence_erosion.png');
imwrite(BW, 'Graylevel_Erosion_Fence_bw.png');

