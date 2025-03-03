function colour = tricolourwheel(x,y,whitemin,colours)
an = angle(x+i*y);

cspc = linspace(0,1,size(colours,1));

cdx = linspace(0,pi./2,101);
cmap = customcolormap(cspc,colours,101);
basecolour = cmap(findnearestCD(an,cdx),:);
whiten = abs(x+i*y);
whitedex = linspace(0,1,101);
whitedex2 = linspace(0,whitemin,101);
whitedex2 = fliplr(whitedex2);
w = whitedex(findnearestCD(whiten,whitedex2));
colour = min(basecolour+w',1);
end