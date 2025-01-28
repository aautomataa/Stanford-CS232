% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Example: blob separation/ detection by erosion

clear, clc, close all

% Load test image
img = imread('circles.png');

% Perform erosion with square
seType = 'square';
se1 = strel(seType, 30);
BW1 = imerode(img, se1);

% Perform erosion with square
se2 = strel(seType, 70);
BW2 = imerode(img, se2);

% Perform erosion with square
se3 = strel(seType, 96);
BW3 = imerode(img, se3);

% Show images
figure(1); clf;
subplot(2, 2, 1), imshow(img); title('Original Image');
subplot(2, 2, 2), imshow(BW1); title('Eroded by Square of Width 30');
subplot(2, 2, 3), imshow(BW2); title('Eroded by Square of Width 70');
subplot(2, 2, 4), imshow(BW3); title('Eroded by Square of Width 96');

% Save images
imwrite(BW1, 'Binary_Erosion_Coins_square_30.png');
imwrite(BW2, 'Binary_Erosion_Coins_square_70.png');
imwrite(BW3, 'Binary_Erosion_Coins_square_90.png');

% Perform erosion with circle
seType = 'disk';
se1 = strel(seType, 15);
BW1 = imerode(img, se1);

% Perform erosion with circle
se2 = strel(seType, 35);
BW2 = imerode(img, se2);

% Perform erosion with circle
se3 = strel(seType, 48);
BW3 = imerode(img, se3);

% Show images
figure(2); clf;
subplot(2, 2, 1), imshow(img); title('Original Image');
subplot(2, 2, 2), imshow(BW1); title('Eroded by Disk of Radius 15');
subplot(2, 2, 3), imshow(BW2); title('Eroded by Disk of Radius 35');
subplot(2, 2, 4), imshow(BW3); title('Eroded by Disk of Radius 48');

% Save images
imwrite(BW1, 'Binary_Erosion_Coins_disk_15.png');
imwrite(BW2, 'Binary_Erosion_Coins_disk_35.png');
imwrite(BW3, 'Binary_Erosion_Coins_disk_45.png');









