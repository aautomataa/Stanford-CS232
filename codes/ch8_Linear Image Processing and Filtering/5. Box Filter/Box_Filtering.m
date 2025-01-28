% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Box filtering

clear, clc, close all

% Define 1-d Gaussian and box filters
sigma = 1;
x = linspace(-4*sigma,4*sigma,501);
g1 = exp(-x.^2 / (2*sigma^2)) / sqrt(2*pi*sigma^2);
N = 5;
w = sqrt(12 * sigma^2 / N);
b = double(abs(x) < w/2) * 1/w;
g2 = b;
for n = 2:N
    g2 = conv(g2, b, 'same');
end

% Show 1-d signals
figure(1); clf;
plot(x,g1,'Color','black','LineWidth',5); axis off;
figure(2); clf;
plot(x,b,'Color','black','LineWidth',5); axis off;
figure(3); clf;
plot(x,g2,'Color','black','LineWidth',5); axis off;

% Load test image
img = imread('01.jpg');
img = rgb2gray(img);
imwrite(img, 'gray.jpg');

% Filter by Gaussian
sigma = 20;
g = fspecial('gaussian', [4*sigma+1 4*sigma+1], sigma);
img_g = imfilter(img, g, 'replicate');
figure(4); clf;
imshow(img_g); title('Filtered by Gaussian');
imwrite(img_g, 'img_g.jpg');

% Filter by box
[X,Y] = meshgrid(-5*sigma:5*sigma, -5*sigma:5*sigma);
N = 5;
w = sqrt(12 * sigma^2 / N);
b = double(abs(X) < w/2) .* double(abs(Y) < w/2);
b = b/sum(b(:));
img_b = img;
for n = 1:N
    disp(n)
    img_b = imfilter(img_b, b, 'replicate');
    figure(4+n); clf;
    imshow(img_b); 
    if n == 1
        title(sprintf('Filtered by %d Box', n));
    else
        title(sprintf('Filtered by %d Boxes', n));
    end
    imwrite(img_b, sprintf('img_b_%d.jpg', n));
end % 