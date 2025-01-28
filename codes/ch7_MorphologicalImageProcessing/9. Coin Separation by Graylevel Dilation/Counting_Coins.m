% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Example: counting coins

clear, clc, close all

% Load test image
img = imread('coins.png');
figure(1); clf;
subplot(1, 3, 1); imshow(img); title('Original Image');

% Binarize original image
level = graythresh(img);
bwImg1 = 1- im2bw(img, level);
subplot(1, 3, 2); imshow(bwImg1); title('Binarized Image');

% Perform region labeling
L = bwlabel(bwImg1, 8);
rgbLabel1 = label2rgb(L, 'jet', 'k');
subplot(1, 3, 3); imshow(rgbLabel1); title('Labeled Regions');

% Graylevel dilation with disk structuring element
seType = 'disk';
se = strel(seType, 30);
dilatedImg = imdilate(img, se);
figure(2); clf;
subplot(1, 3,1); imshow(dilatedImg); title('Dilated Image');

% Binarize dilated image
level = graythresh(dilatedImg);
bwImg2 = 1 - im2bw(dilatedImg, level);
subplot(1, 3, 2); imshow(bwImg2); title('Binarized Image');

% Perform region labeling
L = bwlabel(bwImg2, 8);
rgbLabel2 = label2rgb(L, 'jet', 'k');
subplot(1, 3, 3); imshow(rgbLabel2); title('Labeled Regions');

% Save results
imwrite(bwImg1, 'Counting_Coins_bw1.png');
imwrite(bwImg2, 'Counting_Coins_bw2.png');
imwrite(rgbLabel1, 'Counting_Coins_label1.png');
imwrite(rgbLabel2, 'Counting_Coins_label2.png');
imwrite(dilatedImg, 'Counting_Coins_dilated.png');











