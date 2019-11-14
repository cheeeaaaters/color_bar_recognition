function lengths = get_length_of_component(componentMap, pts, indexes, line)

slope = line(1);
indexes = int32(indexes);
[H, W] = size(componentMap);
lengths = zeros(size(indexes));

for i = 1:size(pts,1)
   
    y = pts(i, 1);
    x = pts(i, 2);
    unit = [slope 1];
    unit = unit./norm(unit);
    index = indexes(i);
    n1 = 0;
    n2 = 0;
    
    for t=0:1000
        y2 = round(y + t*unit(1));
        x2 = round(x + t*unit(2));
        if((x2 >= 1) && (x2 <= W) && (y2 >= 1) && (y2 <= H))
            if(componentMap(y2, x2) == index)
                n1 = n1 + 1;                
            else
                break;
            end
        else
            break;
        end
    end
    
    for t=0:1000
        y2 = round(y - t*unit(1));
        x2 = round(x - t*unit(2));
        if((x2 >= 1) && (x2 <= W) && (y2 >= 1) && (y2 <= H))
            if(componentMap(y2, x2) == index)
                n2 = n2 + 1;                
            else
                break;
            end
        else
            break;
        end
    end
    
    lengths(i) = n1 + n2;                
    
end

end

