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

%interesting cases but succeeds
%13,24,26,28,33

%failed cases
%7,9
img_name='C:\Users\cheee\Desktop\UST\fyp\color_bar\color_bar_recognition_2\color_bar_recognition\color_code\color_code\code\code_a\000.jpg';
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

no_components = numel(components);
Labels=[components.label];

mean_pts = [];

for i=1:no_components
   if(components(i).size > 100)
       avg_pt=mean(components(i).points,1);
       mean_pts=[mean_pts; avg_pt components(i).label];
       figure(LIGHTEN_IMG_FIGURE);
       scatter(avg_pt(2),avg_pt(1));
       hold on;
   end
end



%%%%%%%%%%%%%%%%%% Hough Transform
num_peaks = 50;

mean_pts_mask = logical(accumarray(round(mean_pts(:,1:2)), 1, [Height Width]));
[H1,T1,R1] = hough(mean_pts_mask,'RhoResolution',0.5,'Theta',-90:0.5:89);
P=houghpeaks(H1,num_peaks);

hough_figure = figure;
imshow(H1,[],'XData',T1,'YData',R1,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(T1(P(:,2)),R1(P(:,1)),'s','color','white');

theta = T1(P(:,2));
rho = R1(P(:,1));

for peak_num=1:size(P,1)

newfig = figure;
imshow(lighten_img);

dtr = pi/180;
for i=1:numel(theta)
    line_theta = theta(i);
    line_rho = rho(i);
    x = 1:Width;
    y = (line_rho - x*cos(line_theta*dtr))/sin(line_theta*dtr);
    plot(x,y);
end

P = [-cos(theta(peak_num)*dtr)/sin(theta(peak_num)*dtr) rho(peak_num)/sin(theta(peak_num)*dtr)];

hold on;
%% find plateu along lines
rect_start=-30;
rect_end=30;
rect_step=0.5;
Codes=[];
for i=rect_start:rect_step:rect_end
    temp_P=P;
    temp_P(2)=temp_P(2)+i/sin(theta(peak_num)*dtr);
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
    break;
else
    disp('error');
end

close(newfig);

end;