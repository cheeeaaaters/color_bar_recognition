function [end1,end2,length,string] = longest_common_substring(list1, list2)

    n1 = numel(list1);
    n2 = numel(list2);
    length = 0;
    end1 = 0;
    end2 = 0;
    
    dp = zeros(n1+1, n2+1);
    for i = 2:n1+1
        for j = 2:n2+1
            if(list1(i-1) == list2(j-1))
                dp(i,j) = dp(i-1,j-1) + 1;
                if(dp(i,j) > length)
                    length = dp(i,j);
                    end1 = i-1;
                    end2 = j-1;
                end
            end
        end
    end
    
    string = list1(end1-length+1:end1);
    
end

