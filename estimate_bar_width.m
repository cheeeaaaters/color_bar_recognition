function width = estimate_bar_width(components)

n = numel(components);
widths = zeros(1,n);
for i = 1:n
    com = components(i);
    pts = com.points;
    min_x = min(pts(:,2));
    max_x = max(pts(:,2));
    min_y = min(pts(:,1));
    max_y = max(pts(:,1));
    widths(i) = max([max_x - min_x; max_y - min_y]);
end

width = mean(widths);

end

