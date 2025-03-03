function p = errorbandV(Xupper,Xlower,Y,colour)
if nargin ==3
    colour = [0.3 0.3 0.3];
end
if size(Y,2)>1
    Y = Y';
end
if size(Xlower,2)>1
    Xlower = Xlower';
end
if size(Xupper,2)>1
    Xupper = Xupper';
end
Xlower(isnan(Xlower)) = 0;
Xupper(isnan(Xupper)) = 0;
Xlower(isinf(Xlower)) = 0;
Xupper(isinf(Xupper)) = 0;
p = fill([Xlower;flipud(Xupper)],[Y;flipud(Y)],colour,'linestyle','none');
end