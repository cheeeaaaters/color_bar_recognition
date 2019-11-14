function clipped = clip_labelled(labelled,width,line)

[Height, Width] = size(labelled);

m = line(1);
c = line(2);
k = width*sqrt(m^2+1)/2;

%x = 1:Width
line_down = [m c-k];
%y_down = m*x + c-k;
line_up = [m c+k];
%y_up = m*x + c+k;

[X, Y] = meshgrid(1:Width, 1:Height);
filter_down = (line_down(1)*X + line_down(2) - Y) > 0;
filter_up = (line_up(1)*X + line_up(2) - Y) < 0;

labelled(filter_down) = 0;
labelled(filter_up) = 0;

clipped = labelled;

end

