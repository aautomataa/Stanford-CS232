% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Laplacian operator

clear, clc, close all

% Define Laplacian impulse response
h = [0, 1, 0; 1, -4, 1; 0, 1, 0];
% h = ones(3); h(2, 2) = -8;

% Calculate frequency response
[H, wx, wy] = freqz2(h, [64 64]);
wx = wx * pi;
wy = wy * pi;
[X, Y] = meshgrid(wx, wy);

% Show frequency response
axes('Parent', figure, 'FontSize', 15);
mesh(X/pi, Y/pi, abs(H));
xlim([-1, 1]); ylim([-1, 1]);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi');
zlabel('| H(\omega_x, \omega_y) |');
set(gca, 'XTick', -1 : 0.5 : 1, 'YTick', -1 : 0.5 : 1);









