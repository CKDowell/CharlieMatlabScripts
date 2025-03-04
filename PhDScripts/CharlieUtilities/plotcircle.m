function h = plotcircle(x,y,r,varargin)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,varargin{:});
hold off
end