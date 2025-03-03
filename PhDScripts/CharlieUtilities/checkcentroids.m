function groupings = checkcentroids(cents,threshold)
centcheck = corr(cents');
%centcheck = triu(centcheck);
rem = logical(eye(size(centcheck)));
centcheck(rem) =0;
binc = centcheck>threshold;
groupings = [];
startlist = sum(binc,2);
starts = find(startlist>0);
singletons = find(startlist==0);

i = 0;
while ~isempty(starts)
    start =starts(1);
    i = i+1;
    connec = searchmytree(start,binc);
    connec = connec';
    starts(ismember(starts,connec)) = [];
    groupings.C(i).connec = connec;  
end
groupings.singletons = singletons;
end

function connec = searchmytree(start,binc,connec)
if nargin<3
    connec = [];
end
if sum(connec==start)>0
    return
else
    connec = [connec,start];
end
thisvec = binc(start,:);
nextpoints = find(thisvec>0);
for n = nextpoints
    connec = searchmytree(n,binc,connec);
end
end
