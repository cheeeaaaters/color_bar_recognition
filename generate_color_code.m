function [color_code,okay] = generate_color_code(img,h_thres,similarity_thres,Height,Width,P)
    okay=false;
    color_code=0;
    %FIGURE=figure;
    
    endPoints = [];
    m = P(1);
    c = P(2);
    i_h_top = -c/m;
    i_h_bot = (Height-c)/m;
    i_v_left = c;
    i_v_right = m*Width + c;
    if((i_h_top >= 0) && (i_h_top <= Width))
        endPoints = [endPoints; i_h_top 0];
    end
    if((i_h_bot >= 0) && (i_h_bot <= Width))
        endPoints = [endPoints; i_h_bot Height];
    end
    if((i_v_left >= 0) && (i_v_left <= Height))
        endPoints = [endPoints; 0 i_v_left];
    end
    if((i_v_right >= 0) && (i_v_right <= Height))
        endPoints = [endPoints; Width i_v_right];
    end
    
    if(size(endPoints,1) ~= 2)
        return;
    end
    
    e1 = endPoints(1,:);
    e2 = endPoints(2,:);
    length = sqrt((e1(1)-e2(1))^2 + (e1(2)-e2(2))^2);
    T = round(length);
       
     
try
    hue_values_along_line=zeros(1,T);
    X=round(linspace(e1(1), e2(1), T));
    Y=round(linspace(e1(2), e2(2), T));
    for t=1:T
        x=X(t);
        y=Y(t);
        if y>=1 && y<=Height
            hue_values_along_line(t)=img(y,x,1)*360;
        else
            hue_values_along_line(t)=-1;
        end
    end

    similarity_along_line = zeros(1,T);
    for t=1:T
         [n1, n2] = find_similar(hue_values_along_line,t,similarity_thres,0);
         similarity_along_line(t) = min(n1,n2);
    end
     %plot (1:T,similarity_along_line);
   % hold on;
    [pks,locs,~,~] = findpeaks(similarity_along_line);
    % scatter(locs,pks);
    % plot (1:T,hue_values_along_line,'color',[0,0,0]);
   %hold on;

    valid_color_pts=zeros(1,T);
    valid_pts_no=0;
    prev_valid_pt=0;
    for i=1:numel(locs)
        [color,type]= find_best_max(hue_values_along_line(locs(i)),h_thres);
        if ~strcmp(color,'null') 
            % plot(locs(i),hue_values_along_line(locs(i)),'marker','x','color',color);
           % hold on;
            if type~=prev_valid_pt
                valid_pts_no=valid_pts_no+1;
                valid_color_pts(valid_pts_no)=type;
                prev_valid_pt=type;
            end
        end
    end
    valid_color_pts=valid_color_pts(valid_color_pts>0);
    all_positions=1:valid_pts_no;

    blue_positions=all_positions(valid_color_pts==5);
    yellow_positions=all_positions(valid_color_pts==2);
    B=repelem(blue_positions,numel(yellow_positions));
    Y=repmat(yellow_positions,1,numel(blue_positions));
    code_no=abs(Y-B)-1;
    valid_blue_positions=B(code_no==8);
    valid_yellow_positions=Y(code_no==8);

    if numel(valid_blue_positions)==1
        okay=true;
        if min([valid_blue_positions,valid_yellow_positions])==valid_blue_positions
            color_code=valid_color_pts(valid_blue_positions:valid_yellow_positions);
        else
            color_code=fliplr(valid_color_pts(valid_yellow_positions:valid_blue_positions));
        end
    else
         %close(FIGURE);
    end
catch
     %close(FIGURE);
end
end

