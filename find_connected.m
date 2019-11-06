function components = find_connected(map, filter)

[H, W] = size(map);
visited = false(H+2, W+2);
stack = zeros(H*W, 2);
container = zeros(H*W, 2);
components = [];
%stack_pointer = 1;

for i = 1:H+2
    for j = 1:W+2
        if(i == 1 || i == H + 2 || j == 1 || j == W + 2)
            visited(i,j) = 1;
            continue;
        end
        for k = 1:numel(filter)
            if(map(i-1,j-1) == filter(k))
                visited(i,j) = 1;
                break;
            end
        end
    end
end

for i = 1:H
    for j = 1:W
        stack_pointer = 1;
        container_pointer = 1;
        if(~visited(i+1,j+1))
            stack(stack_pointer, :) = [i j];
            stack_pointer = stack_pointer + 1;
            visited(i+1,j+1) = 1;
        end
        while(stack_pointer > 1)
            stack_pointer = stack_pointer - 1;
            node = stack(stack_pointer, :);            
            container(container_pointer, :) = node;
            container_pointer = container_pointer + 1;
            
            node_y = node(1);
            node_x = node(2);
            
            neighbors = [node_y node_x-1; node_y node_x+1; node_y-1 node_x; node_y+1 node_x];
            for k = 1:4
               n_y = neighbors(k, 1);
               n_x = neighbors(k, 2);
               if(~visited(n_y+1, n_x+1) && (map(n_y, n_x) == map(node_y, node_x)))
                   visited(n_y+1, n_x+1) = 1;
                   stack(stack_pointer, :) = [n_y n_x];
                   stack_pointer = stack_pointer + 1;
               end
            end                    
        end
        
        if(container_pointer > 1)
            component.size = container_pointer - 1;
            component.points = container(1:component.size, :);            
            component.label = map(i,j);
            
            components = [components component];
        end        
    end    
end

