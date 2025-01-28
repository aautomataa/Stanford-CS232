% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Scale space as heat diffusion

clear, clc, close all;

% Load test image
img = im2double(imread('bike.png'));

% Generate heat diffusion sequence
figure(1); clf;
set(gcf, 'Color', 'k', 'Position', [100 100 700 600]);
imgFilt = img;
sigma = 1;
w = round(20*sigma)+1;
g = fspecial('gaussian', [w w], sigma);
fps = 15;
saveMovie = 1;
if saveMovie
    writerObj = VideoWriter('Heat_Diffusion', 'Motion JPEG AVI');
    writerObj.FrameRate = fps;
    writerObj.Quality = 95;
    open(writerObj);    
end
for t = 1:1:500
    disp(t);
    imshow(imgFilt); colormap hot; 
    colorbar('YTickLabel', {'Cold', 'Hot'}, 'YTick', [0 1], 'FontSize', 15);
    h = text(550, -40, sprintf('t = %.02f sec', t/fps), 'FontSize', 15);
    set(h, 'Color', 'w');
    if saveMovie
        F = getframe(1);
        writeVideo(writerObj,F);
    end
    imgFilt = imfilter(imgFilt, g, 'replicate', 'conv');
end
if saveMovie
    close(writerObj);
end