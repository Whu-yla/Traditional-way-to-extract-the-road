clc 
clear
% Import and show Image 
Img = imread('/Users/Sumanth/Desktop/GIS/neighborhood.tiff');
figure(1)
imshow(Img)
Img = im2bw(Img,0.5);

