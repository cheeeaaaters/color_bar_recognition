close all;clear all;clc;

vals = randi([0 4*3^7-1],1,50);

index=0;
d='D:\color_bar_recognition\color_code_images\';
for i=1:50
    code=encode(vals(i));
    name=strcat(d,num2str(vals(i)),'.bmp');
    disp(name);
    generate_color_bar_image(400,1500,code,name);
end

