function labelled_FIGURE = show_labelled(labelled)

RED=1;
YELLOW=2;
GREEN=3;
CYAN=4;
BLUE=5;
MAGENTA=6;
Color=zeros(6,3);
Color(RED,:)=[1 0 0];
Color(YELLOW,:)=[1 1 0];
Color(GREEN,:)=[0 1 0];
Color(CYAN,:)=[0 1 1];
Color(BLUE,:)=[0 0 1];
Color(MAGENTA,:)=[1 0 1];

labelled_FIGURE=figure;
labelled=repmat(labelled,1,1,3);

for i=1:6
    Indexs{i}=(labelled(:,:,1)==i);
end
for i=1:6
    R=labelled(:,:,1);
    G=labelled(:,:,2);
    B=labelled(:,:,3);
    R(Indexs{i})=Color(i,1);
    G(Indexs{i})=Color(i,2);
    B(Indexs{i})=Color(i,3);
    labelled(:,:,1)=R;
    labelled(:,:,2)=G;
    labelled(:,:,3)=B;
end
figure(labelled_FIGURE);
imshow(labelled);

end

