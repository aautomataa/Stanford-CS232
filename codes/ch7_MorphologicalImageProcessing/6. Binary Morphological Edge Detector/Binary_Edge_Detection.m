% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David chen
% Morphological edge detectors

clear, clc, close all

% Load test image
img = imread('cliparts.png');

% Extract edges
se= strel('disk', 4);
img_dilated = imdilate(img, se) ;
img_eroded = imerode(img, se) ;
edge1 = img_dilated - img;
edge2 = img - img_eroded;
edge3 = edge1 + edge2;

% Show images
subplot(2, 2, 1), imshow(img); title('Original');
subplot(2, 2, 2), imshow(edge1); title('Edge_1 = Dilated - Original');
subplot(2, 2, 3), imshow(edge1); title('Edge_2 = Original - Eroded');
subplot(2, 2, 4), imshow(edge3); title('Edge_1 + Edge_2');

imwrite(edge1, 'Edge_Detection_dilatedEdge.png');
imwrite(edge2, 'Edge_Detection_erodedEdge.png');
imwrite(edge3, 'Edge_Detection_combinedEdge.png');





