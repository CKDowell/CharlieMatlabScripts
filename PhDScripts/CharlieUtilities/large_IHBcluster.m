function masterdex = large_IHBcluster(Cludata,chunksize,param1,param2,param3,param4)
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
    [Inew] = seededagglom(Cludata,Cent.e,param1,1,1);
    masterdex(Inew>0) = Inew(Inew>0);
    newCludata = Cludata(masterdex==0,:);
    newdex = largedex(masterdex==0);
    seconddex = large_IHBcluster(newCludata,chunksize,param1,param2,param3,param4);
    seconddex = seconddex+max(masterdex);
    seconddex(seconddex==max(masterdex)) =0;
    masterdex(newdex(seconddex>0)) = seconddex(seconddex>0);
else
    masterdex = ihbcluster_v3(Cludata',param1,param2,param3,param4);
end



end