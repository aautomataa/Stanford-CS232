% EE368 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Zero crossings of LoG

clear, clc, close all

% Load test image
img = imread('berndsface.png');

% Loop over different standard deviations of Gaussian
% Use no threshold on edge response
thresh = 0;
sigmaArray = [sqrt(2), sqrt(8), sqrt(32), sqrt(128)];
figure(1), clf;
for i = 1 : numel(sigmaArray)
    % Compute and show zero crossings
    sigma = sigmaArray(i);
    bw = edge(img,'log', thresh, sigma);
    subplot(2, 2, i), imshow(bw); title(sprintf('Sigma = %f', sigmaArray(i)));
    imwrite(bw, ['Zero_crossings_log_no_thresh_' num2str(sigmaArray(i)), '.png']);
end % end i

% Loop over different standard deviations of Gaussian
% Use threshold on edge response
sigmaArray = [sqrt(2), sqrt(8), sqrt(32), sqrt(128)];
thresh =[0.002, 0.0008, 0.0002, 0.00004];
figure(2), clf;
for i = 1 : numel(sigmaArray)
    % Compute and show zero crossings
    sigma = sigmaArray(i);
    bw = edge(img,'log', thresh(i), sigma);
    subplot(2, 2, i), imshow(bw); title(sprintf('Sigma = %f', sigmaArray(i)));
    imwrite(bw, ['Zero_crossings_log_thresh_' num2str(sigmaArray(i)), '.png']);
end % end i