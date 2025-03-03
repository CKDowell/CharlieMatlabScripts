function consistentResize(g,ga,xlims,ylims)
%CD December 2021
% Changes x and y limits in matlab without resizing actual image size
% means scalebar in one panel can be consistent with another
width = g.InnerPosition(3);
height = g.InnerPosition(4);
XL = ga.XLim;
XR = XL(2)-XL(1);
YL = ga.YLim;
YR = YL(2)-YL(1);
newXR = xlims(2)-xlims(1);
xlim(xlims)
newYR = ylims(2)-ylims(1);
g.InnerPosition(3) = width.*(newXR./XR);
g.InnerPosition(4) = height.*(newYR./YR);
ylim(ylims)
end