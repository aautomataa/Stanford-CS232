% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% RANSAC with Affine Model

% sift_mosaic function downloaded from 
% http://www.vlfeat.org/applications/sift-mosaic-code.html
% and modified by Qiyuan Tian for visualizing intermediate steps

% Add vlfeat to path
addpath('../vlfeat-0.9.16/toolbox/');
vl_setup;

% Load images
% img1 = imread('coke1.png');
% img2 = imread('coke2.png');
% img1 = imread('church1.jpg');
% img2 = imread('church2.jpg');
img1 = imread('book1.jpg');
img2 = imread('book2.jpg');

% Perform matching
sift_mosaic(img1, img2);



