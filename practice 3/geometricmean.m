function [ geometric ] = geometricmean( pixels )
%UNT�TLED5 Summary of this function goes here
%   Detailed explanation goes here
[m n] = size(pixels);
geometric = nthroot(prod(pixels,1),m);

end

