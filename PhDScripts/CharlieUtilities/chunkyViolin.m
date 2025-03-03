function chunkyViolin(data,x,bins,colour,varargin)
% Function makes a violin style plot but with histogram rather than
% kdensity estimates

if nargin>4
    alpha = varargin{1};
else
    alpha = 1;
end
plotbins = bins(2:end)-mean(diff(bins))./2;
plotmatrix = nan(numel(plotbins),size(data,2));
% Gather data
for i = 1:size(data,2)
    plotmatrix(:,i) = histcounts(data(:,i),bins,'Normalization','probability');
end
% Plot data
for i = 1:size(data,2)
    xb = plotmatrix(:,i)./2;
    xupper = x(i)-xb;
    xlower = x(i)+xb;
    e = errorbandV(xupper,xlower,plotbins,colour);
    e.FaceAlpha =alpha;
    hold on
end
hold off