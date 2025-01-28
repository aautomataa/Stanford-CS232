% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Scale space: Laplacian images

clear, clc, close all

% Load test image
img = double(imread('bike.png'));

tArray = [1, 4, 16, 64];
for i = 1 : numel(tArray)

    % Filter by Gaussian and Laplacian-of-Gaussian
    t = tArray(i);
    sigma = sqrt(t);
    fSize = ceil(sigma*3)*2 + 1; 
    h1 = fspecial('gaussian', [fSize, fSize], sigma);
    h2 = fspecial('log', [fSize, fSize], sigma);
    filteredImg1 = uint8(imfilter(img, h1, 'replicate'));
    filteredImg2 = t * imfilter(img, h2, 'replicate');

    % Binarize
    bw = filteredImg2 >=0;
    filteredImg2 = uint8(filteredImg2 + 128);

    % Show and save images
    figure
    subplot(2, 2, 1), imshow(filteredImg1);
    title(sprintf('Filtered by Gaussian, t = %d', t));
    subplot(2, 2, 2), imshow(filteredImg2); 
    title(sprintf('Filtered by LoG, t = %d', t));
    subplot(2, 2, 3), imshow(bw); 
    title(sprintf('Binarized, t = %d', t));
    imwrite(filteredImg1, ['Laplacian_gau_', num2str(t), '.png']);
    imwrite(filteredImg2, ['Laplacian_log_', num2str(t), '.png']);
    imwrite(bw, ['Laplacian_bw_', num2str(t), '.png']);

end % i