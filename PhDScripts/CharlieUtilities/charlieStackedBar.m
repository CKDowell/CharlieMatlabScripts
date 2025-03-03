function charlieStackedBar(data,colours,offsetx,width,offsety)
data2 = cumsum(data,1);
data2 = [zeros(1,size(data,2));data2];
for d = 1:size(data,2)
    x = [offsetx offsetx+width];
    for d2 = 1:size(data,1)
        errorband(x,[data2(d2+1,d) data2(d2+1,d)]+offsety,[data2(d2,d) data2(d2,d)]+offsety,colours(d2,:));
        hold on
    end
    offsetx = offsetx+width;
end