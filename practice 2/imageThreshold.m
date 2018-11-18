image = imread('lena.gif');
imageThr = image;
maxVal = max(image(:));
minVal = min(image(:));
alfa = 0.5;
level = alfa * (maxVal - minVal) + minVal;
[m,n] = size(image);
for i = 1:m
    for j = 1:n
        if(image(i,j) < level)
            imageThr(i,j) = level;
        end
    end
end
imshow(image)
figure
imshow(imageThr);