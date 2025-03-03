function masterdex = bunchedIHBcluster(Cludata,param1,param2,param3,param4,masterdexmap,allC)
% Function does multiple small iterations of IHB cluster to centre in on
% good clusters quickly.

checkwithbefore = true;
if nargin < 6
    masterdexmap = (1:size(Cludata,1))';
    allC = [];
    checkwithbefore = false;
end
dsize = size(Cludata,1);
randlist = randperm(dsize);
if dsize>4000
    chunks = [1:4000:dsize dsize];
elseif dsize<1000
    masterdex = zeros(size(Cludata,1),1);
    return
else
    chunks = [1 dsize];
    masterdex = ihbcluster_v3(Cludata',param1,param2,param3,param4);
    return
end
masterdex = zeros(size(Cludata,1),1);
firstdex = masterdex;
firstpass= [];
allI = [];
%% Getting mini clusters
for c = 1:numel(chunks)-1
    cdex = randlist(chunks(c):chunks(c+1));
    thisCdata = Cludata(cdex,:);
    firstpass(c).cdex = cdex;
    [firstpass(c).I, firstpass(c).Cent, nclustz, clsizesorder, corrthr_set] = ihbcluster_v3(thisCdata',param1,param2,param3,param4);
    allI = [allI;[ones(numel(cdex),1)*c, cdex',firstpass(c).I ]];
    allC = [allC;[ ones(size(firstpass(c).Cent.e,1),1)*c, (1:size(firstpass(c).Cent.e,1))',firstpass(c).Cent.e]];
    clc
end
allCO = allC;
allIO = allI;
if unique(allI(:,3))==1
    return
end
cmaster = [];
c1 = 1;
c2 = 2;
n =1;
reclucent = [];
recluidx = [];
iter = 0;

%% Below matches mini clusters together by cross correlation.
while ~isempty(allC)
    iter = iter+100
    
    if numel(unique(allC(:,1)))==1
        reclucent = [reclucent;allC(:,3:end)];
        rnd1 = allC(:,1);
        i1 = allC(:,2); 
        I1 = allI(ismember(allI(:,[1 3]),[rnd1 i1],'rows'),:);
        recluidx = [recluidx;I1];
        allC = [];
        continue
    end
    
    if c2>size(allC,1)
        c2 =1;
    end
    if c1>size(allC,1)
        c1 = 1;
    end
    if allC(c1,1)==allC(c2,1)
        if c2<size(allC,1)
            c2 = c2+1;
        else
            c1 = c1+1;
            c2 = 1;
        end
        continue
    end
    
    cent1 = allC(c1,3:end);
    cent2 = allC(c2,3:end);
    
    covvec = covcalc(cent1,cent2);
    %Main cluster reassignment
    if covvec>0.95
        %first pass
        rnd1 = allC(c1,1);
        rnd2 = allC(c2,1);
        i1 = allC(c1,2);
        i2 = allC(c2,2);
        I1 = allI(ismember(allI(:,[1 3]),[rnd1 i1],'rows'),2);
        I2 = allI(ismember(allI(:,[1 3]),[rnd2 i2],'rows'),2);
        Itot = [I1;I2];
        thisdata = [Cludata(I1,:);Cludata(I2,:)];
        newcent = median(thisdata,1);
        [Inew] = seededagglom(thisdata,newcent,param1,1,1);
        Itot = Itot(logical(Inew));
        masterdex(Itot) = n;
        allC([c1 c2],:) = [];
        for i = 1:size(allC,1)
            rnd = allC(i,1);
            ir = allC(i,2);
            thiscent = allC(i,3:end);
            covvec = covcalc(newcent,thiscent);
            if covvec>0.95
                I1 = allI(ismember(allI(:,[1 3]),[rnd ir],'rows'),2);
                Itot = [I1;find(masterdex==n)];
                thisdata = [Cludata(Itot,:)];
                newcent = median(thisdata,1);
                [Inew] = seededagglom(thisdata,newcent,param1,1,1);
                Itot = Itot(logical(Inew));
                masterdex(Itot) = n;
                allC(i,:) = nan;
            end  
        end 
        cnan = isnan(allC(:,1));
        allC = allC(~cnan,:); 
        n = n+1;
    else
        %second pass, iterates through all others
        notdex = allC(:,1) == allC(c1,1);
        corrC = allC(~notdex,:);
        newcent = cent1;
        remC= [];
        for i = 1:size(corrC,1)
            rnd = corrC(i,1);
            ir = corrC(i,2);
            thiscent = corrC(i,3:end);
            covvec = covcalc(newcent,thiscent);
            if covvec>0.95
                I1 = allI(ismember(allI(:,[1 3]),[rnd ir],'rows'),2);
                Itot = [I1;find(masterdex==n)];
                thisdata = [Cludata(Itot,:)];
                newcent = median(thisdata,1);
                [Inew] = seededagglom(thisdata,newcent,param1,1,1);
                Itot = Itot(logical(Inew));
                masterdex(Itot) = n;
                remC =[remC;find(ismember(allC,corrC(i,:),'rows'))];
            end
        end
        
        allC(remC,:) = [];
        if isempty(remC)
            reclucent = [reclucent;cent1];
            rnd1 = allC(c1,1);
            i1 = allC(c1,2);
            I1 = allI(ismember(allI(:,[1 3]),[rnd1 i1],'rows'),:);
            recluidx = [recluidx;I1];
            allC(c1,:) = [];
        else
            allC(c1,:) = [];
            n = n+1;
        end
    end    
end
%% add unassigned to masterdex
for r = 1:size(reclucent,1)
        rnd = reclucent(r,1);
        ir = reclucent(r,2);
        I1 = allI(ismember(allI(:,[1 3]),[rnd ir],'rows'),2);
        masterdex(I1) = max(masterdex)+1;
end


%% Deals with clusters that are not matched. 
%These could be becuase of some,stochasticity in the clustering. 
% The function is rerun iteratively and remaining clusters matched to the
% output of the other clustering rounds. If this is not achieved then the clusters are accepted.
if ~isempty(recluidx)&size(reclucent,1)<size(allCO,1)
    cluagain = masterdex==0;
    cluagainmap = masterdexmap(cluagain);
    Cludata2 = Cludata(cluagain,:);
    masterdex2 = bunchedIHBcluster(Cludata2,param1,param2,param3,param4);
    unmdex2 = unique(masterdex2);
    unmdex2(unmdex2==0) = [];
    
    if ~isempty(unmdex2)
        irem = zeros(size(unmdex2));
        % match new cents to master dex
        for i = unmdex2'
            thiscent = nanmedian(Cludata2(masterdex2==i,:),1);
            unmdex1 = unique(masterdex);
            unmdex1(unmdex1==0) = [];
            for c = unmdex1'
                testcent = nanmedian(Cludata(masterdex==i,:),1);
                covvec = covcalc(testcent,thiscent);
                if covvec>0.95
                    thisdata = [Cludata2(masterdex2==i,:);Cludata(masterdex==c,:)];
                    dex = [cluagainmap(masterdex2==i);masterdexmap(masterdex==c,:)];                    
                    newcent = nanmedian(thisdata,1);
                    [Inew] = seededagglom(thisdata,newcent,param1,1,1);
                    Inew = dex(logical(Inew));
                    masterdex(Inew) = c;
                    irem(i) = 1;
                    break
                end
            end
        end
        unmdex2 = unmdex2(~logical(irem));
        
        % stick remainders on the end        
        if ~isempty(unmdex2)
                for i = unmdex2'
                    masterdex(cluagainmap(masterdex2==i)) = max(masterdex)+1;
                end
        end
    end
end


end


function covvec = covcalc(data,seed)
    mudata = nanmean(data,2);
    museed = nanmean(seed,2);
    stdseed = nanstd(seed,[],2);
    stddata = nanstd(data,[],2);
    
    datanorm = (data-mudata)./stddata;
    seednorm = (seed-museed)./stdseed;
    covvec = (1/(size(seed,2)-1))*sum(datanorm.*seednorm,2);
end