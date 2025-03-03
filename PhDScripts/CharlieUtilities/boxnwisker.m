function boxnwisker(x,y,w,C)
yp = [prctile(y,[25 50 75],1);min(y,[],1);max(y,[],1)];
for i = 1:numel(x)
    tx = x(i);
    ty = yp(:,i);
    vec = [tx-w./2 tx-w./2 tx+w./2 tx+w./2 tx-w./2];
    vecy = [ty(1) ty(3) ty(3) ty(1) ty(1)];
    if size(C,1)>1
        fill(vec,vecy,C(i,:),'linestyle','none')
    end
    plot(tx+[-w +w]./2,[ty(2) ty(2)],'Color','k')
    plot(tx*[1 1],[ty(4) ty(1)],'Color','k')
    plot(tx*[1 1],[ty(5) ty(3)],'Color','k')
end
end