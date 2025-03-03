function data = interpolateNaN_CD(data)
% uses the interp1 function to interpolate over nans. Works for datasets
% without large blocks of NaNs. For those you should use interpolate_NaNs
% in addition.
t = 1:size(data,1);
for s = 1:size(data,2)
    thisdata = data(:,s);
    ndex = find(isnan(thisdata));
    if numel(ndex)==numel(thisdata)
        warning('All nan in one column')
        continue
    end
    t2 = t;
    t2(ndex) = [];
    thisdata(ndex) = [];
    X = interp1(t2,thisdata,t);
    nancheck = find(isnan(X));
    if isempty(nancheck)
        data(:,s) = X;
        continue
    else
    nancheckdif = diff(nancheck);
    nancheckdif = nancheckdif==1;
    
    if sum(nancheckdif)==numel(nancheckdif)&nancheck(end)==numel(X)
        X(nancheck(1)-1:end) = X(nancheck(1)-1);
        data(:,s) = X;
    else
        interpolate_NaNs(X);
        data(:,s) = X;
    end
    end
    
   
end

end