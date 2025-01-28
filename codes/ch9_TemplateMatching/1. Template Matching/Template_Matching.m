% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Template matching example

clear, clc, close all

% Load images
church = double(imread('church.png'));
window = double(imread('window.png'));

% Subtract means
church = church - mean(church(:));
window = window - mean(window(:));

% Perform template matching
flippedWindow = fliplr(flipud(window));
r = conv2(church, flippedWindow, 'same');
imagesc(r)
colorbar('north')
axis off
axis equal









