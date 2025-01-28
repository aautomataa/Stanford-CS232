% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% FAST corners 

addpath fast-matlab-src
imageFiles = {'019_Reference.jpg', '019_Palm.jpg'};
for nImage = 1:length(imageFiles)

    % Load image
    img = imread(imageFiles{nImage});
    targetHeight = 480;
    targetWidth = round( size(img,2) * targetHeight / size(img,1) );
    img = imresize(img, [targetHeight targetWidth]);
    imgGray = rgb2gray(img);
    [height, width] = size(imgGray);
    figure(1); clf;
    imshow(img); title('Original Image');

    % Calculate FAST corners
    imgGrayDouble = double(imgGray);
    cs = fast_corner_detect_9(imgGrayDouble, 50);
    c = fast_nonmax(imgGrayDouble, 50, cs);
    figure(2); clf;
    imshow(img); hold on; title('Fast Corners');
    h = plot(cs(:,1), cs(:,2), 'k+');
    set(h, 'MarkerSize', 3);
    h = plot(cs(:,1)+0.5, cs(:,2)+0.5, 'y+');
    set(h, 'MarkerSize', 3);
    
    figure(3); clf;
    imshow(img); hold on; title('Fast Corners, Non-max Suppressed');
    h = plot(c(:,1), c(:,2), 'k+');
    set(h, 'MarkerSize', 5);
    h = plot(c(:,1)+0.5, c(:,2)+0.5, 'y+');
    set(h, 'MarkerSize', 5);

    pause;

end % nImage