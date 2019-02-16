clear all; clc; close all;
I = imread('blood5.tif');
figure, imshow(I)

% binarizing
image_threshold = graythresh(I)
image_bin = im2bw(I, image_threshold);
figure, imshow(image_bin)

% inverting the binarized image
image_negative_bin = ~image_bin;
figure, imshow(image_negative_bin)

% first filling operation
image_negative_fill = imfill(image_negative_bin, 'holes');
figure, imshow(image_negative_fill)

% imopen worked better as imclose
struct_element = strel('disk', 6);
image_fill_open = imopen(image_negative_fill, struct_element);
figure, imshow(image_fill_open)

% second filling operation
image_2fill = imfill(image_fill_open, 'holes');
figure, imshow(image_2fill)

% clearing the border 
image_clear_border = imclearborder(image_2fill, 6);
figure, imshow(image_clear_border)

% erode one more time and subtract from previous and we get perimeter
% and label again
se = strel('square', 3);
image_clear_border_erode = imerode(image_clear_border, se);
image_perimeter = logical(abs(imsubtract(image_clear_border_erode, image_clear_border)));
[perimeter_label,n_perimeter] = bwlabel(image_perimeter);

% % just a test to find and color the disks
% the number of cells in the picture
[L,n] = bwlabel(image_clear_border);
RGB = label2rgb(L);
figure, imshow(RGB)
hold

%get sizes of label image
[sizex, sizey] = size(L);
%define as zeros the outputs
R = zeros (1,n);
P = zeros (1,n);
C = zeros (1,n);
mass = zeros (1,n);

for label = 1:n
    x = 0;
    y = 0;
    minX = 0;
    maxY = 0;
    
    
    firstX = 1;
    firstY = 1;
    for i = 1:sizex        
        for j = 1:sizey
            
            if (L(i,j) == label)
                 if (firstX && minX < i)
                     minX = i; 
                     firstX = 0;
                 end
                 if (firstY || minY > j)
                     minY = j;   
                     firstY = 0;
                 end
                mass(label) = mass(label) + 1;
                x = x + i;
                y = y + j;
                maxX = i;
                if (maxY < j)
                    maxY = j;  
                end
            end
            
            if(perimeter_label(i,j) == label)
                P(label) = P(label) + 1;
            end
            
        end
    end
    center = [ x/mass(label) y/mass(label) ];
    R(label) = mass(label) / ((maxY-minY) * (maxX-minX));
    C(label) = P(label)^2 / mass(label);
    
    rectangle('Position',[minY,minX,maxY-minY,maxX-minX]);
    plot(center(2),center(1),'Marker','*')
end