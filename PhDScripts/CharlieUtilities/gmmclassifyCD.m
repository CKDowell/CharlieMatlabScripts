function [Idx,probs,pdensities] = gmmclassifyCD(indata,modeldir,weights,rankopt)
% function assigns cluster values data based upon gmmodels
if isstring(modeldir)|ischar(modeldir)
    load(modeldir)
else
    gmmodel = modeldir;
end
mu = gmmodel.mu;
if nargin==2|isempty(weights)
    weights = gmmodel.ComponentProportion;
end
sigma = gmmodel.Sigma;
pdensities = zeros(size(indata,1),size(mu,1));
if size(indata,1)>5000
    chunks = 1:5000:size(indata,1);
    chunks(end) = size(indata,1);
end
for i = 1:size(mu,1)
    for c = 1:size(indata,1)
        pdensities(c,i) = ...
            pdensityfun(indata(c,:),mu(i,:),sigma(:,:,i));
    end
end
probs = pdensities;
pdensities = pdensities.*weights;
[~,Idx] = max(pdensities,[],2); 
if nargin>3
    if rankopt
        [c,u] = uniquecount(Idx);
        [c,I] = sort(c,'descend');
        u= u(I);
        Idxnew = zeros(size(Idx));
        for i = 1:numel(u)
            Idxnew(Idx==u(i)) = i;

        end
        Idx = Idxnew;
    end
end
end

function pdensity = pdensityfun(indata,mu,sigma)
scalarvalue = 1./(((2*pi)^size(indata,2)).*det(sigma)^0.5);
expovalue = exp(-0.5*(indata-mu)*inv(sigma)*(indata-mu)');
pdensity = scalarvalue.*expovalue;
end