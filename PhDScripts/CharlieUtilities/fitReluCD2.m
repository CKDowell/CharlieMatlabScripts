function params =  fitReluCD2(x,y)
in = isnan(x)|isnan(y);
x(in) = [];
y(in) = [];

[x,xi] = sort(x,'ascend');
y = y(xi);
% fit in ascending direction
mse_asc = inf;params_asc = zeros(1,7);params_desc = zeros(1,7);
for i = 1:numel(x)-3
    xfit = [x x ones(size(x,1),2)];
    xfit(1:i,[1 3]) = 0;
    xfit(i+1,[2 4]) = 0;
    bet = xfit\y;
    yp = xfit*bet;
    try
        mse = sum((y-yp).^2);
    catch
        mse = nansum((y-yp).^2);
    end
    if mse<mse_asc
        mse_asc = mse;
        params_asc = [i x(i) bet'];
    end
end

[x,xi] = sort(x,'descend');
y = y(xi);
mse_desc = inf;
for i = 1:numel(x)-2
    xfit = [x x ones(size(x,1),2)];
    xfit(1:i,[1 3]) = 0;
    xfit(i+1,[2 4]) = 0;
    bet = xfit\y;
    yp = xfit*bet;
    try
        mse = sum((y-yp).^2);
    catch
        mse = nansum((y-yp).^2);
    end
    
    if mse<mse_desc
        mse_desc = mse;
        params_desc = [i x(i) bet'];
    end
end

if mse_desc<mse_asc
    params = [params_desc -1];
else
    params = [params_asc 1];
end