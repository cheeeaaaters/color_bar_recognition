function [H_diff] = cal_H_diff(c_1,c_2)
diff=abs(c_1-c_2);
if diff>180
    H_diff=360-diff;
else
    H_diff=diff;
end

end

