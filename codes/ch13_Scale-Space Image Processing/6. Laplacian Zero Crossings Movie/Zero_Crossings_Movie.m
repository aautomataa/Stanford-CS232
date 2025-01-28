% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Laplacian zero crossings in scale space

clear, clc, close all;

% Load test image
img = im2double(imread('bike.png'));

% Generate sequence of zero crossings
figure(1); clf;
set(gcf, 'Color', 'k', 'Position', [100 100 700 600]);
fps = 15;
saveMovie = 1;
if saveMovie
    writerObj = VideoWriter('chap8_zero-cross', 'Motion JPEG AVI');
    writerObj.FrameRate = fps;
    writerObj.Quality = 95;
    open(writerObj);
end
for t = 1:1:500
    disp(t);
    sigma = sqrt(0.1*t);
    imgEdge = edge(img, 'log', 0, sigma);
    imshow(imgEdge); colormap gray;
    h = text(550, -12, sprintf('t = %.02f sec', t/fps), 'FontSize', 15);
    set(h, 'Color', 'w');
    if saveMovie
        F = getframe(1);
        writeVideo(writerObj,F);
    end
    pause(0.1);
end
if saveMovie
    close(writerObj);
end