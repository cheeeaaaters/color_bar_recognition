function sum_peaks = Combine_Two(pks1,pks2)
%COMBINE_TWO Summary of this function goes here
%   Detailed explanation goes here
sum_peaks=zeros(1,numel(pks1));
for i=1:numel(pks1)
    if pks1(i)~=0 && pks2(i)==0
        sum_peaks(i)=pks1(i);
    elseif pks1(i)==0 && pks2(i)~=0
        sum_peaks(i)=pks2(i);
    elseif pks1(i)==0 && pks2(i)==0
        sum_peaks(i)=0;
    elseif pks1(i)~=0 && pks2(i)~=0
        if pks1(i)==pks2(i)
            sum_peaks(i)=pks1(i);
        else
            sum_peaks(i)=0;
        end
    end
end
sum_peaks(sum_peaks<0)=0;
end

