% Program to find the coordinates of edges in the detected road
% The program runs a for loop for the dimensnions of the image to along
% each row to find the first non zero pixel, once this pixel is determined
% a counter is initiated to find the next non zero pixel on the same line
% to determine the coordinates of the road and its width.

clc
clear

Img = imread('clipped_output.tif');
Img = im2bw(Img,0.1);
Img = edge(Img,'Canny');
figure(1)
imshow(Img);
title('Original Image');
%% Calculate road edge coordinates
for i = 1:size(Img,1)
    for j = 1:size(Img,2)
% Checking for first non zero pixel 
        if Img(i,j) ==1
            start_coordinate(1,i) = i;
            start_coordinate(2,i) = j;
            count = j+1;
% Once first non zero pixel is determined, find the last non zero pixel in the row            
                
                while Img(i,count) == 1
                    count = count+1;
                   
                    
                end
 % Find all zero pixels to reach end coordinate of the road               
  counter = count +1;
                while Img(i,counter) == 0 && counter<size(Img,2)
                    counter = counter+1;
                    
                    
                end
% Save the end coordinate value 
                if Img(i,counter) ==1
                    end_coordinate(1,i) = i;
                    end_coordinate(2,i) = counter;
                end
                
           break;
           
        end
    end
end


% Extract all columns of zeroes from the coordinates
start_coordinate( :, ~any(start_coordinate,1) ) = [];
end_coordinate( :, ~any(end_coordinate,1) ) = [];

% Plot the road coordinates
figure(2)
plot(start_coordinate(1,:),start_coordinate(2,:),end_coordinate(1,:),end_coordinate(2,:))
title('Extracted Road');
legend('Start Road Coordinates','End Road Coordinates');

 % Since the Tif image has a its 0,0 coordinate at the top left hand
 % corner of the image, and the plot has its 0,0 coordinate at the bottom
 % left hand corner of the image, the plot is inverted. Please rotate the
 % plot to match to the original image while viewing.


%% Extracting Road pixels from original image
Original_Image = imread('alt_21270.tif');

% Create a blank RGB Image
Road_RGB = uint8(zeros(size(Original_Image,1),size(Original_Image,2),size(Original_Image,3)));
% Read start and end coordinates of road from extracted road image 
for k = 1: size(end_coordinate,2)
     counter_start_x = start_coordinate(1,k);
     counter_start_y = start_coordinate(2,k);
     counter_end_x = end_coordinate(1,k);
     counter_end_y = end_coordinate(2,k);
 
%Run through X,Y coordinates from start to end coordinates on original image and extract RGB pixels   
     for i = counter_start_x :counter_end_x
         
         for j = counter_start_y :counter_end_y
            Road_RGB(i,j,:) = Original_Image(i,j,:);
%             Road_RGB(i,j,2) = Original_Image(i,j,2);
%             Road_RGB(i,j,3) = Original_Image(i,j,3);
         end
     end
     
 end
 figure(3)
 imshow(Road_RGB);
 title('Extracted RGB Image');
 
 %% Plot histograms on bar graphs after getting rid of all pixel values below 10.
 Road = Road_RGB(Road_RGB>10);
 figure(4)
 Road_R = Road_RGB(Road_RGB(:,:,1)>10);
 [Red_pix,Red_gray_levels] = imhist(Road_R);
 bar(Red_pix);
 title('Red Histogram');
 xlim([0 Red_gray_levels(end)]);
 figure(5)
 Road_G = Road_RGB(Road_RGB(:,:,2)>10);
 [Green_pix,Green_gray_levels] = imhist(Road_G,256);
 bar(Green_pix);
 title('Green Histogram');
 xlim([0 Green_gray_levels(end)]);
 figure(6)
 Road_B = Road_RGB(Road_RGB(:,:,3)>10);
[Blue_pix,Blue_gray_levels] = imhist(Road_B,256);
 bar(Blue_pix);
 title('Blue Histogram');
 xlim([0 Blue_gray_levels(end)]);
 %% Calculate average pixel value using total number of pixels and intensity of each pixel
 Red_avg = sum(Red_pix.*Red_gray_levels)/sum(Red_pix);
 Blue_avg = sum(Blue_pix.*Blue_gray_levels)/sum(Blue_pix);
 Green_avg = sum(Green_pix.*Red_gray_levels)/sum(Blue_pix);
 %% Eliminate shadows by replacing all  pixel values on the road with the calculated average
 for i = counter_start_x :counter_end_x
       for j = counter_start_y :counter_end_y 
            
            if Original_Image(i,j,1) ~= Red_avg
                Original_Image(i,j,1) = Red_avg;
            end
            
            if Original_Image(i,j,2) ~= Blue_avg
                Original_Image(i,j,2) = Blue_avg;
            end
            
            if Original_Image(i,j,3) ~= Green_avg
                Original_Image(i,j,3) = Green_avg;
            end
        end
 end
 figure(7)
 imshow(Original_Image)
 
       