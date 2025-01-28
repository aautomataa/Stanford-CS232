% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Lowpass filter

clear, clc, close all;

% Construct grid of (omega_x, omega_y)
[wx,wy] = meshgrid(-3 : 0.1 : 3, -3 : 0.1 : 3);

% Compute frequency response
type = '2d';
% type = '1d_horizontal';
% type = '1d_vertical');
if strcmp(type, '2d') == 1
    H = (1/25) * (1+2 * cos(wx) + 2 * cos(2 * wx) ).* (1+2 * cos(wy) + 2 * cos(2 * wy) );
    h = 1/25 * ones(5,5);
elseif strcmp(type, '1d_horizontal') == 1
    H = (1+2 * cos(wx) + 2 * cos(2 * wx) ) / 5;
    h = 1/5 * ones(1,5);
elseif strcmp(type, '1d_vertical') == 1
    H = (1+2 * cos(wy) + 2 * cos(2 * wy) ) / 5;
    h = 1/5 * ones(5,1);
end

% Plot magnitude of frequency response
figure(1); clf;
surf(wx/pi, wy/pi, abs(H));
axis([-1 1 -1 1 0 1]);
set(gca, 'XTick', -1 : 1/2 : 1);
set(gca, 'YTick', -1 : 1/2 : 1);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi');
zlabel('| H (\omega_x, \omega_y) |');

% Apply to test image
img = imread('croppedBike.png');
imgFilt = imfilter(img, h, 'symmetric');
figure(2); clf;
subplot(1,2,1); imshow(img); title('Original Image');
subplot(1,2,2); imshow(imgFilt); title('Filtered Image');
