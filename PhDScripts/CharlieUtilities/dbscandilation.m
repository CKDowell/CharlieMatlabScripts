function Idx = dbscandilation(Idx,data,rad)
% function dilates dbscan cluster assigments by making pdf estimate and assigning
% unclustered points to clusters within radius with highest mean gradient
% of pdf in first 3rd of vector drawn from point to cluster centroid.
% Could be improved but works a little better than just assigning to
% nearest centroid.
% Charlie Dowell UCL 2020
IdxO = Idx;
x = linspace(min(data(:,1)),max(data(:,1)),301);
y = linspace(min(data(:,2)),max(data(:,2)),301);
%% Get probability density estimate
[pdf] = histcounts2(data(:,1),data(:,2),x,y,'Normalization','pdf'); % rough pdf
pdf = imgaussfilt(pdf,6);
% X- y coordinates in pdf space
x = x(2:end)- mean(diff(x))./2;
y = y(2:end)- mean(diff(y))./2;

izero = find(IdxO==0);%unclustered points
redrednz = data;
redrednz(IdxO==0) = nan;
centroids = [];
centcoos = nan(max(Idx),2);
% get centroid coordinates
for i = 1:max(Idx)
    centroids = [centroids;nanmedian(data(Idx==i,:),1)];
    centcoos(i,1) = findnearest(centroids(i,1),x);
    centcoos(i,2) = findnearest(centroids(i,2),y);
end

for i = izero'
    
    ti = data(i,:);
    
    dif = redrednz-ti;% distance of points
    dif = sqrt(sum(dif.^2,2));
    ddex = dif<rad;
    % check if no points within the radius
    if sum(ddex)==0
        continue
    end
    %%
    ddexI = IdxO(ddex);
    uI = unique(ddexI);
    if numel(uI) ==1
        Idx(i) = uI; %if only 1 Idx nearby choose it
    else % If more than one we will use the pdf
        ix = findnearest(ti(1),x);
        iy = findnearest(ti(2),y);
        centsi = nan(numel(uI,2));
        % choose nearest point of cluster rather than the centroid
        for u = 1:numel(uI)
            tldex = find(ddex&IdxO==uI(u));
            tldif = dif(tldex);
            [~,tlI] = min(abs(tldif));
            thislot = data(tldex(tlI),:);
            
            centsi(u,1) = findnearest(thislot(1),x);
            centsi(u,2) = findnearest(thislot(2),y);
        end
        
        check = nansum(abs(centsi-[ix iy]),2);
        % if only Idx on bin choose it
        if sum(check<5)>0 %within 1 bin
            [~,umn] = min(check); 
            Idx(i) = uI(umn);
            continue
        end
        
        % Otherwise use gradient
        centsi = centcoos(uI,:); %centroid location of clusters of interest
%         centsi = nan(numel(uI),2);
%         for b = 1:numel(uI)
%             tcents = data(IdxO==uI(b),:);
%             cdiff = sum((tcents-ti).^2,2);
%             [~,cm] = min(cdiff);
%             centsi(b,1) = findnearest(tcents(cm,1),x);
%             centsi(b,2) = findnearest(tcents(cm,2),y);
%         end
        
        %% Find pdf transect from point to cluster centroids
        centvecs = nan(21,numel(uI)); %initialise vectors
        centxs = nan(21,numel(uI));
        
        for u = 1:numel(uI)
            grad = (centsi(u,2)-iy)./(centsi(u,1)-ix);
            xs = linspace(ix,centsi(u,1),21);
            if isinf(grad)|grad==0|isnan(grad)
                ys = linspace(iy,centsi(u,2),21);
            else
                ys = iy+(xs-ix)*grad;
            end
            xs = round(xs);
            ys = round(ys);
            
            try
            centxs(:,u) = sqrt(x(xs).^2+y(ys).^2);
            catch
                keyboard
            end
            id = sub2ind(size(pdf),xs,ys);
            centvecs(:,u) = pdf(id); 
        end
        %% Get gradient of pdf transects
        centvecs = centvecs./centvecs(end,:);% Normalise
        centdiff = diff(centvecs,1)./abs(diff(centxs,1));% needs to be abs to get over directionality
        centdiff(centvecs==0) = 1;
        centdiff(isinf(centdiff)) = nan;
        for b =1:size(centdiff,2)
            centdiff(:,b) = interpolate_NaNs(centdiff(:,b));
        end
        % Get increasing bins
        centdiffbin = sign(centdiff);
        negcentdiff = centdiff(1:10,:)<-0.5;
        nrem = zeros(1,size(negcentdiff,2));
        for b = 1:size(negcentdiff,2)
            [bl,bs] = findblocks(negcentdiff(:,b));
            if max(bs)>1
                nrem(b) = 1;
            end
        end
        %centdiff(:,nrem>0) = nan;
        weighting = 0:size(centdiff,1)-1;
        %centdiff = centdiff.*(exp(-weighting./5))';
        %% Choose centroid with most increasing bins across transect
        mdiff = nansum(centdiffbin(1:10,:),1);
        [~,choice] = max(mdiff);
        Idx(i) = uI(choice);
        IdxO = Idx; % update IdxO %could be dangerous
        %% checkplots
%                 subplot(1,2,1)
%                 pdf2 = imrotate(pdf,90);
%                 imagesc(pdf2)
%                 hold on
%                 scatter(ix,size(pdf,2)-iy,'MarkerEdgeColor','k')
%                 scatter(centsi(:,1),size(pdf,2)-centsi(:,2),'.','MarkerEdgeColor','r')
%                 colours = hsv(size(centsi,1));
%                 for r = 1:size(centsi,1)
%                     if r==choice
%                         plot([ix centsi(r,1)],size(pdf,2)-[iy centsi(r,2)],'Color',colours(r,:),'LineWidth',2)
%                     else
%                         plot([ix centsi(r,1)],size(pdf,2)-[iy centsi(r,2)],'Color',colours(r,:))
%                     end
%                 end
%                 hold off
%                 subplot(1,2,2)
%                 for r = 1:size(centsi,1)
%                     if r==choice
%                         plot(centdiff(:,r),'Color',colours(r,:),'LineWidth',2)
%                     else
%                         plot(centdiff(:,r),'Color',colours(r,:),'LineWidth',1)
%                     end
%                     hold on
%                 end
%                 hold off
%                 keyboard
    end

end
end