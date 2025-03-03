function [predictions,probs,logloss,rawerror] = predlogreg(b,x,y)
probs = mnrval(b,x);
%probs = [ones(size(probs,1),1)-sum(probs,2),probs];
[~,predictions] = max(probs,[],2);
rawerror = abs(y-predictions);
i = 1:size(x,1);
ind = sub2ind(size(probs),i',y);
lss = log(probs(ind));
logloss = -nansum(lss(:))./(numel(unique(y))+size(x,1));
end