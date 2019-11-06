H=8000;
W=20000;
img=zeros(H,W,3);
r=[1,0,0];
g=[0,1,0];
b=[0,0,1];
c=[0,1,1];
m=[1,0,1];
y=[1,1,0];


for i=1:H
    for j=1:2000
        img(i,j,:)=b;
        img(i,j+1*2000,:)=r;
        img(i,j+2*2000,:)=g;
        img(i,j+3*2000,:)=c;
        img(i,j+4*2000,:)=m;
        img(i,j+5*2000,:)=g;
        img(i,j+6*2000,:)=m;
        img(i,j+7*2000,:)=r;
        img(i,j+8*2000,:)=c;
        img(i,j+9*2000,:)=y;
    end
end


img=double(img);
imshow(img)
imwrite(img,'color_code.png');