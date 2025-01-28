% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Example: Separable Haar transform

% haarmtx function downloaded from 
% http://www.mathworks.com/matlabcentral/fileexchange/4619-haarmtx

clear, clc, close all

% Load test image
img = double(imread('croppedBike.png'));

% Form Haar matrices
H1=haarmtx(size(img, 1));
H2=haarmtx(size(img, 2));

% Perform Haar transform
haarCoeff = H1' * img * H2;

% Show results
subplot(1, 2, 1), imshow(img, []); title('Original Image');
subplot(1, 2, 2), imshow(haarCoeff, [-50 50]); title('Haar Transform');



