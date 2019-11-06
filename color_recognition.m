close all;clear all;clc;
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
similarity_thres=8;
h_thres=60;
s_thres=0.3;
v_thres=0.3;

white_thres=210;
black_thres=50;
lighten_white_thres=0.7;
lighten_black_thres=0.3;
var_thres=20;
maxDistance=5;

img_name='C:\Users\cheee\Desktop\UST\fyp\color_bar\color_bar_recognition_2\color_bar_recognition\color_code\color_code\code\code_b\27.png';
img_rgb=imread(img_name);
[Height,Width,~]=size(img_rgb);

figure;
imshow(img_rgb);
%% find colours in images
img=rgb2hsv(img_rgb);
temp=img;

img(:,:,3)=img(:,:,3)*1.5;
index=img(:,:,3)>0.9;
img(index)=temp(index);

img(:,:,2)=img(:,:,2)*1.8;
index=img(:,:,2)>1;
img(index)=temp(index);

LIGHTEN_IMG_FIGURE=figure;
lighten_img=hsv2rgb(img);
imshow(lighten_img);
hold on;

labelled = label_image(img_rgb,lighten_img,img,h_thres,s_thres,v_thres,white_thres,black_thres,lighten_white_thres,lighten_black_thres,var_thres);
components = find_connected(labelled, 0);

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
hold on;

figure;


no_components = numel(components);

Labels=[components.label];
if no_components>0
    for i=1:6
        index= (Labels==i);
        COMPONENTS(i).data=find_max_components(components(index));
        COMPONENTS(i).no=numel(COMPONENTS(i).data);
    end
end

%% Find a line fit points
figure(LIGHTEN_IMG_FIGURE);

% pts=[];
% for i=1:6
%     data=COMPONENTS(i).data;
%     no=COMPONENTS(i).no;
%     if no>0
%         max_component_size=data(no).size;
%         max_component_pts=data(no).points;
%         avg_pt=mean(max_component_pts,1);
%         pts=[pts;avg_pt];
%         figure(LIGHTEN_IMG_FIGURE);
%         scatter(avg_pt(2),avg_pt(1), 300,Color(i,:),'x');
%         hold on;
%     end
% end

figure(LIGHTEN_IMG_FIGURE);
pts=[];
for i=1:6
    data=COMPONENTS(i).data;
    no=COMPONENTS(i).no;
    if no>0
        max_component_size=data(no).size;
        max_component_pts=data(no).points;
        if (i==2) | (i==5)
            [ ~, avg_pt] = kmeans(max_component_pts, 10, 'MaxIter', 10000, 'EmptyAction', 'drop');
        else
            [ ~, avg_pt] = kmeans(max_component_pts, 5, 'MaxIter', 10000, 'EmptyAction', 'drop');
        end
        pts=[pts;avg_pt];
        scatter(avg_pt(:,2),avg_pt(:,1), 300,Color(i,:),'x');
        hold on;
    end
end

% pts=[];
% for i=1:6
%     data=COMPONENTS(i).data;
%     no=COMPONENTS(i).no;
%     if no>0
%         max_component_size=data(no).size;
%         max_component_pts=data(no).points;
%         pts=[pts;max_component_pts];
%         avg_pt=mean(max_component_pts,1);
%         figure(LIGHTEN_IMG_FIGURE);
%         scatter(avg_pt(2),avg_pt(1), 300,Color(i,:),'x');
%         hold on;
%     end
% end


pts=sortrows(pts,2);
X=pts(:,2);Y=pts(:,1);
pts=[X,Y];
% P = fitPolynomialRANSAC(pts,2,maxDistance,'MaxNumTrials',10000);
% P = polyfit(X,Y,3);

fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1); 
evalLineFcn = ...   % distance evaluation function
  @(model, points) (points(:, 2) - polyval(model, points(:,1)));
[P, ~] = ransac(pts,fitLineFcn,evalLineFcn, ...
  20,maxDistance,'MaxNumTrials',10000);

Y_RecoveredCurve = polyval(P,1:Width);
figure(LIGHTEN_IMG_FIGURE);
plot(1:Width,Y_RecoveredCurve);
hold on;
%% find plateu along lines
rect_start=-30;
rect_end=30;
rect_step=0.5;
Codes=[];
for i=rect_start:rect_step:rect_end
    temp_P=P;
    temp_P(2)=temp_P(2)+i;
    Y_RecoveredCurve = polyval(temp_P,1:Width);
    figure(LIGHTEN_IMG_FIGURE);
    plot(1:Width,Y_RecoveredCurve);
    hold on;
    [color_code,okay]=generate_color_code(img,h_thres,similarity_thres,Height,Width,temp_P);
    if okay
        Codes=[Codes;color_code];
        disp(color_code);
    end
end

color_code=[5];
okay=true;
try
    for i=1:8
        col=Codes(:,1+i);
        [counts,centers] = hist(col',1:6);
        [no,index]=max(counts,[],2);
        code=centers(index);
        if (code==5) | (code==2)
%         if (no<size(Codes,1)) | (code==5) | (code==2)
            okay=false;
        else
            color_code=[color_code code];
        end
    end
catch
    okay=false;
end
color_code=[color_code 2];
if(okay)
    disp(From_Index_To_String(color_code));
else
    disp('error');
end













