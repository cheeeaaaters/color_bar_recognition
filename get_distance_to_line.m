function [distances] = get_distance_to_line(pts,line)

%this function get the perpendicular distances of pts to the line
%return array
m = line(1);
c = line(2);
n = sqrt(m^2 + 1);
y = pts(:,1);
x = pts(:,2);
y = y - c;
distances = abs((m*x - y)/n);

end

