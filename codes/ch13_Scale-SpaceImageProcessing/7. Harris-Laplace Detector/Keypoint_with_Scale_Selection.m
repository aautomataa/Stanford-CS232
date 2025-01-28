% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Keypoint detection with automatic scale selection

% Codes downloaded from 
% http://www.mathworks.com/matlabcentral/fileexchange/17894-keypoint-extraction

clear, clc, close all
img = imread('sunflower.jpg'); numBlobs = 150;
% img = imread('dog.jpg'); numBlobs = 200;
if size(img,3) > 1
    imgGray = rgb2gray(img);
else
    imgGray = img;
end
pt  = kp_log(imgGray, numBlobs);
draw(rgb2gray(img),pt,'LoG Lindeberg');
set(gcf, 'Color', 'w');

figure;
imshow(imgGray);
set(gcf, 'Color', 'w');
