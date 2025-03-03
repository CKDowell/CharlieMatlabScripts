function [imout,alphaout] = charlieIMfuse(im1,im2,minalpha,colourmap)
    if nargin<3
        minalpha = 0;
    end
    if nargin<4
        colourmap = customcolormap([0 0.25 0.5 0.75 1],[0 1 0;0.2 1 0.2; 1 1 1; 1 0.2 1;1 0 1],51);
    end
    
    imscale = im1-im2;
    imscale(im1==0&im2==0) = nan;
    imscale = rescale(imscale,1,51);
    imscale = round(imscale);
    
    imdims = size(im1);
    [i,j] = find(~isnan(imscale));
    imout = zeros(imdims(1),imdims(2),3);
    
    ic = colourmap(imscale(~isnan(imscale)),:);
    for r = 1:3
        I = sub2ind(size(imout),i,j,ones(size(i)).*r);
        imout(I) = ic(:,r);
    end
    
    alphaout = im1+im2;
    alphaout(alphaout>0) = rescale(alphaout(alphaout>0),minalpha,1);
end