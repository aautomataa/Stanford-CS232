% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Example: circle detection by Hough transform

clear, clc, close all

% Load test image
img = imread('coins.png');
figure, imshow(img); title('Original Image');

% Extract edges
bw = edge(img, 'prewitt', 0.15);
figure, imshow(bw); title('Edge Detection by Prewitt');

% Find circles using Hough transform
[centers, radii, metric] = imfindcircles(bw, [70 100], 'Sensitivity', 0.9);
figure, imshow(img), hold on;
plot(centers(:, 1), centers(:, 2), 'xr',  'MarkerSize',15, 'LineWidth', 3);
viscircles(centers, radii, 'EdgeColor','b', 'LineWidth', 3);