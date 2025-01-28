% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Edge operators

clear, clc, close all

%% Prewitt 

% Apply Prewitt filter in vertical direction
img = double(imread('bike.png'));
h = fspecial('prewitt'); 
filteredImg1 = imfilter(img, h', 'replicate');
filteredImg1 = abs(filteredImg1);
filteredImg1 = filteredImg1 / max(filteredImg1(:));

% Apply Prewitt filter in horizontal direction
filteredImg2 = imfilter(img, h, 'replicate');
filteredImg2 = abs(filteredImg2);
filteredImg2 = filteredImg2 / max(filteredImg2(:));

% Show and save images
figure(1), clf;
subplot(1, 3, 1), imshow(uint8(img)); title('Original');
subplot(1, 3, 2), imshow(filteredImg1); title('Prewitt Horizontal');
subplot(1, 3, 3), imshow(filteredImg2); title('Prewitt Vertical');
imwrite(filteredImg1, 'Prewitt_bike_horizontal.png');
imwrite(filteredImg2, 'Prewitt_bike_vertical.png');

%% Prewitt

% Apply Prewitt filter in vertical direction
img = double(imread('berndsface.png'));
h = fspecial('prewitt'); 
filteredImg1 = imfilter(img, h', 'replicate');
filteredImg1 = log(abs(filteredImg1) + 1);
filteredImg1 = filteredImg1 / max(filteredImg1(:));

% Apply Prewitt filter in horizontal direction
filteredImg2 = double(imfilter(img, h, 'replicate'));
filteredImg2 = log(abs(filteredImg2) + 1);
filteredImg2 = filteredImg2 / max(filteredImg2(:));

% Show and save images
figure(2), clf;
subplot(1, 3, 1), imshow(uint8(img)); title('Original');
subplot(1, 3, 2), imshow(filteredImg1); title('Prewitt Horizontal');
subplot(1, 3, 3), imshow(filteredImg2); title('Prewitt Vertical');
imwrite(filteredImg1, 'Prewitt_face_horizontal.png');
imwrite(filteredImg2, 'Prewitt_face_vertical.png');

%% Prewitt

% Apply Prewitt in vertical and horizontal directions
img = double(imread('berndsface.png'));
h = fspecial('prewitt'); 
filteredImg1 = imfilter(img, h', 'replicate');
filteredImg2 = double(imfilter(img, h, 'replicate'));

% Threshold based on edge magnitude response
edgeSum = filteredImg1.^2 + filteredImg2.^2;
logEdgeSum = log(edgeSum + 1);
logEdgeSum = logEdgeSum / max(logEdgeSum(:));
bwEdge1 = edgeSum > 900;
bwEdge2 = edgeSum > 4500;
bwEdge3 = edgeSum > 7200;

% Show and save images
figure(3), clf;
subplot(2, 2, 1), imshow(logEdgeSum); title('Edge Magnitude');
subplot(2, 2, 2), imshow(bwEdge1); title('Magnitude > 900');
subplot(2, 2, 3), imshow(bwEdge2); title('Magnitude > 4500');
subplot(2, 2, 4), imshow(bwEdge3); title('Magnitude > 7200');
imwrite(logEdgeSum, 'Prewitt_face_logEdgeSum.png');
imwrite(bwEdge1, 'Prewitt_face_bwEdge1.png');
imwrite(bwEdge2, 'Prewitt_face_bwEdge2.png');
imwrite(bwEdge3, 'Prewitt_face_bwEdge3.png');

%% Sobel

% Apply Sobel in vertical and horizontal directions
img = double(imread('berndsface.png'));
h = fspecial('sobel'); 
filteredImg1 = imfilter(img, h', 'replicate');
filteredImg2 = double(imfilter(img, h, 'replicate'));

% Threshold based on edge magnitude response
edgeSum = filteredImg1.^2 + filteredImg2.^2;
logEdgeSum = log(edgeSum + 1);
logEdgeSum = logEdgeSum / max(logEdgeSum(:));
bwEdge1 = edgeSum > 1600; % (4/3)^2 times the value for Prewitt
bwEdge2 = edgeSum > 8000;
bwEdge3 = edgeSum > 12800;

% Show and save images
figure(4), clf;
subplot(2, 2, 1), imshow(logEdgeSum); title('Edge Magnitude');
subplot(2, 2, 2), imshow(bwEdge1); title('Magnitude > 1600');
subplot(2, 2, 3), imshow(bwEdge2); title('Magnitude > 8000');
subplot(2, 2, 4), imshow(bwEdge3); title('Magnitude > 12800');
imwrite(logEdgeSum, 'Sobel_face_logEdgeSum.png');
imwrite(bwEdge1, 'Sobel_face_bwEdge1.png');
imwrite(bwEdge2, 'Sobel_face_bwEdge2.png');
imwrite(bwEdge3, 'Sobel_face_bwEdge3.png');

%% Roberts

% Apply Roberts filter #1
img = double(imread('berndsface.png'));
h = [1, 0; 0, -1];
filteredImg1 = imfilter(img, h', 'replicate');
filteredImg1 = log(abs(filteredImg1) + 1);
filteredImg1 = filteredImg1 / max(filteredImg1(:));

% Apply Roberts filter #2
h = [0, 1; -1, 0];
filteredImg2 = double(imfilter(img, h, 'replicate'));
filteredImg2 = log(abs(filteredImg2) + 1);
filteredImg2 = filteredImg2 / max(filteredImg2(:));

% Show and save images
figure(5), clf;
subplot(1, 3, 1), imshow(uint8(img)); title('Original');
subplot(1, 3, 2), imshow(filteredImg1); title('Roberts Diagonal');
subplot(1, 3, 3), imshow(filteredImg2); title('Roberts Anti-Diagonal');
imwrite(filteredImg1, 'Roberts_face_vertical.png');
imwrite(filteredImg2, 'Roberts_face_horizontal.png');

%% Roberts

% Apply Roberts filter in two directions
img = double(imread('berndsface.png'));
h = [1, 0; 0, -1];
filteredImg1 = imfilter(img, h', 'replicate');
h = [0, 1; -1, 0];
filteredImg2 = double(imfilter(img, h, 'replicate'));

% Threshold based on edge magnitude response
edgeSum = filteredImg1.^2 + filteredImg2.^2;
logEdgeSum = log(edgeSum + 1);
logEdgeSum = logEdgeSum / max(logEdgeSum(:));
bwEdge1 = edgeSum > 100;
bwEdge2 = edgeSum > 500;
bwEdge3 = edgeSum > 800;

% Show and save images
figure(6), clf;
subplot(2, 2, 1), imshow(logEdgeSum); title('Edge Magnitude');
subplot(2, 2, 2), imshow(bwEdge1); title('Magnitude > 100');
subplot(2, 2, 3), imshow(bwEdge2); title('Magnitude > 500');
subplot(2, 2, 4), imshow(bwEdge3); title('Magnitude > 800');
imwrite(logEdgeSum, 'Roberts_face_logEdgeSum.png');
imwrite(bwEdge1, 'Roberts_face_bwEdge1.png');
imwrite(bwEdge2, 'Roberts_face_bwEdge2.png');
imwrite(bwEdge3, 'Roberts_face_bwEdge3.png');