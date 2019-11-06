function val = decode(color_code)
    val=0;
    temp=color_code(2:9);
    for i=8:-1:1
        if i==1
            prev_bit=0;
        else
            prev_bit=temp(i-1);
        end
        index =map_from_color_to_no(prev_bit, temp(i))-1;
        val=val+index*3^(8-i);
    end
end

function index =map_from_color_to_no(prev_bit, current_bit)
    LIST_ZERO=[1,3,4,6];
    LIST_ONE=[3,4,6];
    LIST_TWO=[1,4,6];
    LIST_THREE=[1,3,6];
    LIST_FOUR=[1,3,4];
    switch prev_bit
        case 0
            index=find(LIST_ZERO==current_bit);
        case 1 
            index=find(LIST_ONE==current_bit);
        case 3
            index=find(LIST_TWO==current_bit);
        case 4
            index=find(LIST_THREE==current_bit);
        case 6
            index=find(LIST_FOUR==current_bit);
    end
end


