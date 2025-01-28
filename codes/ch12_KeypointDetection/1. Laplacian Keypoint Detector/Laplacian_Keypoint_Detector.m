% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Example: Laplacian keypoint detector

clear, clc, close all

imageFiles = {'img2.ppm', 'img1.ppm'};
for nImage = 1:length(imageFiles)

    % Load image
    img = imread(imageFiles{nImage});
    img = im2double(img);
    [height,width,channels] = size(img);
    if nImage == 2
        [x,y] = meshgrid(1:width, 1:height);
        gradient = 0.7; % 0.8*cos(0.002*(x-width/2) -0.002*(y-height/2));
        for n = 1:3
            img(:,:,n) = img(:,:,n) .* gradient - 0.1;
        end % n
    end
    imgGray = rgb2gray(img);
    figure(1); clf;
    imshow(img); title('Original Image');
    
    % Filter with LoG
    sigma = 4;
    g = fspecial('log', [3*sigma+1, 3*sigma+1], sigma);
    imgFilt = imfilter(imgGray, g, 'replicate');
    figure(2); clf;
    imshow(imgFilt,[-0.02 0.02]); title('LoG Response');

    % Perform thresholding and find extrema
    imgFiltAbs = abs(imgFilt);
    imgFilt(find(imgFiltAbs < 0.35*max(imgFiltAbs(:)))) = 0;
    imgExtPos = imregionalmax(imgFilt);
    imgExtNeg = imregionalmax(-imgFilt);
    imgExt = max(imgExtPos, imgExtNeg);
    figure(3); clf;
    imshow(imgFilt,[-0.02 0.02]); title('Thresholded LoG Response');
    figure(4); clf;
    imshow(imdilate(imgExt, ones(3,3))); title('Local Extrema (Dilated)');

    % Show strongest keypoints
    figure(5); clf;
    imshow(img); hold on; title('Keypoints');
    [row,col] = find(imgExt == 1);
    responses = zeros(1,numel(row));
    border = sigma;
    for n = 1:numel(row)
        if (row(n) > border) && (row(n) < height-border) && ...
                (col(n) > border) && (col(n) < width-border)
            responses(n) = imgFiltAbs(row(n), col(n));
        end
    end % n
    numCorners = numel(responses)
    [responses, sortIdx] = sort(responses, 'descend');
    for n = 1:900
        h = plot(col(sortIdx(n)), row(sortIdx(n)), 'y+');
        set(h, 'MarkerSize', 3, 'MarkerFaceColor', 'y');
    end % n

    pause;

end % nImage