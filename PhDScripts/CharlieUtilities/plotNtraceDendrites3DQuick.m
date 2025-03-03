function plotNtraceDendrites3DQuick(trace,xi,yi,zi,colour1,alpha)
hold on

ndiff = trace(:,1)-trace(:,7);
branches = find(ndiff~=1);
branches(branches==1) = [];
blist = [2;branches];
for b = 1:size(blist,1)-1
    bs = blist(b);
    be = blist(b+1)-1;
    x1 = trace(bs:be,xi);
    y1 = trace(bs:be,yi);
    z1 = trace(bs:be,zi);
    p = plot3(x1, y1, z1,'Color',colour1);
    p.Color(4) = alpha;
end
for b = 1:size(branches)
    i = branches(b);
    
    x1 = trace(i,xi);
    y1 = trace(i,yi);
    z1 = trace(i,zi);
    dx = trace(i,7);
    x2 = trace(dx,xi);
    y2 = trace(dx,yi);
    z2 = trace(dx,zi);
    p = plot3([x2 x1],[y2 y1],[z2 z1],'Color',colour1);
    p.Color(4) = alpha;
end


hold off
end