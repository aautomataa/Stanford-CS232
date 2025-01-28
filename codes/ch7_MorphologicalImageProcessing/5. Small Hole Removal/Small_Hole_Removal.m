% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Small hole removal by closing

clear, clc, close all;

% Load test image
img = imread('peter.png') ;

% Binarize image
origMask = img < 100;

% Perform closing
se= strel('square', 10);
img_dilated = imdilate(origMask, se) ;
img_closed = imerode(img_dilated, se) ;
img_dif = img_closed - origMask ;

% Show images
subplot(2, 2, 1), imshow(origMask); title('Original Image');
subplot(2, 2, 2), imshow(img_dilated); title('Dilated Image');
subplot(2, 2, 3), imshow(img_closed); title('Closed Image');
subplot(2, 2, 4), imshow(img_dif); title('Original - Closed');

% Save images
imwrite(origMask, 'Small_Hole_Removal_original.png');
imwrite(img_dilated, 'Small_Hole_Removal_dilation.png');
imwrite(img_dilated, 'Small_Hole_Removal_closing.png');
imwrite(img_dif, 'Small_Hole_Removal_difference.png');















