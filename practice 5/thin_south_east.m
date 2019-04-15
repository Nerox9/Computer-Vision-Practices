function [ output_image ] = thin_south_east( input_image, image_south_east, multiplier )

    padded_input_image = padarray(input_image,[1 1]);
    padded_image_size = size(padded_input_image);
    image_columns = im2col(padded_input_image,[3 3]);
    
    
    P = [image_columns(5,:); image_columns(2,:); image_columns(3,:); image_columns(6,:); image_columns(9,:); image_columns(8,:); image_columns(7,:); image_columns(4,:); image_columns(1,:) ];
    
    columns_in_decimal = sum(multiplier .* P , 1) + 1;
    thinned_image_columns = image_south_east(columns_in_decimal);
    
    output_image = col2im(thinned_image_columns,[3 3],  padded_image_size);
    
end
