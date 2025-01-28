% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Graylevel Erosion and Dilation

clear, clc, close all;

% Load test image
img = imread('butterfly.png');

% Use square structuring element
se = strel('square', 10);
dilatedImg = imdilate(img, se);
erodedImg = imerode(img, se);
subplot(1, 2, 1), imshow(dilatedImg)
subplot(1, 2, 2), imshow(erodedImg)
imwrite(dilatedImg, 'Graylevel_Erosion_Dilation_square_dilation.png');
imwrite(erodedImg, 'Graylevel_Erosion_Dilation_square_erosion.png');

% Use diamond structuring element
se = strel('diamond', 10); 
dilatedImg = imdilate(img, se);
figure, imshow(dilatedImg)
imwrite(dilatedImg, 'Graylevel_Erosion_Dilation_diamond_dilation.png');

% Use disk structuring element
se = strel('disk', 8);
dilatedImg = imdilate(img, se);
figure, imshow(dilatedImg)
imwrite(dilatedImg, 'Graylevel_Erosion_Dilation_disk_dilation.png');

% Use line structuring element
se = strel('line', 10, 20);
dilatedImg = imdilate(img, se);
figure, imshow(dilatedImg)
imwrite(dilatedImg, 'Graylevel_Erosion_Dilation_twenty_deg_line_dilation.png');

% Use set-of-points structuring element
M = zeros(18);
M(1, 1) = 1; M(1, 10) = 1; M(1, 18) = 1;
M(10, 1) = 1; M(10, 10) = 1; M(10, 18) = 1;
M(18, 1) = 1; M(18, 10) = 1; M(18, 18) = 1;
se = strel('arbitrary', M);
dilatedImg = imdilate(img, se);
figure, imshow(dilatedImg)
imwrite(dilatedImg, 'Graylevel_Erosion_Dilation_points_dilation.png');

% Use double-line structuring element
M = zeros(18);
M(1, :) = 1; M(18, :) = 1;
se = strel('arbitrary', M);
dilatedImg = imdilate(img, se);
figure, imshow(dilatedImg)
imwrite(dilatedImg, 'Graylevel_Erosion_Dilation_double_lines_dilation.png');