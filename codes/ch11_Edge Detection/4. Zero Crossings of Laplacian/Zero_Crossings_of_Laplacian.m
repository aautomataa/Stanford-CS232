% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Zero crossings of Laplacian

clear, clc, close all

% Load test image
img = imread('berndsface.png');

% Find zero crossings of Laplacian
h = fspecial('laplacian', 0);
bw = edge(img, 'zerocross', 0, h);

% Show and save images
subplot(1, 2, 1), imshow(img); title('Original Image');
subplot(1, 2, 2), imshow(bw); title('Zero Crossings of Laplacian');
imwrite(bw, 'Zero_crossings_laplacian.png');





