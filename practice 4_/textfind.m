function [ final ] = textfind( text , filter )

%threshold image
text_thr = graythresh(text);

%binarized input image
text_bw = im2bw(text, text_thr);

%print binarized text
figure
subplot(1,2,1)
imshow(text_bw);

%print complemntary of text
text_comp = ~ text;
subplot(1,2,2);
imshow(text_comp)

%complementary of filter
filter_comp = ~filter;

%print erosion the first pattern
figure
subplot(1,2,1)
hit = imerode(text_bw, filter); 
imshow(hit);

%print erosion the second pattern from complementaries of text and filter
subplot(1,2,2)
miss = imerode(text_comp, filter_comp);
imshow(miss)

%print hit and miss output
figure
HitorMiss = hit & miss;
imshow(HitorMiss)

%print final image
figure
final = imreconstruct(HitorMiss, text_bw);
imshow(final)

end

