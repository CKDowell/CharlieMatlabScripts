function [x,y] = CDmask2poly(mask,varargin)
if nargin>1
    smth = varargin{1};
else
    smth = 5;
end
x = [];
y = [];
BW = bwlabel(mask);
ui = unique(BW(:));
ui = ui(ui>0);
for i = 1:numel(ui)
poly = mask2poly(BW==ui(i),'outer','mindist');
    pdiff = [0 0;diff(poly,1)];
    pdiff =sum(pdiff.^2,2);
    poly(pdiff>5,:) = nan;
    poly = [poly(1:end-1,:);poly(1,:)];
    pdiff = [0 0;diff(poly,1)];
    pdiff =sum(pdiff.^2,2);
    poly(pdiff>5,:) = nan;
    %plot(poly(:,1),poly(:,2))
    %hold on
    x = [x;nan;smooth(poly(:,1),smth,'lowess')];
    y = [y;nan;smooth(poly(:,2),smth,'lowess')];
end
pdiff = [0 0;diff([x y])];
pdiff =sum(pdiff.^2,2);
x(pdiff>5) = nan;
y(pdiff>5) = nan;