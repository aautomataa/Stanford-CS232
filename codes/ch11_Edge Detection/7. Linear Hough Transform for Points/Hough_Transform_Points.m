% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Hough transform Examples

clear, clc, close all

% Load test image
bw = imread('dots.png');
% bw = imread('dashline.png');
% bw = imread('dash.png');
figure, imshow(bw), axis on;
set(gca, 'FontSize', 20);

% Show Hough transform in 2-d
% [H, theta, rho] = hough(bw, 'Theta', -90: 1 :89, 'RhoResolution', 1);
[H, theta, rho] = hough(bw);
h1 = figure; imagesc(H, 'XData', theta, 'YData', rho);
axis on, axis normal, hold on;
colormap(hot);
colorbar
xlabel('\theta', 'FontSize', 20), ylabel('\rho', 'FontSize', 20);
set(gca, 'FontSize', 20);
print(h1,'-dpng','Hough_transform_2d.png')

% Show Hough transform in 3-d
h2 = figure; mesh(H, 'XData', theta, 'YData', rho);
colormap(hot);
xlabel('\theta', 'FontSize', 20), ylabel('\rho', 'FontSize', 20);
colorbar;
axis tight;
set (gca,'Ydir','reverse')
set(gca, 'FontSize', 20);
print(h2,'-dpng','Hough_transform_3d.png');