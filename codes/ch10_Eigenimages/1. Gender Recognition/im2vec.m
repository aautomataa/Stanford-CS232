function v = im2vec(im)

[height, width] = size(im);
v = reshape(im, height*width, 1);