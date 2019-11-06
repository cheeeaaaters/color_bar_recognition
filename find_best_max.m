function [color,type] = find_best_max(Hue,thres)
diffs=zeros(1,6);
Hues=[0,60,165,190,240,255];
color='null';
for i=1:6
 
    diff=abs(Hue-Hues(i));
    if diff>180
      diffs(i)=360-diff;
    else
      diffs(i)=diff;
    end
end
min_diff=min(diffs,[],'all');
index=find(diffs==min_diff);
index=index(1);
if min_diff<=thres
    type=index;
    switch index
        case 1
            color='r';
        case 2
            color='y';
        case 3
            color='g';
        case 4
            color='c';
        case 5
            color='b';
        case 6
            color='m';            
    end
else
    type=0;
end

if Hue<0
    color='null';
    type=0;
end
end

