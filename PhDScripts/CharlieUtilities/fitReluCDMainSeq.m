function params = fitReluCDMainSeq(x,y)
% Function fits a relu to data by fiting baseline and linear section
% iteratively and choosing combo with smallest MSE

% Constrained such that slope portion has to go through the origin
in = isnan(x)|isnan(y);
x(in) = [];
y(in) = [];

[x,xi] = sort(x,'ascend');
y = y(xi);
% fit in ascending direction
mse_asc = inf;params_asc = zeros(1,6);params_desc = zeros(1,6);
for i = 1:numel(x)-3
    mdspan = x(1:i+1);
    mspany = y(1:i+1);
    linspan = x(i+1:end);
    linspany = y(i+1:end);
    try
        mn = median(mspany);
    catch
        mn = nanmedian(mspany);
    end
    x2 = [linspan ];
    bet= [x2\linspany 0];
    % sort out intercept
    intcpt = (mn -bet(2))./bet(1);
    yp = getReluCD(x,[i intcpt mn bet 1]);
    %yp = [mn.*ones(size(mdspan,1)-1,1);x2*bet];
    try
        mse = sum((y-yp).^2);
    catch
        mse = nansum((y-yp).^2);
    end
    if mse<mse_asc
        mse_asc = mse;
        params_asc = [i intcpt mn bet];
    end
end
% fit in descending direction
[x,xi] = sort(x,'descend');
y = y(xi);
mse_desc = inf;
for i = 1:numel(x)-2
    mdspan = x(1:i+1);
    mspany = y(1:i+1);
    linspan = x(i+1:end);
    linspany = y(i+1:end);
    try
        mn = median(mspany);
    catch
        mn = nanmedian(mspany);
    end
    x2 = [linspan];
    bet= [x2\linspany 0];
    intcpt = (mn -bet(2))./bet(1);
    yp = getReluCD(x,[i intcpt mn bet -1]);
    %yp = [mn.*ones(size(mdspan,1)-1,1);x2*bet];
    try
        mse = sum((y-yp).^2);
    catch
        mse = nansum((y-yp).^2);
    end
    if mse<mse_desc
        mse_desc = mse;
        params_desc = [i intcpt mn bet];
    end
end


if mse_desc<mse_asc
    params = [params_desc -1];
else
    params = [params_asc 1];
end
