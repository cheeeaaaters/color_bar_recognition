function [colors_along_line,pks,locs,w] = Find_Peaks_Along_Line(m,c,Width,Height,img,h_thres,s_thres,v_thres)

colors_along_line=zeros(1,Width);
for x=1:Width
    y=round(m*x+c);
    if y>=1 && y<=Height
        Hue=round(img(y,x,1)*360);S=img(y,x,2);V=img(y,x,3);
        colors_along_line(x)=0;
        if S>s_thres && V>v_thres
          [~,type]= find_best_max(Hue,h_thres);
          colors_along_line(x)=type;
        end
    else
        colors_along_line(x)=-1;
    end    
end
plot(1:Width,colors_along_line);
title(num2str(c));
hold on;
[pks,locs,w,~] = findpeaks(colors_along_line);
num_of_peaks=numel(pks);
if num_of_peaks>1
    prev=pks(1);
    temp_pks(1)=pks(1);
    temp_locs(1)=locs(1);
    temp_w(1)=w(1);
    temp_index=1;
    for i=2:num_of_peaks     
          if pks(i)==prev
              temp_w(temp_index)=temp_w(temp_index)+w(i);
          else
              temp_index=temp_index+1;
              temp_pks(temp_index)=pks(i);
              temp_locs(temp_index)=locs(i);
              temp_w(temp_index)=w(i);
          end
          prev=pks(i);
    end
    pks=temp_pks;
    locs=temp_locs;
    w=temp_w;
end

scatter(locs,pks);
hold on;
end

