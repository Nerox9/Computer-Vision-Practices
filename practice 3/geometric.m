image = imread('moon.tif');

final = colfilt(image,[5 5],'sliding',@geometricmean);
final = uint8(final);

figure
subplot(1,2,1)
imshow(image)
title('The original image')
subplot(1,2,2)
imshow(final)
title('The filtered image')