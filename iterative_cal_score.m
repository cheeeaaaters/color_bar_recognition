function scores = iterative_cal_score(pts,distances,sizes,lengths)

num = size(pts,1);
scores = ones(num,1);
weight_matrix = get_weight_matrix(pts);
size_matrix = get_size_matrix(sizes);
length_matrix = get_length_matrix(lengths);
dist_score = get_distance_score(distances);
length_penalty = get_length_penalty(lengths);

for i = 1:100                
    scores_accum = (weight_matrix.*scores).*(size_matrix + length_matrix);
    scores_accum = sum(scores_accum,2) + dist_score - length_penalty;
    scores = (scores_accum-min(scores_accum))./(max(scores_accum)-min(scores_accum));
end

end

function size_matrix = get_size_matrix(sizes)
    s = log10(sizes);
    diff_s = abs(s-s');
    size_matrix = 3./(diff_s + 1);
end

function distance_score = get_distance_score(d)
    distance_score = 1./(sqrt(d)+1);
end

function weight_matrix = get_weight_matrix(pts)    
    ptx = pts(:, 2);
    pty = pts(:, 1);
    
    diffX = ptx - ptx';
    diffY = pty - pty';
    
    d_matrix = sqrt(diffX.^2 + diffY.^2);
    decay_matrix = 1./(1+d_matrix);
    s = sum(d_matrix, 2);
    weight_matrix = (1 - d_matrix./s).*decay_matrix;  
    %weight_matrix = (1 - d_matrix./s); 
        
    n = size(weight_matrix, 1);
    v = ones(1,n);
    weight_matrix(logical(diag(v))) = 0;
end

function length_matrix = get_length_matrix(lengths)
    diff_l = abs(lengths-lengths');
    length_matrix = 1./(diff_l + 1);
end

function length_penalty = get_length_penalty(lengths)
    length_penalty = sigmf(lengths, [-4 10]);
end

