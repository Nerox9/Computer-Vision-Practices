function [ output_image, elapsed_time ] = thinning( image_original, multiplier, image_north_west, image_south_east)

%initilazed main variables
    continue_itteration = 1;        %iterration decider
    input_image = image_original;   %initilaze input image as original image
    output_image = input_image;     %initilaze output image as original image
    %start timer
    tic

    while continue_itteration == 1
        %set input image the previous output image
        input_image = output_image;
        %first imply the north and west direction then imply south and east
        %direction
        first_thinning = thin_north_west(input_image, image_north_west, multiplier);
        output_image = thin_south_east(first_thinning, image_south_east, multiplier);
        %test input and output image are equal or not
        continue_itteration = ~isequal(input_image,output_image);
    end
%stop timer
elapsed_time = toc;

end


function [ output_image ] = thin_north_west( input_image, image_north_west, multiplier )

%padding image
    padded_input_image = padarray(input_image,[1 1]);
    padded_image_size = size(padded_input_image);
    %convert image to columns
    image_columns = im2col(padded_input_image,[3 3]);
    
    %create P matrix
    P = [image_columns(5,:); image_columns(2,:); image_columns(3,:); image_columns(6,:); image_columns(9,:); image_columns(8,:); image_columns(7,:); image_columns(4,:); image_columns(1,:) ];
    
    %multiply P with pre-defined multiplier matrix and add 1 to specify
    %each P value and convert sum of them to decimals
    columns_in_decimal = sum(multiplier .* P , 1) + 1;
    %each column of pre-defined image creates new pixel according to
    %columns_in_decimal variable
    image_columns = image_north_west(columns_in_decimal);
    %new array of image created by pre-defined image converting to filtered
    %image
    output_image = col2im(image_columns,[3 3],  padded_image_size);
end

function [ output_image ] = thin_south_east( input_image, image_south_east, multiplier )

%padding image
    padded_input_image = padarray(input_image,[1 1]);
    padded_image_size = size(padded_input_image);
    %convert image to columns
    image_columns = im2col(padded_input_image,[3 3]);
    
    %create P matrix
    P = [image_columns(5,:); image_columns(2,:); image_columns(3,:); image_columns(6,:); image_columns(9,:); image_columns(8,:); image_columns(7,:); image_columns(4,:); image_columns(1,:) ];
    
    %multiply P with pre-defined multiplier matrix and add 1 to specify
    %each P value and convert sum of them to decimals
    columns_in_decimal = sum(multiplier .* P , 1) + 1;
    
    %each column of pre-defined image creates new pixel according to
    %columns_in_decimal variable
    thinned_image_columns = image_south_east(columns_in_decimal);
    
    %new array of image created by pre-defined image converting to filtered
    %image
    output_image = col2im(thinned_image_columns,[3 3],  padded_image_size);
    
end

