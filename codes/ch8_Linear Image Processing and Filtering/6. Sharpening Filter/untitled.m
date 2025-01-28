I = imread('croppedBike.png');
imshow(I);
BW1 = edge(I,'roberts',0.1); 
figure
imshow(BW1); 
