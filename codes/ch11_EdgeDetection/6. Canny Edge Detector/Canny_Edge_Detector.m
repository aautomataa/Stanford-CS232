% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Canny edge detector

clear, clc, close all

% Load test image
img = imread('berndsface.png');

% Loop over different standard deviations of Gaussian
sigmaArray = [sqrt(2), sqrt(8), sqrt(32)];
thresh = 0.3;
figure(1), clf;
subplot(2, 2, 1), imshow(img); title('Original');
for i = 1 : numel(sigmaArray)
    % Compute and show Canny edges
    sigma = sigmaArray(i);
    bw = edge(img, 'canny', thresh, sigma); 
    subplot(2, 2, i + 1), imshow(bw); title(sprintf('sigma = %.2f', sigma));
    imwrite(bw, ['Canny_face_' num2str(sigma), '.png']);
end % end i

% Load test image
img = imread('bike.png');

% Compute and show Canny edges
sigma = sigmaArray(1);
bw = edge(img, 'canny', thresh, sigma); 
figure(2), clf;
subplot(1, 2, 1), imshow(img); title('Original');
subplot(1, 2, 2), imshow(bw); title(sprintf('sigma = %.2f', sigma));
imwrite(bw, ['Canny_bike_' num2str(sigma), '.png']);









