function pstack = ZBB_Pvalue(allcoords,Idx,resolution,iterations)
%% Function Description
% function tries to ascertain whether data could be a random spatial sample
% of coordinates, or are spatially segregated in different zones
% Outputs bins with pvalues
%% Prep data
pstack = nan(616,1030,420);

zrange = 1:resolution:420;
yrange = 1:resolution:616;
xrange = 1:resolution:1030;
[xx,yy,zz] = meshgrid(xrange,yrange,zrange);
coordlist = [xx(:),yy(:),zz(:)];
coordcount = zeros(size(coordlist,1),iterations);
for c = 1:iterations
    c
    idx_rand = randperm(size(allcoords,1),sum(Idx>0));
    randcoords = allcoords(idx_rand,:);
    coord_dex = findnearest_rows(randcoords,coordlist);
    [cnt,u] = uniquecount(coord_dex);
    coordcount(u,c) = cnt;
end
coordcountR = nan(size(coordlist,1),1);
tcoords = allcoords(Idx,:);
coord_dexR = findnearest_rows(tcoords,coordlist);
[cnt, u] = uniquecount(coord_dexR);
coordcountR(u) = cnt;
coordlook = find(~isnan(coordcountR));

pstack = nan(616,1030,420);
[xp,yp,zp] = meshgrid(1:1030,1:616,1:420);
for f = 1:numel(coordlook)
    tc = coordlist(coordlook(f),:);
    Rcnt = coordcountR(coordlook(f));
    randcnt = coordcount(coordlook(f),:);
    if Rcnt<max(randcnt)
        prct = revprctile(randcnt,Rcnt,'inter');
    else
        prct = 100;
    end
    
    dx = (xp-tc(1)).^2 +(yp-tc(2)).^2 +(zp-tc(3)).^2<=(resolution./2).^2;
    dx = find(dx);
    pstack(dx) = prct;
end

end

function output = findnearest_rows(searchval,searcharray,bias)
output = nan(size(searchval,1),1);
for d = 1:size(searchval,1)
    dist = searcharray-searchval(d,:);
    dist = sum(dist.^2,2);
    [~,m] = min(abs(dist),[],1);
    output(d) = m;
end
end