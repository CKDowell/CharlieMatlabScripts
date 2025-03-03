function p = errorband(X,Yupper,Ylower,colour)
if nargin ==3
    colour = [0.3 0.3 0.3];
end
if size(X,2)>1
    X = X';
end
if size(Ylower,2)>1
    Ylower = Ylower';
end
if size(Yupper,2)>1
    Yupper = Yupper';
end
Ylower(isnan(Ylower)) = 0;
Yupper(isnan(Yupper)) = 0;
Ylower(isinf(Ylower)) = 0;
Yupper(isinf(Yupper)) = 0;
p = fill([X;flipud(X)],[Ylower;flipud(Yupper)],colour,'linestyle','none');
end