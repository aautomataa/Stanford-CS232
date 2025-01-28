% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen
% Harris detector

clear, clc, close all

imageFiles = {'ukbench00732.jpg', 'ukbench00733.jpg'};
for nImage = 1:length(imageFiles)

    % Load image
    img = imread(imageFiles{nImage});
    img = im2double(img);
    imgGray = rgb2gray(img);
    figure(1); clf;
    imshow(img); title('Original Image');

    % Calculate Harris corner-ness
    C = cornermetric(imgGray, 'Harris', 'SensitivityFactor', 0.04);
    figure(2); clf;
    imshow(C,[-2 4]*1e-3); % colorbar; 
    title('Harris Cornerness');

    % Find extrema
    C(find(C < 0.01*max(C(:)))) = 0;
    imgExt = imregionalmax(C);
    figure(3); clf;
    imshow(C,[-2 4]*1e-3); title('Local Maxima');
    figure(4); clf;
    imshow(imdilate(imgExt, ones(3,3))); title('Local Maxima (Dilated)');

    % Show strongest keypoints
    numCorners = sum(imgExt(:))
    figure(5); clf;
    imshow(img); hold on; title('Harris Keypoints');
    [row,col] = find(imgExt == 1);
    responses = zeros(1,numel(row));
    for n = 1:numel(row)
        responses(n) = C(row(n), col(n));
    end % n
    [responses, sortIdx] = sort(responses, 'descend');
    for n = 1:300 % numel(row)
        h = plot(col(sortIdx(n)), row(sortIdx(n)), 'y+');
        set(h, 'MarkerSize', 3, 'MarkerFaceColor', 'y');
    end % n

    pause;

end % nImage