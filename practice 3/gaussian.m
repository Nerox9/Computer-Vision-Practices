deviationX = 0.3;
deviationY = 2;
filterX = 17;
filterY = 17;
filterRot = -45;

%filterRot = filterRot*pi/180;
expandX = filterX/2-0.5;
expandY = filterY/2-0.5;


sigmax = deviationX;
mu = 0;
xofX = linspace(-expandX,expandX,filterX);
yofX = 1/(sqrt(2*pi)*sigmax)*exp(-(xofX-mu).^2/(2*sigmax^2));

sigmay = deviationY;
mu = 0;
xofY =  linspace(-expandY,expandY,filterY);
yofY =  1/(sqrt(2*pi)*sigmay)*exp(-(xofY-mu).^2/(2*sigmay^2));

figure
plot(xofX,yofX)
hold
plot(xofY,yofY,'r')
legend('Gaussian of X','Gaussian of Y')

image = imread('Concentric Circles.jpg');


%image(imageX:(imageX+2*expandX), imageY:(imageY+2*expandY)) = 0;
%circshift(image,[2 2]);
imagePad = padarray(image,[expandX expandY],'symmetric');
[imageX, imageY] = size(imagePad);

yofY = transpose(yofY);
filter = round(255*yofY*yofX);
filter = imrotate(filter,filterRot,'crop');

figure
bar3(filter)
title('Filter Mask')

filter = im2col(filter,[filterX filterY]);
image2 = im2col(imagePad,[filterX filterY]);
output = round(sum(transpose(filter)*double(image2),1)/sum(filter));
imageGauss =col2im(uint8(output),[filterX filterY], [imageX imageY],'sliding');
%imageGauss = uint8(colfilt(image,[filterX filterY],'sliding',@filter));

figure
subplot(1,2,1)
imshow(image)
title('Original Image')
subplot(1,2,2)
imshow(imageGauss)
title('Filtered Image')