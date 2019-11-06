function [sortedComponents] = find_max_components(Components)
[~,idx]=sort([Components.size]);
sortedComponents=Components(idx);
end

