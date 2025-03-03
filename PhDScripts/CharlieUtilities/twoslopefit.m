function params = twoslopefit(x,y)
in = isnan(x)|isnan(y);
x(in) = [];
y(in) = [];

[x,xi] = sort(x,'ascend');
y = y(xi);
fitqual = nan(numel(x)-10,1);
fits = nan(numel(x),2,2);
for i = 1:numel(x)-10
    dx1 = 1:i+5;
    dx2 = i+6:numel(x);
    x1 = x(dx1);
    y1 = y(dx1);
    x2 = x(dx2);
    y2 = y(dx2);
    
    x1 = [x1];
    x2 = [x2 ones(size(x2))];
    
    bet1 = x1\y1;
    bet2 = x2\y2;
    
    ypred = [x1*bet1;x2*bet2];
    ymse = sum((y-ypred).^2);
    fitqual(i) = ymse;
    fits(i,:,1) = bet1;
    fits(i,:,2) = bet2;
end

[~,best] = min(fitqual);
params.i = best;
params.bet1 = fits(best,:,1);
params.bet2 = fits(best,:,2);



