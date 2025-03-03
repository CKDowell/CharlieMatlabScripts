function masterdex = reallybig_IHBcluster(Cludata,chunksize,param1,param2,param3,param4,itnum,maxchunksize)
if isempty(itnum)
    itnum =0;
else
    chunksize = min(chunksize*itnum,maxchunksize);
end
dsize = size(Cludata,1);
largedex = 1:size(Cludata,1);
largedex = largedex';
randlist = randperm(dsize);
masterdex = zeros(size(Cludata,1),1);
% Cluster first pass then iterate again until none are clustered anymore
if dsize(1)>chunksize
    thisdex = randlist(1:chunksize);
    [Idx, Cent, nclustz, clsizesorder, corrthr_set] = ihbcluster_v3(Cludata(thisdex,:)',param1,param2,param3,param4);
    if sum(Idx)==0
        return
    end
    
    covvec = zeros(size(Cludata,1),size(Cent,1));
    for i = 1:max(Idx)
        covvec(:,i) = covcalcseed(Cludata,Cent.e(i,:));
    end
    covvec(covvec<param1) = 0;
    zers = sum(covvec,2)==0;
    [~,Inew] = max(covvec,[],2);
    Inew(zers) = 0;
    masterdex(Inew>0) = Inew(Inew>0);
    newCludata = Cludata(masterdex==0,:);
    newdex = largedex(masterdex==0);
    seconddex = reallybig_IHBcluster(newCludata,chunksize,param1,param2,param3,param4,itnum+1,maxchunksize);
    seconddex = seconddex+max(masterdex);
    seconddex(seconddex==max(masterdex)) =0;
    masterdex(newdex(seconddex>0)) = seconddex(seconddex>0);
else
    masterdex = ihbcluster_v3(Cludata',param1,param2,param3,param4);
end



end