function yp = getReluCD2(x,params)
xfit = [x x ones(size(x,1),2)];
if params(7)==1
    zdx = x<=params(2);
else
   zdx = x>=params(2);
end
xfit(zdx,[1 3]) = 0;
xfit(~zdx,[2 4]) = 0;
yp = xfit*params(3:6)';