
image_original = imread('elephant.png');

%pre-table function is called 
[multiplier, image_north_west, image_south_east] = pre_table(numel(image_original));
%thinning operation is implemented
[thinned_image, time] = thinning(image_original, multiplier, image_north_west, image_south_east);

%image with skeleton
imshow(image_original-thinned_image);
