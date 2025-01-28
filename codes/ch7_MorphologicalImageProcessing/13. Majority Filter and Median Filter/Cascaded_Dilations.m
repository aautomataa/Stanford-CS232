% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Cascaded dilations

clear, clc, close all;

% Load test image
img = imread('butterfly.png');

% Define different structuring elements
se1 = strel('line', 10, 0);
se2 = strel('line', 10, -45);
se3 = strel('line', 10, -135);

% Perform sequence of dilations
dilatedImg1 = imdilate(img, se1);
dilatedImg2 = imdilate(dilatedImg1, se2);
dilatedImg3 = imdilate(dilatedImg2, se3);

% Show images
subplot(2, 2, 1), imshow(img);
subplot(2, 2, 2), imshow(dilatedImg1);
subplot(2, 2, 3), imshow(dilatedImg2);
subplot(2, 2, 4), imshow(dilatedImg3);

% Save images
imwrite(dilatedImg1, 'Cascaded_Dilations_1.png');
imwrite(dilatedImg2, 'Cascaded_Dilations_2.png');
imwrite(dilatedImg3, 'Cascaded_Dilations_3.png');



