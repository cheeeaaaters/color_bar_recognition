function [repaired, trust] = repair_code(codes_info)

num = numel(codes_info);
clean = remove_duplicate(codes_info);
lengths = zeros(1, num);
for i = 1:num
   lengths(i) = numel(clean(i).code);   
end
[~, I] = sort(lengths, 'descend');
codes_info = clean(I);

master_code = [];
accum = zeros(6, numel(master_code));

for i = 1:num
    [accum, master_code] = combine(accum, master_code, codes_info(i));
end

[repaired, trust] = validate(accum, master_code);

end

function [repaired, trust] = validate(accum, master_code)
    
    %greatest = max(accum, [], 'all');
    %sum_scores = sum(accum);
    %n = numel(master_code);
    
    code_info.code = master_code;
    code_info.confidence = max(accum);
    
    clean = remove_duplicate(code_info);
    blue = find(clean.code == 5);
    yellow = find(clean.code == 2);
    if((numel(blue) ~= 0) && (numel(yellow) ~= 0))
        if(blue(1) > yellow(1))
            clean.code = fliplr(clean.code);
            clean.confidence = fliplr(clean.confidence);
        end
    elseif(numel(blue) ~= 0)
        if(blue(1) >= numel(clean.code)/2)
            clean.code = fliplr(clean.code);
            clean.confidence = fliplr(clean.confidence);
        end
    elseif(numel(yellow) ~= 0)
        if(yellow(1) <= numel(clean.code)/2)
            clean.code = fliplr(clean.code);
            clean.confidence = fliplr(clean.confidence);
        end
    end
          
    repaired = clean.code;
    trust = clean.confidence;
    
    trust((repaired == 2) | (repaired == 5)) = [];
    repaired((repaired == 2) | (repaired == 5)) = [];

end

function [new_accum, new_master_code] = combine(accum, master_code, target)
   
    target_code = target.code;
    target_code_reverse = fliplr(target_code);
    [end1, end2, length, string] = longest_common_substring(master_code, target_code);
    [end1_r, end2_r, length_r, string_r] = longest_common_substring(master_code, target_code_reverse);
    if length_r > length
        end1 = end1_r;
        end2 = end2_r;
        length = length_r;
        target_code = target_code_reverse;
    end
    
    master_length = numel(master_code);
    target_length = numel(target_code);
    master_indexes = (1:master_length) - (end1 - length);
    target_indexes = (1:target_length) - (end2 - length);
    a = min([min(master_indexes) min(target_indexes)]);
    master_indexes = master_indexes + (1 - a);
    target_indexes = target_indexes + (1 - a);
    
    new_accum_size = max([max(master_indexes) max(target_indexes)]);
    new_accum = zeros(6,new_accum_size);
    new_accum(:,master_indexes) = accum;
    variance = target.variance / target_length;
    pm = target.peak_num;
    confidence = target.confidence;
    
    for i = 1:target_length
        k = target_indexes(i);
        new_accum(target_code(i),k) = new_accum(target_code(i),k) ...
            + (5/(1+variance) + confidence(i)*(1+length^2))/pm^2;
    end
    
    [~, new_master_code] = max(new_accum);        
    
end

function clean = remove_duplicate(codes_info)

num = numel(codes_info);

for i = 1:num
   c = codes_info(i).code;
   s = codes_info(i).confidence;   
   
   [~,blue_max_index] = max(s(c==5));
   blue = find(c==5);
   blue_mask = true(1,numel(blue));
   blue_mask(blue_max_index) = false;
   blue_indexes = blue(blue_mask);
   c(blue_indexes) = [];
   s(blue_indexes) = [];
   
   [~,yellow_max_index] = max(s(c==2));
   yellow = find(c==2);
   yellow_mask = true(1,numel(yellow));
   yellow_mask(yellow_max_index) = false;
   yellow_indexes = yellow(yellow_mask);
   c(yellow_indexes) = [];
   s(yellow_indexes) = [];
   
   flag = true;   
   while flag
       for j = 1:numel(c)-1
           if((c(j+1) == c(j)) && (c(j) ~= -1))
               [~, better] = max([s(j) s(j+1)]);
               c(j+2-better) = -1;
           end
       end
       c_deleted = find(c==-1);
       c(c_deleted) = [];
       s(c_deleted) = [];       
       if numel(c_deleted) == 0
           flag = false;
       end
   end
   
   codes_info(i).code = c;
   codes_info(i).confidence = s; 
end

clean = codes_info;

end