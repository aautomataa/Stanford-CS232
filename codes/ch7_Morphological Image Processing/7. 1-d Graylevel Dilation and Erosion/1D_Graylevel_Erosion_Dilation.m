% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% 1-d illustration of erosion and dilation

clear, clc, close all;

% Load test image
img = imread('peter.png');

% Pick out column for 1-d example
originalSignal = img(150 : 249, 180)';

% Loop over different lengths of SE
for len = 1 : 2 : 21

    se = strel('line', len, 0);
    dilatedSignal = imdilate(originalSignal, se);
    erodedSignal = imerode(originalSignal, se);

    axes('Parent', figure, 'FontSize', 15);
    plot(originalSignal, 'bo'), hold on;
    plot(originalSignal, 'b--')
    plot(dilatedSignal, 'r');
    plot(erodedSignal, 'g');
    title(['Structure element length = ', num2str(len)]);
    saveas(gcf, ['1D_Erosion_Dilation_' num2str(len) '.png']);

end % len







