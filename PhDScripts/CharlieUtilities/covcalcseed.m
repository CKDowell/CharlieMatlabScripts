function covvec = covcalcseed(data,seed,option)
if nargin<3
    option = 'pearson';
end
switch option
    case 'pearson'
    mudata = nanmean(data,2);
    museed = nanmean(seed,2);
    stdseed = nanstd(seed,[],2);
    stddata = nanstd(data,[],2);
    
    datanorm = (data-mudata)./stddata;
    seednorm = (seed-museed)./stdseed;
    covvec = (1/(size(seed,2)-1))*sum(datanorm.*seednorm,2);
    case 'spearman'
        n  =size(data,2);
        covvec = nan(size(data,1),size(seed,1));
        [~,drank] = sort(data,2);%rough and ready, does not account for tied
        [~,srank] = sort(seed,2);
        for i  =1:size(seed,1)
            covvec(:,i) = 1-(6*sum((drank-srank(i,:)).^2,2)./(n*(n.^2-1)));
        end
    case 'kendal'
        n  =size(data,2);
        covvec = nan(size(data,1),size(seed,1));
        for s = 1:size(seed,1)
            k = zeros(size(data,1),1);
            for i = 1:n-1 
                 j = i+1;
                 k = k+sum(sign((data(:,j:end)-data(:,i)).*(seed(s,j:end)-seed(s,i))),2);
            end
            covvec(:,s) = 2*k./(n*(n-1));
        end
end
end