function blueredcmap = brcmap(range)
range = range+(1-mod(range,2));
x = linspace(0,1,range)';
blueredcmap = flipud([[ones(range-1,1);flipud(x)],[x;flipud(x(1:end-1))],[x;ones(range-1,1)]]);
end