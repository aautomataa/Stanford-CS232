% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Matched filtering

clear, clc, close all

%% Define letters

halfWidth = 3;
halfHeight = 3;
originX = halfWidth + 1;
originY = halfHeight + 1;
xRange = -halfWidth:halfWidth;
yRange = -halfHeight:halfHeight;

img0 = zeros(2*halfHeight+1, 2*halfWidth+1);
img0(originY-2:originY+2, originX-1:originX+1) = 1;
img0(originY-1:originY+1, originX) = 0;

img1 = zeros(2*halfHeight+1, 2*halfWidth+1);
img1(originY-2:originY+2, originX) = 1;
img1(originY-2, originX-1:originX) = 1;
img1(originY+2, originX-1:originX+1) = 1;

img2 = img0;
img2(originY-1:originY+1,originX-1) = 0;
img2(originY+1,originX+1) = 0;
img2(originY, originX-1:originX+1) = 1;
img2(originY+1, originX-1) = 1;

img3 = img0;
img3(originY-1, originX-1) = 0;
img3(originY+1, originX-1) = 0;
img3(originY, originX) = 1;

img4 = img0;
img4(originY-2, originX) = 0;
img4(originY+1:originY+2, originX-1) = 0;
img4(originY+2, originX) = 0;
img4(originY, originX) = 1;

img5 = img0;
img5(originY, originX) = 1;
img5(originY-1, originX+1) = 0;
img5(originY+1, originX-1) = 0;

img6 = img0;
img6(originY, originX) = 1;
img6(originY-1, originX+1) = 0;

img7 = img0;
img7(originY-1:originY+2, originX-1) = 0;
img7(originY+2, originX) = 0;

img8 = img0;
img8(originY, originX) = 1;

img9 = img4;
img9(originY-2, originX) = 1;

figure(1); clf; set(gcf, 'Position', [50 100 1200 500]);
subplot(2,5,1);
imshow(img0, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,2);
imshow(img1, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,3);
imshow(img2, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,4);
imshow(img3, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,5);
imshow(img4, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,6);
imshow(img5, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,7);
imshow(img6, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,8);
imshow(img7, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,9);
imshow(img8, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

subplot(2,5,10);
imshow(img9, 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit');
axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

collage = [img0 img1 img2 img3 img4 img5 img6 img7 img8 img9];
figure(2); clf; set(gcf, 'Position', [200 200 1000 300]);
imshow(collage, 'InitialMagnification', 'fit');

%% Perform template matching

collageTempMatch = imfilter(collage, img8, 'corr');
collageTempMatch = collageTempMatch / max(collageTempMatch(:));
figure(3); clf; set(gcf, 'Position', [300 300 1000 300]);
imshow(collageTempMatch, 'InitialMagnification', 'fit');

%% Compute frequency responses

[omegaX, omegaY] = meshgrid(linspace(-pi,pi,400), linspace(-pi,pi,400));
img0FR = zeros(size(omegaX));
img6FR = zeros(size(omegaX));
img8FR = zeros(size(omegaX));
for x = -halfWidth : halfWidth
    for y = -halfHeight : halfHeight
        img0FR = img0FR + img0(y+originY,x+originX)*exp(-j*omegaX*x).*exp(-j*omegaY*y);
        img6FR = img6FR + img6(y+originY,x+originX)*exp(-j*omegaX*x).*exp(-j*omegaY*y);
        img8FR = img8FR + img8(y+originY,x+originX)*exp(-j*omegaX*x).*exp(-j*omegaY*y);
    end % y
end % x

%% Performed matched filtering in frequency domain

threshold = 0.5;

img0PSD = abs(img0FR).^2;
img0PSDInv = 1 ./ img0PSD;
idxLow = find(img0PSD < threshold);
img0PSDInv(idxLow) = 1/threshold;

img6PSD = abs(img6FR).^2;
img6PSDInv = 1 ./ img6PSD;
idxLow = find(img6PSD < threshold);
img6PSDInv(idxLow) = 1/threshold;

img06PSD = 0.5*(img0PSD + img6PSD);
img06PSDInv = 1 ./ img06PSD;
idxLow = find(img06PSD < threshold);
img06PSDInv(idxLow) = 1/threshold;

matchFR = conj(img8FR) .* img06PSDInv;

figure(4); clf; colormap gray; shading interp;
subplot(1,3,1);
mesh(omegaX, omegaY, img06PSD);
xlabel('\omega_x'); ylabel('\omega_y'); zlabel('\Phi_n_n');
title('Power Spectral Density of Clutter');
axis([-pi pi -pi pi 0 max(img06PSD(:))]);
set(gca, 'XTick', -pi:pi/2:pi, 'YTick', -pi:pi/2:pi);
set(gca, 'XTickLabel', {}, 'YTickLabel', {});

subplot(1,3,2);
mesh(omegaX, omegaY, abs(img8FR));
xlabel('\omega_x'); ylabel('\omega_y'); zlabel('|T|');
title('Frequency Response of Template');
axis([-pi pi -pi pi 0 max(abs(img8FR(:)))]);
set(gca, 'XTick', -pi:pi/2:pi, 'YTick', -pi:pi/2:pi);
set(gca, 'XTickLabel', {}, 'YTickLabel', {});

subplot(1,3,3);
mesh(omegaX, omegaY, abs(matchFR));
xlabel('\omega_x'); ylabel('\omega_y'); zlabel('|G|');
title('Frequency Response of Matched Filter');
axis([-pi pi -pi pi 0 max(abs(matchFR(:)))]);
set(gca, 'XTick', -pi:pi/2:pi, 'YTick', -pi:pi/2:pi);
set(gca, 'XTickLabel', {}, 'YTickLabel', {});

%% Convert matched filtering result to spatial domain

matchIR = zeros(size(img0));
for x = -halfWidth : halfWidth
    for y = -halfHeight : halfHeight
        matchIR(y+originY,x+originX) = sum(sum( matchFR .* exp(j*omegaX*x) .* exp(j*omegaY*y) ));
    end % y
end % x
matchIR = real(matchIR);
matchIR = matchIR / max(matchIR(:));
figure(5); clf;
imshow(matchIR, [-0.7 1], 'XData', xRange, 'YData', yRange, ...
    'InitialMagnification', 'fit'); colorbar;
% axis on; axis square; set(gca, 'XTick', xRange, 'YTick', yRange);

%% Show results

collageMatchFilt = imfilter(collage, imrotate(matchIR, 180), 'corr');
collageMatchFilt = collageMatchFilt / max(collageMatchFilt(:));
figure(6); clf; set(gcf, 'Position', [300 300 1000 300]);
imshow(collageMatchFilt, 'InitialMagnification', 'fit');