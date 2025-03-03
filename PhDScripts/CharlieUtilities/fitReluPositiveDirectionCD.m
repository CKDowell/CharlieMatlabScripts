function params = fitReluPositiveDirectionCD(x,y,direction)
% Function fits a relu to data by fiting baseline and linear section
% iteratively and choosing combo with smallest MSE AND positive slope, if
% no fit has positive slope the median is chosen

% Fits are only done in the direction indicated
in = isnan(x)|isnan(y);
x(in) = [];
y(in) = [];


if direction==1
    [x,xi] = sort(x,'ascend');
    y = y(xi);
    mse_asc = inf;
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
        x2 = [linspan ones(size(linspan))];
        bet= x2\linspany;
        % sort out intercept
        intcpt = (mn -bet(2))./bet(1);
        yp = getReluCD(x,[i intcpt mn bet' 1]);
        %yp = [mn.*ones(size(mdspan,1)-1,1);x2*bet];
        try
            mse = sum((y-yp).^2);
        catch
            mse = nansum((y-yp).^2);
        end
        if mse<mse_asc&bet(1)>0
            mse_asc = mse;
            params_asc = [i intcpt mn bet'];
        end
    end
    if isinf(mse_asc)
        params = [nan(1,2) nanmedian(y) nan(1,2) 1];
    else
        params = params_asc;
    end
elseif direction==-1
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
        x2 = [linspan ones(size(linspan))];
        bet= x2\linspany;
        intcpt = (mn -bet(2))./bet(1);
        yp = getReluCD(x,[i intcpt mn bet' -1]);
        %yp = [mn.*ones(size(mdspan,1)-1,1);x2*bet];
        try
            mse = sum((y-yp).^2);
        catch
            mse = nansum((y-yp).^2);
        end
        if mse<mse_desc&bet(1)<0
            mse_desc = mse;
            params_desc = [i intcpt mn bet'];
        end
    end
    if isinf(mse_desc)
        params = [nan(1,2) nanmedian(y) nan(1,2) 1];
    else
        params = params_desc;
    end
end
params = [params direction];
end