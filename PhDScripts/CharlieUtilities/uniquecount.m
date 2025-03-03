function [count,c,ic,ia] = uniquecount(data,varargin)
% function outputs the count of unique data

if nargin>1
    [c,ia,ic] = unique(data,varargin{1});%simple fix for rows
else
    [c,ia,ic] = unique(data);
end
count = accumarray(ic,1);

% if min(size(c))==1
%     count = nan(numel(c),1);
%     NC = numel(c);
% else
%    count = nan(size(c,1),1); 
%    NC = size(c,1);
% end
% for i = 1:NC
%     if min(size(c))==1
%         count(i) = sum(data==c(i));
%     else
%         count(i) = sum(ismember(data,c(i,:),'rows'));
%     end
% end