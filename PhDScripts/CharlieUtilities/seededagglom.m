function [Idx,Cv,newseeds] = seededagglom(data,seeds,threshold,maxiter,exclusive,option)


Idx = zeros(size(data,1),size(seeds,1));
Cv = Idx;
newseeds = zeros(size(seeds));
if nargin<4
    maxiter = inf;
end

if nargin<6
    option = 'pearson';
end
for s = 1:size(seeds,1)
    Idxtemp = 1:size(data,1);
    breaker = 0;
    thisseed = seeds(s,:);
    iter= 0;
    datatemp = data;
    while breaker==0
        iter = iter+1;
        disp(iter);
        covvec = covcalcseed(datatemp,thisseed,option);
        cidx = covvec>threshold;
        if sum(cidx)>0
            I = Idxtemp(cidx);
            Idx(I,s) = 1;
            Idxtemp(cidx) = [];
            datatemp(cidx,:) = [];
            thisseed = nanmedian(data(logical(Idx(:,s)),:),1); 
        else
            breaker = 1;
            newseeds(s,:) = nanmedian(data(logical(Idx(:,s)),:),1);
            Cv(:,s) = covcalcseed(data,newseeds(s,:),option);
        end
        if iter==maxiter
            breaker =1;
            newseeds(s,:) = nanmedian(data(logical(Idx(:,s)),:),1);
            Cv(:,s) = covcalcseed(data,newseeds(s,:),option);
        end
    end
end
if exclusive
    Idsum = sum(Idx,2);
    mrthan1 = find(Idsum>1);
    mt1Cv = Cv(mrthan1,:);
    [~,mt1Idx] = max(mt1Cv,[],2);  
    zerodex = sum(Idx,2)==0;
    [~,Idx] = max(Idx,[],2);
    Idx(mrthan1) = mt1Idx;
    Idx(zerodex) = 0;
end

end

