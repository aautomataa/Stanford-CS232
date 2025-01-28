% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen, Matt Yu
% CMU PIE Illumination Variations

for nFrame = 139:150
    img = imread(sprintf('keyframes/frame_%06d.jpg', nFrame));
    img = img(27:204, 73:209, :);
    imwrite(img, sprintf('keyframes_cropped/frame_%06d.jpg', nFrame));
end