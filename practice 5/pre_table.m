function [multiplier, image_north_west, image_south_east] = pre_table ( image_size )
    %pre allocate the P matrix
    P = zeros(9,511);
    %for each column
    for i = 0:511
        %each value converted to binary as a column
        P(:,i+1) = transpose(dec2binvec(i,9));
    end
    
    %prepare a multiplier from 2^0 to 2^8
    multiplier = zeros(9,1);
    for i = 0:8
    multiplier(i+1) = 2^i;
    end
    
    %copy this multiplier to each column
    multiplier = repmat(multiplier,1,image_size);

    %the last P is same with P_2
    P(10,:) = P(2,:);
    % B is the summation from P_1 to P_9 
    B = sum(P(2:end-1,:));
    %Describe each direction's P array
    P_east = [P(2,:);P(4,:);P(6,:)];
    P_south = [P(4,:);P(6,:);P(8,:)];
    P_west = [P(2,:);P(6,:);P(8,:)];
    P_north = [P(2,:);P(4,:);P(8,:)];
    
    %Then multiply column by colmun
    P_east = prod(P_east,1);
    P_south = prod(P_south,1);
    P_west = prod(P_west,1);
    P_north = prod(P_north,1);

    %copy original images to outputs of will be compared with original
    %image
    image_south_east = P(1,:);
    image_north_west = P(1,:);

    %define the counter of loop
    column_size = size(P);

    for i = 1:column_size(2)
        %if middle pixel is one
        if(P(1,i))
            %and if 2<=B<=6 and P_east and P_south are zero
            if(2<=B(i) && B(i)<=6 && P_east(i) == 0 && P_south(i) == 0)
                %the counter A is initilazed
                A = 0;
                %test 0->1 pattern in P array
                for k = 2:size(P(:,1),1)-1
                    if P(k,i) == 0 && P(k+1,i)==1
                        %if there is this pattern, then add 1 to A coutner
                        A = A+1;
                    end
                end
                
                if (A==1)
                    %if A is 1 then clear the center pixel of comparing
                    %matrix
                    image_south_east(i) = 0;
                end
            end
            
            %and test it for west and north direction
            %and if 2<=B<=6 and P_west and P_north are zero
            if(2<=B(i) && B(i)<=6 && P_west(i) == 0 && P_north(i) == 0)
                %the counter A is initilazed
                A = 0;
                for k = 2:size(P(:,1),1)-1
                    %test 0->1 pattern in P array
                    if P(k,i) == 0 && P(k+1,i)==1
                        %if there is this pattern, then add 1 to A coutner
                        A = A+1;
                    end
                end
                if (A==1)
                    %if A is 1 then clear the center pixel of comparing
                    %matrix
                    image_north_west(i) = 0;
                end
            end
        end
    end
end