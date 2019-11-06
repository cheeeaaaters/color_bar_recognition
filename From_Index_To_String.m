function Color_Code = From_Index_To_String(Index)

no=numel(Index);
Color_Code=strings(1,no);
for i=1:no
    index=Index(i);
    switch index
        case 1
            Color_Code(i)='R';
        case 2
            Color_Code(i)='Y';
        case 3
            Color_Code(i)='G';
        case 4
            Color_Code(i)='C';
        case 5
            Color_Code(i)='B';
        case 6
            Color_Code(i)='M';            
    end
end

end

