function h = fillcirc(x,y,r,anrange,varargin)
hold on
th = anrange(1):pi/50:anrange(2);
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
if anrange(2)-anrange(1)<2*pi
    xunit = [x xunit x];
    yunit = [y yunit y];
    
end
h = fill(xunit, yunit,varargin{:});
hold off
end