function ranks = CKDdistancerank(data,dpoint,dthresh,dmetric)
%% Function description
% Function pairs up closest points then takes centroids and pairs again
% if distance is less than dthresh. Function iterates until all data are
% ordered according to pairing sequence
% 



%% Initial pairing
unpaired =  1:size(data,1);
paired = [];
breaker = false;
iter = 0;
dmet = 'euclidean';
if nargin<2
    [~,dpoint] = max(sum(data.^2,2));
end
if nargin<3
    dthresh = inf;
end
if nargin>3
    dmet = dmetric;
end
%dpoint = unpaired(randperm(numel(unpaired),1));

while ~breaker
    thispoint = data(dpoint,:);
    switch dmet
        case 'euclidean'
            distance = sum((data-thispoint).^2,2);
        case 'correlation'
            distance = covcalcseed(data,thispoint);
    end
    distance(distance==0) = nan;
    distance(paired(:)) = nan;
    [~,p] = min(distance,[],'omitnan');
    paired = [paired,[dpoint;p]];
    unpaired(ismember(unpaired,paired(:))) = [];
    if numel(unpaired)==1
        paired = [paired,[unpaired;nan]];
        breaker = true;
    elseif isempty(unpaired)
        breaker = true;
    end
    iter = iter+1;
    disp(num2str(iter))
    [~,dpoint] = max(distance,[],'omitnan');
end
clc
breaker = false;
paired2 = [];
oldsize = size(paired,1);
while ~breaker
    
    pcents = nan(size(paired,2),size(data,2));
    spread = nan(size(paired,2),1);
    for p = 1:size(paired,2)
        pdx = paired(:,p);
        pdx = pdx(~isnan(pdx));
        pcents(p,:) = nanmedian(data(pdx,:),1);
        if size(pcents,1)>8
            switch dmet
                case 'euclidean'
                    spread(p) = std(sum((data(pdx,:)-pcents(p,:)).^2,2));
                case 'correlation'
                    spread(p) = std(covcalcseed(data(pdx,:),pcents(p,:)));
            end
        else 
            spread(p) = 1;
        end
    end
    scatter(data(:,1),data(:,2),'.','MarkerEdgeColor',[0.5 0.5 0.5]);
    hold on
    scatter(pcents(:,1),pcents(:,2),'MarkerEdgeColor','r')
    hold off
    drawnow
    while ~isempty(paired)
        if size(paired,2)==1
            paired2 = [paired2,[paired(:,1);nan(size(paired,1),1)]];
            paired = [];
            break
        elseif size(paired,2)==2
            paired2 = [paired2,paired(:)];
            paired = [];
            break
        end
        
        strt = paired(:,1);
        paired(:,1) = [];
        srtdx = strt(~isnan(strt));
        thispoint = pcents(1,:);
        pcents(1,:) = [];
        spread(1) = [];
        switch dmet
            case 'euclidean'
                distances = sum((pcents-thispoint).^2,2);%./spread;%recalibrate units to spread of neighbour
            case 'correlation'
                distances = covcalcseed(pcents,thispoint);
        end
        [mndist,i] = min(distances);
        if mndist<dthresh
            paired2 = [paired2,[strt;paired(:,i)]];
            paired(:,i) = [];
            pcents(i,:) = [];
            spread(i) = [];
        else
            paired2 = [paired2,[strt;nan(size(paired,1),1)]];
        end
            
        
        
%thispoint = nanmedian(data(srtdx,:),1);

%         distances = nan(size(data,1),numel(strt));
%         for d = 1:size(thispoint,1)
%             distances(:,d) = sum((data-thispoint(d,:)).^2,2);
%         end
%         distances(srtdx,:) = nan;
%         rmdx = paired2(:);
%         rmdx = rmdx(~isnan(rmdx));
%         distances(rmdx,:) = nan;
%         [~,i] = min(distances(:));
%         [i,~] = ind2sub(size(distances),i);
%         [~,jdx] = find(paired==i);
%         paired2 = [paired2,[strt;paired(:,jdx)]];
%         
%         paired(:,jdx) = [];
        
    end
    paired = paired2;
    nanpaired = isnan(paired(end,:));
    if sum(nanpaired)==size(paired,2)|size(paired,1)>size(data,1)
        dthresh =inf;
    end
        oldsize = size(paired,2);
    paired2 = [];
    if size(paired,2)==2
        paired = paired(:);
        breaker = true;
    elseif size(paired,1)==1
        breaker = true;  
    end
    disp(num2str(size(paired,1)))
end
ranks = paired(~isnan(paired));








