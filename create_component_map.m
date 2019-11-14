function componentMap = create_component_map(s, components, indexes)

componentMap = zeros(s);
for i = 1:numel(components)
    
    points = components(i).points;
    componentMap = componentMap + accumarray(points, indexes(i), size(componentMap));
    
end

end

