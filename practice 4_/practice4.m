function [ n,center,R,C ] = practice4( image , crop )
% n = number of cells
% center = mass of center point of each cell
% R = rectangularity coefficient
% C = circularity coefficient
figure, imshow(image)

% binarizing
image_threshold = graythresh(image)
image_bin = im2bw(image, image_threshold);
figure, imshow(image_bin)

% inverting the binarized image
image_comp_bin = ~image_bin;
figure, imshow(image_comp_bin)

% first filling operation
image_comp_fill = imfill(image_comp_bin, 'holes');
figure, imshow(image_comp_fill)

% imopen worked better as imclose
struct_element = strel('disk', 6);
image_fill_open = imopen(image_comp_fill, struct_element);
figure, imshow(image_fill_open)

% second filling operation
image_2fill = imfill(image_fill_open, 'holes');
figure, imshow(image_2fill)

if (crop)
% clearing the border 
    image_ready = imclearborder(image_2fill, 6);
    figure, imshow(image_ready)
else
    image_ready = image_2fill;
end

% erode one more time and subtract from previous and we get perimeter
% and label again
se = strel('square', 3);
image_ready_erode = imerode(image_ready, se);
image_perimeter = logical(abs(imsubtract(image_ready_erode, image_ready)));
[perimeter_label,n_perimeter] = bwlabel(image_perimeter);

% % just a test to find and color the disks
% the number of cells in the picture
[L,n] = bwlabel(image_ready);
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
center = zeros(2,n);

%set standard deviation of area
deviation = regionprops(image_ready, 'Area');
st_dev = std([deviation.Area]);

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
    
    if (mass(label) >= st_dev)
        center(:,label) = [ x/mass(label) y/mass(label) ];
        R(label) = mass(label) / ((maxY-minY) * (maxX-minX));
        C(label) = P(label)^2 / mass(label);
    
        rectangle('Position',[minY,minX,maxY-minY,maxX-minX]);
        plot(center(2,label),center(1,label),'Marker','*')
    end
end

