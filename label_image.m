
function labelled = label_image(RGBimage,LightenImg,HSVimage,h_thres,s_thres,v_thres,white_thres,black_thres,lighten_white_thres,lighten_black_thres,var_thres)
RGBimage=double(RGBimage);
[H, W, ~] = size(HSVimage);
black_index=(RGBimage(:,:,1) < black_thres) & (RGBimage(:,:,2) < black_thres) & (RGBimage(:,:,3) < black_thres);
white_index=(RGBimage(:,:,1) > white_thres) & (RGBimage(:,:,2) > white_thres) & (RGBimage(:,:,3) > white_thres);
lighten_white_index=(LightenImg(:,:,1) > lighten_white_thres) & (LightenImg(:,:,2) > lighten_white_thres) & (LightenImg(:,:,3) > lighten_white_thres);
lighten_black_index=(LightenImg(:,:,1) < lighten_black_thres) & (LightenImg(:,:,2) < lighten_black_thres) & (LightenImg(:,:,3) < lighten_black_thres);
RG_D=abs(RGBimage(:,:,1)-RGBimage(:,:,2));
RB_D=abs(RGBimage(:,:,1)-RGBimage(:,:,3));
GB_D=abs(RGBimage(:,:,2)-RGBimage(:,:,3));
variation_index=(RG_D < var_thres) & (RB_D < var_thres) & (GB_D < var_thres);
mask=~(variation_index | lighten_black_index | lighten_white_index | black_index | white_index);
%mask=~(black_index | white_index);


labelled = zeros(H, W);
for i = 1:H
    for j = 1:W
        if mask(i,j)
            hsv = HSVimage(i,j,:);
            l = labeller(hsv,h_thres,s_thres,v_thres);
            labelled(i,j) = l;
        else
            labelled(i,j)=0;
        end
    end
end
    
end

function label = labeller(hsv,h_thres,s_thres,v_thres)    
    H=hsv(1);S=hsv(2);V=hsv(3);
    if(S > s_thres && V > v_thres)
        [~, type] = find_best_max(H*360, h_thres);
        label = type;
    else
        label = 0;
    end
end

    