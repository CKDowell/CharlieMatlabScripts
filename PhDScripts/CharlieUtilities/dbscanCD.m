function Idx = dbscanCD(X,epsilon,minpts)
% Implements DBSCAN in a memory efficient way. Has random initiation points
% Charlie Dowell UCL 2019

Idx = zeros(size(X,1),1);
candidates = 1:numel(Idx);
candidates = randperm(numel(Idx));
idnum = 1;

c = candidates(1);
cnt = 1;
prog = 0;
f = waitbar(prog,'Progress...');
while ~isempty(candidates)   
    
    ID = expandcluster(X,c,minpts,epsilon,c);
    
    if numel(ID)>minpts
        Idx(ID) = idnum;
        disp(['Cluster ' num2str(idnum)])
        idnum =idnum+1;
        prog = prog+(numel(ID)./numel(Idx));
        waitbar(prog,f,['Progress ' num2str(round(prog*100))])
        pause(0.1)
    else
        prog = prog+(numel(ID)./numel(Idx));
    end
    
    
    candidates(ismember(candidates,ID)) = [];
    if isempty(candidates)
        break
    end
    c = candidates(1);
    cnt = cnt+1;
    if cnt>numel(Idx)
        keyboard
    end
end
close(f)
end

function ID = expandcluster(X,c,mnpts,epsilon,ID)
IDo = ID;
xc = X(c,:);
distX = sqrt(sum((X-xc).^2,2));
closesacs = distX<epsilon;
if sum(closesacs)>mnpts
    closesacs = find(closesacs);
    closesacs(closesacs==c) = [];
    if sum(ismember(closesacs,ID))==numel(closesacs)
        return
    end
    ID = unique([ID;closesacs]);
    closesacs = closesacs(~ismember(closesacs,IDo));
    for c = closesacs'
        ID = expandcluster(X,c,mnpts,epsilon,ID);
    end
else
    return
end
end