% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Scale space: edge detection

clear, clc, close all

% Load test image
img = double(imread('bike.png'));

tArray = [1, 4, 16, 64];
threshArray = [9 1 0.05 0.005];
for i = 1 : numel(tArray)

    % Filter by LoG and detect zero crossings
    t = tArray(i);
    sigma = sqrt(t);
    imgEdge1 = edge(img, 'log', 0, sigma);
    thresh = threshArray(i);
    [imgEdge2, thresh] = edge(img, 'log', thresh, sigma);
    disp(sprintf('t = %d, thresh = %.2f', t, thresh));
    
    % Show and save images
    figure, 
    subplot(1, 2, 1), imshow(imgEdge1);
    subplot(1, 2, 2), imshow(imgEdge2);
    imwrite(imgEdge1, ['Laplacian_edge1_', num2str(t), '.png']);
    imwrite(imgEdge2, ['Laplacian_edge2_', num2str(t), '.png']);

end % i