% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Scale-space representation of a signal

clear, clc, close all

% Load 1-d signal
load('wave.mat');
wave = wave - mean(wave);

% Create Gaussian filter
gaussianFilter = fspecial('gaussian',[1 50], 3);
figure, plot(gaussianFilter); title('Gaussian Filter');

% Generate progressively smoother signals
number = 1000;
smoothedWave = zeros(number + 1, numel(wave));
smoothedWave(1, :) = wave;
for i = 1 : number
    smoothedWave(i + 1, :) = imfilter(smoothedWave(i, :),  gaussianFilter, 'replicate');
end %end i

% Show samples in space space
x = 1 : numel(wave);
sVec = [1 2 4 8 16 32 64 128 256 512].';
figure
for n = 1:numel(sVec)
    plot(x, smoothedWave(sVec(n), :)+n-1, 'LineWidth', 2, 'LineSmoothing','on')
    hold on, axis off
end % n

% Find zero crossings of 2nd derivative
smoothedWave = smoothedWave(1 : number, :);
dif1 = smoothedWave - [zeros(size(smoothedWave, 1), 1), smoothedWave(:, 1 : end -1)];
dif2 = dif1 - [zeros(size(dif1, 1), 1), dif1(:, 1 : end -1)];
bw = dif2 .* [dif2(:, 2 : end), dif2(:, 1)];
bw = bw(:, 4 : end-4);
bw = bw < 0;

% Show zero crossings of 2nd derivative
bw = flipud(bw);
se = strel('disk', 3);
bw = imdilate(bw, se);
bw = 1- bw;
figure, imagesc(bw)
colormap('gray')
axis off













