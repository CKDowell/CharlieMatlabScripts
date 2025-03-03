function [smalldata,N ] =veccountsCD(data)
% gets the counts of unique vectors in matrices, useful for scatter
% plots/histograms
smalldata = unique(data,'rows');
N = zeros(size(smalldata,1),1);
for d = 1:numel(N)
    idx = ismember(data,smalldata(d,:),'rows');
    data(idx,:) = [];
    N(d) = sum(idx);
end
end