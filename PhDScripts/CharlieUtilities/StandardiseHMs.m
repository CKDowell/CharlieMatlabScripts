set(gca,'Box','off')
c1 = colorbar;
g = gca;
ticks = g.Colorbar.Ticks;
if numel(ticks)>5
tickmid = round(numel(ticks)./2);
if numel(g.Colorbar.Ticks)>3
g.Colorbar.Ticks = ticks([1 tickmid end]);
end
end
g.FontSize = 20;
g.XAxis.LineWidth = 2;
g.YAxis.LineWidth = 2;
g.TickDir = 'out';