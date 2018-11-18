%% Image Gray Color and Histogram
clear
clc
%image = imread('Hawkes_Bay.jpg');
image = imread('moon.tif');

%if image dimensions are bigger than 2, make them 2
if(ndims(image) > 2)
    image = image(:,:,1);
end

%define histogram intensity array
intensity (1:256) = 0;

%count each gray value
[m,n] = size(image);
for i = 1:m
    for j = 1:n
        value = image(i,j);
        intensity(value+1) = intensity(value+1) +1;
    end
end

%print image
imshow(image)

%calculate cumulative histogram
cumulative = cumsum(intensity);
[m,n] = size(cumulative);
if(n<256)
    cumulative(n:256) = max(cumulative(:));
end

%print both of them
figure
stem(intensity,'r', 'Marker', 'none');
axis tight
ylabel(gca,'intensity');
set(gca,'Box','off');
axesPosition = get(gca,'Position');
hNewAxes = axes('Position',axesPosition,'Color','none','YLim',[0 max(cumulative(:))],'YAxisLocation','right','XTick',[],'Box','off');
ylabel(hNewAxes,'cumulative');
hold on
plot(cumulative,'b', 'Marker', 'none');
axis tight
hold off
%% Histogram Equalization

%define cumulative distribution
histeq0 = round(255*cumulative/max(cumulative(:)));

%define new intensity array
newIntens(1:256)=0;
for i = 1:256
    if(histeq0(i) ~= 0)
        newIntens(histeq0(i)) = newIntens(histeq0(i)) + intensity(i);
    end
end

%print histograms
figure
stem(histeq0,intensity,'r','Marker','none');
axis tight
cumulative =cumsum(newIntens);
stem(newIntens,'r', 'Marker', 'none');
axis tight
ylabel(gca,'intensity');
set(gca,'Box','off');
axesPosition = get(gca,'Position');
hNewAxes = axes('Position',axesPosition,'Color','none','YLim',[0 max(cumulative(:))],'YAxisLocation','right','XTick',[],'Box','off');
ylabel(hNewAxes,'cumulative');
hold on
plot(cumulative,'b', 'Marker', 'none');
axis tight

%distribute each image pixel according to cumulative distribution function
imageq = image;
[m,n] = size(image);
for i = 1:m
    for j = 1:n
        imageq(i,j) = uint8(histeq0(image(i,j)+1));
    end
end

%print equalized image
figure
imshow(imageq)

%print equalized image and histogram with matlab's function
imageq1 = image;
histeq1 = histeq(imageq1);
figure
imshow(histeq1)
figure
imhist(histeq1)