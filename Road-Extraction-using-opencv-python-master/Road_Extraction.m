 close all
clc
clear

%Read image

Img = imread('test.tif');
figure(1),subplot(2,3,1),imshow(Img);
title(' RGB Image ');

%Sharpen image for better conversion to Grey and Binary

I = imsharpen(Img,'Radius',0.2,'Amount',2);
I = rgb2gray(I);

% Expel low and high intensity pixels

I = imadjust(I,[0.4, 0.6],[]);
I = im2bw(I,0.5);
figure(1),subplot(2,3,2),imshow(I);
title(' Binary Image ');
I = im2uint8(I);

%Expel objects with size less than 200 pixels

I = bwareaopen(I,200,8);
figure(1),subplot(2,3,3),imshow(I);
title(' Image with noise removed ');

%Erode image to remove outliers

se_erode = strel('square',3);
I = imerode(I,se_erode);
figure(1),subplot(2,3,4),imshow(I);
title(' Eroded Image ');

% DIlate image for better viewing

se_dilate = strel('diamond',10);
I = imdilate(I,se_dilate);
figure(1),subplot(2,3,5),imshow(I);
title(' DIlated Image ');

%Detect Edges
I_sobel = edge(I,'sobel');
figure(2),subplot(2,2,1),imshow(I_sobel );
title (' Sobel Filtered ');

I_canny = edge(I,'canny');
figure(2),subplot(2,2,2),imshow(I_canny);
title ( ' Canny Filtered ');

I_gauss = edge(I,'log');
figure(2),subplot(2,2,3),imshow(I_gauss);
title ( ' Gaussian Filtered ');

I_prewitt = edge(I,'prewitt');
figure(2),subplot(2,2,4),imshow(I_prewitt);
title ( ' Prewitt Filtered ');

%Write to file
imwrite(I_canny,'edge.tif')

%Reconvert to RGB

RGB = im2uint8(I_canny);
RGB(end, end, 3) = 0;

% Add edges detected to original image

Edge_Detected = imadd(RGB,Img);


        
