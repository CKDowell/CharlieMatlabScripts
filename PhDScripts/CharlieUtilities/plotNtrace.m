function plotNtrace(trace,xi,yi,varargin)
hold on
for i = 2:size(trace,1)
    x1 = trace(i,xi);
    y1 = trace(i,yi);
    dx = trace(i,7);
    x2 = trace(dx,xi);
    y2 = trace(dx,yi);
    plot([x2 x1],[y2 y1],varargin{:})
    drawnow
end
hold off
end