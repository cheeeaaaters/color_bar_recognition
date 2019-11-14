close all;clear all;clc;

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
%img_name='C:\Users\cheee\Desktop\UST\fyp\color_bar\OneDrive_2019-11-11\result_img\Tray_75\Tray_75.jpg';
img_name='C:\Users\cheee\Desktop\UST\fyp\color_bar\OneDrive_2019-11-11\result_img\Tray_64\bar_0.jpg';
%img_name='C:\Users\cheee\Desktop\UST\fyp\color_bar\OneDrive_2019-11-11\result_img\Tray_74\bar_0.jpg';
%img_name='C:\Users\cheee\Desktop\UST\fyp\color_bar\color_bar_recognition_2\color_bar_recognition\color_code\color_code\code\code_b\7.png';
img_rgb=imread(img_name);
%img_rgb=imrotate(img_rgb, 90);
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

labelled = label_image(img_rgb,lighten_img,img,h_thres,s_thres,v_thres,white_thres,black_thres,lighten_white_thres,lighten_black_thres,var_thres);
components = find_connected(labelled, 0);

show_labelled(labelled);

mean_pts = get_mean_pts(components, LIGHTEN_IMG_FIGURE, 50);

%%%%%%%%%%%%%%%%%% Hough Transform
num_peaks = 10;

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

hold off;

codes_info = [];
perfect_found = false;

for peak_num=1:size(P,1)
%for peak_num=2:2

%newfig = figure;
%imshow(lighten_img);
%hold on;

dtr = pi/180;

    line_theta = theta(peak_num);
    line_rho = rho(peak_num);
    x = 1:Width;
    y = (line_rho - x*cos(line_theta*dtr))/sin(line_theta*dtr);    
    %plot(x,y);

line = [-cos(theta(peak_num)*dtr)/sin(theta(peak_num)*dtr) rho(peak_num)/sin(theta(peak_num)*dtr)];

components = find_connected(labelled, 0);
if(numel(components) < 1) 
    continue;
end
mean_pts = get_mean_pts(components, -1, 50);

indexes = mean_pts(:,4);
pts = mean_pts(:,1:2);
remain_components = components(indexes);

componentMap = create_component_map([Height Width], remain_components, indexes);
distances = get_distance_to_line(pts, line);
sizes = get_size_of_component(remain_components, pts);
lengths = get_length_of_component(componentMap, pts, indexes, line);

scores = iterative_cal_score(pts, distances, sizes, lengths);

high_scores = scores > 0.8;
high_indexes = indexes(high_scores);
high_components = components(high_indexes);
estimate_width = estimate_bar_width(high_components);

clipped = clip_labelled(labelled, estimate_width, line);

%labelled_figure = show_labelled(clipped);
%hold on;

components = find_connected(clipped, 0);
if(numel(components) < 1) 
    continue;
end
mean_pts = get_mean_pts(components, -1, 30);

indexes = mean_pts(:,4);
pts = mean_pts(:,1:2);
remain_components = components(indexes);

componentMap = create_component_map([Height Width], remain_components, indexes);
distances = get_distance_to_line(pts, line);
sizes = get_size_of_component(remain_components, pts);
lengths = get_length_of_component(componentMap, pts, indexes, line);

scores = iterative_cal_score(pts, distances, sizes, lengths);

[colorcode, ok, confidence, variance] = validate_and_generate(scores, mean_pts, line);

disp(From_Index_To_String(colorcode));
disp((confidence));
disp(mean(confidence))
disp(variance);

if ok
    perfect_code = colorcode;
    perfect_confidence = confidence;
    perfect_found = true;
    break;
end

code_info.code = colorcode;
code_info.confidence = confidence;
code_info.variance = variance;
code_info.peak_num = peak_num;

codes_info = [codes_info; code_info];

end

if (~perfect_found)
    [repaired, trust] = repair_code(codes_info);
    disp(From_Index_To_String(repaired));
    disp(trust);

    disp("Most probable result:");
    [~, ii] = maxk(trust,8);
    mymask = true(1,numel(repaired));
    mymask(ii) = false;
    repaired(mymask) = [];
    trust(mymask) = [];
    
    avg = mean(trust);
    repaired(trust < (avg/2)) = [];

    disp(From_Index_To_String(repaired));
else
    disp("Most probable result:");
    disp(From_Index_To_String(perfect_code));
    disp(perfect_confidence);
end