function [n1,n2] = find_similar(values, x, thres, outliner_skip)
    m = size(values, 2);
    n1 = 0;
    n2 = 0;
    o1 = 0;
    o2 = 0;
    for i=x-1:-1:1
        if(cal_H_diff(values(i), values(x)) < thres)
            n1 = n1+1;
        else 
            o1 = o1 + 1;
            if(o1 >= outliner_skip)
                break;
            end
        end
    end
    for i=x+1:1:m
        if(cal_H_diff(values(i), values(x)) < thres)
            n2 = n2+1;
        else 
            o2 = o2 + 1;
            if(o2 >= outliner_skip)
                break;
            end
        end
    end
    
end

