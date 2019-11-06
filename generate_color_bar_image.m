function generate_color_bar_image(H,W,code,path)

img=zeros(H,W,3);

colors=convert_number_to_color_tuple(code);

for i=1:H
    for j=1:W/10
        for k=1:10
            img(i,j+(k-1)*W/10,:)=colors(k,:);
        end
    end
end
imwrite(img,path);
end

function colors = convert_number_to_color_tuple(code)
    r=[0.9,0.15,0.15];
    g=[0.2,0.7,0.2];
    b=[0.25,0.2,0.7]; 
    c=[0.15,1,0.9]; 
    m=[0.85,0.15,0.9];
    y=[0.9,0.9,0.15];

    colors=zeros(10,3);
    for i=1:10
        switch code(i)
            case 1
                colors(i,:)=r;
            case 2
                colors(i,:)=y;
            case 3
                colors(i,:)=g;
            case 4
                colors(i,:)=c;
            case 5
                colors(i,:)=b;
            case 6
                colors(i,:)=m;
        end
    end
end

