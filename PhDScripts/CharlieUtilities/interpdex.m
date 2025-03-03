function dx = interpdex(x,y)
% function does quick interpolation to get new index position
if size(x,2)>size(x,1)
    x = x';
end
if size(y,2)>size(y,1)
    y = y';
end
x = x';
x = repmat(x,numel(y),1);

differ = x-y;
differ(differ<0) = inf;
[dmax,yd] = min(differ,[],1);
dx = nan(size(x,2),1);
dx(dmax==0) = yd(dmax==0);
dmdex = dmax>0;
dmax = dmax(dmdex);
yd = yd(dmdex);
if isempty(yd)
    return
end

yd2 = y(yd+1)-y(yd);
drat =dmax./yd2';
dx(dmdex) = yd+drat;