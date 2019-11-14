function mean_pts = get_mean_pts(components, LIGHTEN_IMG_FIGURE, t)

mean_pts = [];
no_components = numel(components);

for i=1:no_components
   if(components(i).size > t)
       avg_pt=mean(components(i).points,1);
       mean_pts=[mean_pts; avg_pt components(i).label i];
       if(LIGHTEN_IMG_FIGURE ~= -1)
       figure(LIGHTEN_IMG_FIGURE);
       hold on;
       scatter(avg_pt(2),avg_pt(1));  
       end
   end
end

hold off;

end

