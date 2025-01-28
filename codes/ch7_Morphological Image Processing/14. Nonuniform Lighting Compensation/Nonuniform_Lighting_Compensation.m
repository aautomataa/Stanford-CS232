% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Non-uniform lighting compensation

clear, clc, close all

% Load test image
img = im2double(imread('paper.png'));

% Perform dilation
windowW = 61;
windowH = 61;
dilatedImg = imdilate(img, ones(windowH,windowW));

% Perform rank filtering
rankFilteredImg = ordfilt2(img, windowH*windowW-20, true(windowH,windowW), 'symmetric');

figure(1); clf;
subplot(1, 3, 1), imshow(img); title('Original Image');
subplot(1, 3, 2), imshow(dilatedImg); title('Dilated Image');
subplot(1, 3, 3), imshow(rankFilteredImg); title('Rank-Filtered Image');

% Subtract from rank-filtered image and threshold
difImg = rankFilteredImg - img;
level = graythresh(difImg);
bwImg = im2bw(difImg, level);

figure(2); clf;
subplot(1, 2, 1), imshow(difImg); title('Ranked-Filtered - Original');
subplot(1, 2, 2), imshow(bwImg); title('Thresholded Result');

% Save images
imwrite(rankFilteredImg, 'Nonuniform_Lighting_Compensation_filtered.png');
imwrite(difImg, 'Nonuniform_Lighting_Compensation_dif.png');
imwrite(bwImg, 'Nonuniform_Lighting_Compensation_bw.png');