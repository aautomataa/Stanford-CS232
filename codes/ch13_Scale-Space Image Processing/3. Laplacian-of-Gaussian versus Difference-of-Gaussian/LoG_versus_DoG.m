% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% LoG vs. DoG

clear, clc, close all

x = -4 : 1 : 4;
y = x;
[X, Y] = meshgrid(x, y);

% Construct Laplacian of Gaussian
sigma = 1;
k = 1.1;
Z1 = (-1/ (pi * sigma^4)) * (1 - (X.^2 + Y.^2) / (2 * sigma^2))...
       .* exp(- (X.^2 + Y.^2) / (2 * sigma^2));

% Construct Difference of Gaussian
Z2 = 1/( (k-1)*sigma^2 ) * ...
         (1/(2*pi*k^2*sigma^2) * exp(-(X.^2 + Y.^2)/ (2*k^2*sigma^2)) - ...
         1/(2*pi*sigma^2) * exp(-(X.^2 + Y.^2)/ (2*sigma^2)) );

% Show Laplacian of Gaussian in 
subplot(1, 2, 1), mesh(X, Y, Z1);
set(gca,'fontsize',15)
xlim([-4 4]);
ylim([-4 4]);
xlabel('X'); ylabel('Y');
zlim([-0.3 0.1]);

% Show Difference of Gaussian
subplot(1, 2, 2), mesh(X, Y, Z2);
set(gca,'fontsize',15)
xlim([-4 4]);
ylim([-4 4]);
xlabel('X'); ylabel('Y');
zlim([-0.3 0.1]);

% Compute frequency responses
[H1, wx, wy] = freqz2(Z1, [64, 64]);
[H2, wx, wy] = freqz2(Z2, [64, 64]);

% Show magnitude of frequency responses
wx = wx * pi;
wy = wy * pi;
[X, Y] = meshgrid(wx, wy);
subplot(1, 2, 1), mesh(X/pi, Y/pi, abs(H1));
set(gca,'fontsize',15)
xlim([-1, 1]); ylim([-1, 1]);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi');
zlabel('| H(\omega_x, \omega_y) |');
title('Laplacian of Gaussian');
subplot(1, 2, 2), mesh(X/pi, Y/pi, abs(H2));
set(gca,'fontsize',15)
xlim([-1, 1]); ylim([-1, 1]);
xlabel('\omega_x / \pi'); ylabel('\omega_y / \pi');
zlabel('| H(\omega_x, \omega_y) |');
title('Difference of Gaussian');