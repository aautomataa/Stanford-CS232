% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by Qiyuan Tian and David Chen
% Contour plot of Harris cornerness

clear, clc, close all

lambda1 = 0 : 0.1 : 5;
lambda2 = 0 : 0.1 : 5;
[L1, L2] = meshgrid(lambda1, lambda2);
% k = 0.05;
k = 0.2;
c = L1 .* L2 - k * (L1 + L2).^2;

axes('Parent', figure, 'FontSize', 15);
[C, h] = contour(L1, L2, c);
set(h,'ShowText','on');
xlabel('\lambda_1'); ylabel('\lambda_2');
title(['Contour of C(x, y) for k =', num2str(k)]);
axis equal, axis([0 5 0 5])