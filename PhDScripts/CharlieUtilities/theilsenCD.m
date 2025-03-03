function [m,c,ypred] = theilsenCD(x,y)
% function does theil sen regression estimation on data

slopes = nan(numel(x)*(numel(x)-1),1);
for i = 1:numel(x)-1
    x2 = circshift(x,i);
    y2 = circshift(y,i);
    slopes((i-1)*numel(x)+1:i*numel(x)) = (y-y2)./(x-x2);
end
m = nanmedian(slopes);
c = nanmedian(y - m.*x);
ypred = x.*m+c;