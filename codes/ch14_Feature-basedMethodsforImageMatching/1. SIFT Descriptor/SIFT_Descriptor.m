% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% SIFT Descriptors

clear, clc, close all

% Add vlfeat to path
addpath('../vlfeat-0.9.16/toolbox/');
vl_setup;

% Load test images
img = rgb2gray(imread('gates.jpg'));
figure, imshow(img);

% Extract SIFT features
img = single(img);
[height, width] = size(img);
[f,d] = vl_sift(img, 'PeakThresh', 5) ;

% Visualize descriptors
perm = randperm(size(f,2)) ;
sel = perm(1:15) ;
% sel = 1000: 1030 ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h1,'color','k','linewidth', 3) ;
set(h2,'color','y','linewidth', 2) ;
set(h3,'color','g','linewidth', 1) ;