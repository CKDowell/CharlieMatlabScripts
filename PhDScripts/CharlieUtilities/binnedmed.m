function [dmed] = binnedmed(data1,data2,bins)
% Function outputs median across bins based on another dataset
dmed = nan(numel(bins)-1,1);
for b = 1:numel(bins)-1
    dx = data2>bins(b)&data2<bins(b+1);
    dmed(b) = nanmedian(data1(dx));
end
end