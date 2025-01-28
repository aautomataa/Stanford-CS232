% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Graylevel morphological edge detectors

clear, clc, close all

% Load test image
img = im2double(imread('bike.png'));

% Perform dilation
se= strel('disk', 3);
img_dilated = imdilate(img, se) ;

% Perform subtraction and thresholding
edge = img_dilated - img;
BW = edge > 0.15;

% Show images
subplot(2, 2, 1), imshow(img); title('Original Image');
subplot(2, 2, 2), imshow(img_dilated); title('Dilated Image');
subplot(2, 2, 3), imshow(edge); title('Edge = Dilated - Original');
subplot(2, 2, 4), imshow(BW); title('Edge > Threshold');

% Save images
imwrite(img_dilated, 'Graylevel_Edge_Detection_dilated.png');
imwrite(edge, 'Graylevel_Edge_Detection_edge.png');
imwrite(BW, 'Graylevel_Edge_Detection_bw_edge.png');