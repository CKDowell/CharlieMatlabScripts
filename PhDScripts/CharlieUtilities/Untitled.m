function [x,y] = CDmask2poly(mask)
x = [];
y = [];
BW = bwlabel(mask);
ui = unique(BW(:));
ui = ui(ui>0);
for i = 1:ui
poly = mask2poly(BW==ui(i),'outer','mindist');
    pdiff = [0 0;diff(poly,1)];
    pdiff =sum(pdiff.^2,2);
    poly(pdiff>10,:) = nan;
    poly = [poly(1:end-1,:);poly(1,:)];
    x = [x;smooth(poly(:,1),'lowess',5);nan];
    y = [y;smooth(poly(:,2),'lowess',5);nan];
end