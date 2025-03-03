function g = standardiseLinePlots(g,xtnum,ytnum,zerocondx,zerocondy)
xt = g.XTick;

newx = linspace(xt(1),xt(end),xtnum);
if zerocondx
    [~,I] =min(abs(newx));
    newx = newx-newx(I);    
end
g.XTick = newx;

yt = g.YTick; 
newy = linspace(yt(1),yt(end),ytnum);
if zerocondy
    [~,I] =min(abs(newy));
    newy = newy-newy(I);       
end
g.YTick = newy;

g.Box ='off';
g.FontSize = 15;
g.XAxis.LineWidth = 2;
if length(g.YAxis)>1
    yt = g.YAxis(2).TickValues; 
    newy = linspace(yt(1),yt(end),ytnum);
    if zerocondy
        [~,I] =min(abs(newy));
        newy = newy-newy(I);       
    end
    g.YAxis(2).TickValues = newy;
    
    g.YAxis(1).LineWidth = 2;
    g.YAxis(2).LineWidth = 2;
    g.YAxis(1).Color = [0 0 0];
    g.YAxis(2).Color = [0 0 0];
else
    g.YAxis.LineWidth = 2;
end
g.TickDir = 'out';
end