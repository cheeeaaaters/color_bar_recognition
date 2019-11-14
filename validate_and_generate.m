function [colorcode, ok, confidence, variance] = validate_and_generate(scores, mean_pts, line)

m = line(1);
perpend = [-1/m 0];
projections = get_distance_to_line(mean_pts(:,1:2), perpend);
sign = 2*(((mean_pts(:,1) + mean_pts(:,2)/m) >= 0)-0.5);
projections = projections.*sign;
info = [projections scores mean_pts];
info = sortrows(info,2,{'descend'});
k = 10;

colorcode = [];
ok = false;
confidence = zeros(1, k);
variance = 1/0;

while true
    
    if(size(info,1) < k)
        k = size(info,1);
    end
    
    if(k <= 2)
        return;
    end
    
    info(1:k,:) = sortrows(info(1:k,:),1);

    var_list = zeros(k,1);
    orig_var = get_variance_of_distances(info(1:k,1), false);
    for rm = 1:k
        var_list(rm) = get_variance_of_distances(info(1:k,1), rm);
    end

    change = (orig_var-var_list)/orig_var;
    change_mask = change > 0.9;
    indexes = 1:k;
    
    colorcode = info(1:k, 5)';
    confidence = info(1:k, 2)';
    variance = orig_var;
    [colorcode, ok] = validate(colorcode);

    info(indexes(change_mask),:) = [];
        
    if(numel(find(change_mask)) == 0)
        break;
    end

end

end

function variance = get_variance_of_distances(projs, rm)
    mask = true(size(projs));
    mask(rm) = false;
    projs = projs(mask);
    distances = zeros(size(projs));    
    n = numel(projs);
    for i = 1:n
        if(i == 1)
            distances(i) = projs(i+1) - projs(i);
        elseif(i == n)
            distances(i) = projs(i) - projs(i-1);
        else
            distances(i) = (projs(i+1) - projs(i-1))/2;
        end            
    end
    variance = var(distances);
end

function [corrected, ok] = validate(colorcode)

k = numel(colorcode);
if((colorcode(1) == 2) && (colorcode(k) == 5))
    colorcode = fliplr(colorcode);
end

corrected = colorcode;
ok = false;

if((colorcode(1) == 5) && (colorcode(k) == 2) && (k==10))
    middle_blue = numel(find(colorcode(2:k-1) == 5));
    middle_yellow = numel(find(colorcode(2:k-1) == 2));
    if((middle_blue == 0) && (middle_yellow == 0))
        diff_color = numel(find(diff(colorcode(2:k-1)) == 0));
        if(diff_color == 0)
            corrected = colorcode;
            ok = true;
        end
    end
end

end

