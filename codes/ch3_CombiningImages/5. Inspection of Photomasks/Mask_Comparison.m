% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University 

% Script by Qiyuan Tian and David Chen
% Image subtraction example from IC manufacturing:
% die-to-die comparison of photomasks

clear, clc, close all;

% Load test images
maskImg1 = im2double(imread('mask1.png'));
maskImg2 = im2double(imread('mask2.png'));

% Perform subtraction
diffImg = abs(maskImg1 - maskImg2);
imshow(diffImg, []); title('Difference Image');
imwrite(diffImg, 'Mask_Comparison_diff.png')
