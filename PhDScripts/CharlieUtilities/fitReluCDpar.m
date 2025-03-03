function params = fitReluCDpar(x,y)
% Function fits a relu to data by fiting baseline and linear section
% iteratively and choosing combo with smallest MSE
[x,xi] = sort(x,'ascend');
y = y(xi);
% fit in ascending direction
mseall = nan(numel(x)-3,1);
paramsall = nan(numel(x)-3,6);
parfor i = 1:numel(x)-3
    mdspan = x(1:i+1);
    mspany = y(1:i+1);
    linspan = x(i+1:end);
    linspany = y(i+1:end);
    
    mn = nanmedian(mspany);
    x2 = [linspan ones(size(linspan))];
    bet= x2\linspany;
    % sort out intercept
    intcpt = (mn -bet(2))./bet(1);
    yp = getReluCD(x,[i intcpt mn bet' 1]);
    %yp = [mn.*ones(size(mdspan,1)-1,1);x2*bet];
    mseall(i,:) = nanmean((y-yp).^2);
    paramsall(i,:) = [i intcpt mn bet' 1];
end
[mse_asc,ai] = min(mseall);
params_asc = paramsall(ai,:); 

% fit in descending direction
[x,xi] = sort(x,'descend');
y = y(xi);
mse_desc = inf;
mseall = nan(numel(x)-3,1);
paramsall = nan(numel(x)-3,6);
for i = 1:numel(x)-2
    mdspan = x(1:i+1);
    mspany = y(1:i+1);
    linspan = x(i+1:end);
    linspany = y(i+1:end);
    
    mn = nanmedian(mspany);
    x2 = [linspan ones(size(linspan))];
    bet= x2\linspany;
    intcpt = (mn -bet(2))./bet(1);
    yp = getReluCD(x,[i intcpt mn bet' -1]);
    %yp = [mn.*ones(size(mdspan,1)-1,1);x2*bet];
    mseall(i,:) = nanmean((y-yp).^2);
    paramsall(i,:) = [i intcpt mn bet' 1];
end
[mse_desc,ai] = min(mseall);
params_desc = paramsall(ai,:); 

if mse_desc<mse_asc
    params = [params_desc];
else
    params = [params_asc];
end
