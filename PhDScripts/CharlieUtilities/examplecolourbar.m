function examplecolourbar(ticks,cmap)
figure
colormap(cmap)
c = colorbar;
c.Ticks = linspace(0,1,numel(ticks));
c.TickLabels = ticks;
c.FontSize = 20;
c.TickLength = 0.02;
c.LineWidth = 2;
set(gca,'Visible','off')