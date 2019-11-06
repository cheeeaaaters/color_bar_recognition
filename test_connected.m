%img_name='047.jpg';
%img=imread(img_name);

%labelled = label_image(img);

components = find_connected(labelled, [1,2,3,4,5,6]);

max = components(1).size;
index = 1;
for i = 2:numel(components)
    if(components(i).size > max)
        index = i;
        max = components(i).size;
    end
end

[H,W] = size(labelled);
test = zeros(H,W);

for k = 1:max
    test(components(index).points(k, 1), components(index).points(k, 2)) = 1;
end

imshow(test);
    




