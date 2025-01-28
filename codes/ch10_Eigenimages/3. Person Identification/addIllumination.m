function imgOut = addIllumination(img)

[height,width] = size(img);
[x,y] = meshgrid(1:width, 1:height);
a = 5*(rand(1)-0.5)/width;
b = 5*(rand(1)-0.5)/height;
theta = 0.2;
imgOut = img .* (1-theta + theta*cos(a*x + b*y));