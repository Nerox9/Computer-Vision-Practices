
function [ output_image ] = histogram_eq( image )
input_image = imread(image);
input_image = double(input_image);
%Berk ARSLAN 20120607004

%Grey levels
L = 256;

p(1:L) = 0;
image_size = size(input_image);

for i=1:image_size(1)
    for j=1:image_size(2)
        value = input_image(i,j);
        p(value) = p(value)+1; 
    end
end

normalized_p = p/sum(p);

figure
plot((1:L),normalized_p);

%define Transfer Function
c = normalized_p;
i = 1;
for i = 1:L-1
    c(i+1) = c(i) + normalized_p(i);
end

c = round(c*(L-1));
output_image = input_image;

for i=1:image_size(1)
    for j=1:image_size(2)
        value = input_image(i,j);
        output_image(i,j) = c(value); 
    end
end

output_p(1:L) = 0;
image_size = size(output_image);

for i=1:image_size(1)
    for j=1:image_size(2)
        value = output_image(i,j);
        output_p(value+1) = output_p(value+1)+1; 
    end
end

figure
plot((1:L),output_p);

figure
imshow(uint8(output_image));

end

