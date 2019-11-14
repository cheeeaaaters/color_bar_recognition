function sizes = get_size_of_component(components, indexes)

sizes = zeros(numel(components),1);

for i = 1:numel(components)
    sizes(i) = components(i).size;
end

end

