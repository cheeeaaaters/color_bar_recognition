function color_code = encode(val)
color_code=zeros(1,8);
if val<4*3^7 && val>=0
    LIST_ZERO=[1,3,4,6];
    LIST_ONE=[3,4,6];
    LIST_TWO=[1,4,6];
    LIST_THREE=[1,3,6];
    LIST_FOUR=[1,3,4];
    prev_bit=0;
    for i=7:-1:0
        q=floor(val/3^i);
        r=mod(val,3^i);
        val=r;
        if i==7
            no=LIST_ZERO(q+1);
            color_code(8-i)=no;
            prev_bit=no;
        else
            switch prev_bit
                case 1 
                    no=LIST_ONE(q+1);
                    color_code(8-i)=no;
                    prev_bit=no;
                case 3
                    no=LIST_TWO(q+1);
                    color_code(8-i)=no;
                    prev_bit=no;
                case 4
                    no=LIST_THREE(q+1);
                    color_code(8-i)=no;
                    prev_bit=no;
                case 6
                    no=LIST_FOUR(q+1);
                    color_code(8-i)=no;
                    prev_bit=no;
            end
        end
    end
end
color_code=[5,color_code,2];
end







