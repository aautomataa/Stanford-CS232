% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Laplacian of Gaussian

clear, clc, close all

% Construct Laplacian of Gaussian impulse response, continuous-space
sigma = sqrt(2);
x = -4 : 0.1 : 4;
y = x;
[X, Y] = meshgrid(x, y);
Z = (-1/ (pi * sigma^4)) * (1 - (X.^2 + Y.^2) / (2 * sigma^2))...
       .* exp(- (X.^2 + Y.^2) / (2 * sigma^2));

% Construct Laplacian of Gaussian impulse response, discrete-space
h = fspecial('log', [9, 9], sigma);
h = round(h / abs(min(h(:))) * 40)
x = -4 : 1 : 4;
y = x;
[X1, Y1] = meshgrid(x, y);

% Plot impulse responses
subplot(1, 2, 1), mesh(X, Y, Z);
set(gca,'fontsize',15)
xlim([-4 4]);
ylim([-4 4]);
xlabel('X'); ylabel('Y');
subplot(1, 2, 2), mesh(X1, Y1, h);
set(gca,'fontsize',15)
xlim([-4 4]);
ylim([-4 4]);
xlabel('X'); ylabel('Y');

% Compute frequency response
[H, wx, wy] = freqz2(h, [64 64]);
wx = wx * pi;
wy = wy * pi;
[X, Y] = meshgrid(wx, wy);

% Show magnitude of frequency response
axes('Parent', figure, 'FontSize', 15);
mesh(X/pi, Y/pi, abs(H));
xlim([-1, 1]); ylim([-1, 1]);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi');
zlabel('| H(\omega_x, \omega_y) |');
set(gca, 'XTick', -1 : 0.5 : 1, 'YTick', -1 : 0.5 : 1);