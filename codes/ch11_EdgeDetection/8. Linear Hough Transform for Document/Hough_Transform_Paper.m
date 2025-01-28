% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Hough transform example

clear, clc, close all

% Load test image
img = imread('paper.jpg');
figure(1), clf, imshow(img);

% Binarize image
level = graythresh(img);
bwImg = 1 - im2bw(img, level);
col = size(bwImg, 2);
figure(2), clf, imshow(bwImg);
imwrite(bwImg, 'Hough_Transform_Paper_bw.png');

% Compute Hough transform
[H, theta, rho] = hough(bwImg, 'RhoResolution', 1, 'Theta', -90:0.1:89.5);
figure(3), clf; 
imagesc(H, 'XData', theta, 'YData', rho);
axis on, axis normal, hold on;
colormap(hot), colorbar
% xlabel('\theta', 'FontSize', 20), ylabel('\rho', 'FontSize', 20);
set(gca, 'FontSize', 20);

% Detect peaks in Hough transform
peakNum = 10;
P = houghpeaks(H, peakNum, 'threshold', ceil(0.2*max(H(:))));
lines = houghlines(bwImg, theta, rho, P, 'FillGap', 5, 'MinLength', 1);
thetaPeaks = theta(P(:, 2));
rhoPeaks = rho(P(:,1));
plot(thetaPeaks, rhoPeaks, 'o', 'color', 'Y', 'LineWidth', 2);

% Find orientation histogram from peaks
thetaBins = -90:90;
thetaHist = hist(thetaPeaks, thetaBins);
figure(4); clf;
bar(thetaBins, thetaHist);
xlabel('Angle (degrees)'); ylabel('Number of Hough Peaks');

% Rotate by orientation of longest line
angle = median(thetaPeaks);
deskewedImg = imrotate(img, 90 + angle, 'bicubic', 'crop');
imwrite(deskewedImg, 'Hough_Transform_Paper_deskew.png');
figure(5), clf, imshow(deskewedImg);