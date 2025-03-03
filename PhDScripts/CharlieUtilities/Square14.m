g = gca;
xscale = g.XLim(2)-g.XLim(1);
yscale = g.YLim(2)-g.YLim(1);
scdiff = xscale-yscale;
if scdiff>0
    g.YLim(1) = g.YLim(1)-scdiff./2;
    g.YLim(2) = g.YLim(2)+scdiff./2;
elseif scdiff<0
    g.XLim(1) = g.XLim(1)+scdiff./2;
    g.XLim(2) = g.XLim(2)-scdiff./2;
end
g.Units = 'centimeters';
set(gcf,'Position',[846 326 788 592]);
g.Position(3:4)= 14;