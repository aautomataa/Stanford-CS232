% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Convolution examples

clear, clc, close all

% Load test image
img = im2double(imread('croppedBike.png'));

% Construct filter impulse responses
h1 = ones(5) / 25;
h2 = ones(1, 5) / 5;
h3 = ones(5, 1) / 5;

% Perform filtering
filteredImg1 = imfilter(img, h1, 'symmetric');
filteredImg2 = imfilter(img, h2, 'symmetric');
filteredImg3 = imfilter(img, h3, 'symmetric');

% Show images
figure(1), clf;
subplot(1, 2, 1), imshow(img);
subplot(1, 2, 2), imshow(filteredImg1);
figure(2), clf;
subplot(1, 2, 1), imshow(img);
subplot(1, 2, 2), imshow(filteredImg2);
figure(3), clf;
subplot(1, 2, 1), imshow(img);
subplot(1, 2, 2), imshow(filteredImg3);

% Save images
imwrite(filteredImg1, 'Convolution_1.png');
imwrite(filteredImg2, 'Convolution_2.png');
imwrite(filteredImg3, 'Convolution_3.png');



