function endmask = CDsegment(IM,params)
% Threshold based segmentation aglorithm. 
% Image contrast is enhanced to pick out cells. This is thresholded and
% maximum values are used as starting points for a circular random search
% for boundaries. 
% Parameters define the scale of the image and desired cell sizes. 

scalef = params.pixels_per_micron; 
dim=[params.FOVy,params.FOVx];


CellMinArea = round(params.cell_min*scalef);
CellMaxArea = round(params.cell_max*scalef); 
CellMaxEccent = .9;
PAlimit = 0.55;
smwindow1 = ceil(5./scalef);
smwindow2 = ceil(10./scalef);
window = ceil(3*scalef);


filter1=fspecial('gaussian', [smwindow1 smwindow1], smwindow1/2+1);
filter3 = fspecial('gaussian', [smwindow1 smwindow1], smwindow1/4+1)-filter1;


Fxy = IM;
%     Fxy = sm.maximjs{planeidx(z)+1};
%     Fxy = Fxy.*Fxy2;
%     allmask(:)=0;


Fxy = (Fxy-mean(Fxy(:)))./std(Fxy(:));

     
SmFxy=imfilter(Fxy,filter3);
eqimj = adapthisteq(SmFxy,'Distribution','rayleigh');
diffim = [zeros(1,size(eqimj,2));abs(diff(eqimj))] +  [zeros(size(eqimj,1),1),abs(diff(eqimj'))'];
eqimj = eqimj+diffim;
eqimj(eqimj<0.1) = 0;
[xgrid,ygrid] = meshgrid(1:dim(2),1:dim(1));
roiradius = sqrt(CellMaxArea./pi)+10;
blankmask = zeros(size(IM));
endmask = blankmask;
counter = 1;
% Iterative search around peaks

while nansum(eqimj(:))~=0    
tm = blankmask;
[mpoint,mdx] = max(eqimj(:));
tm(mdx) = 1;
[I,J] = ind2sub(size(IM),mdx);
n =0;
tI = I;
tJ = J;
thismask = (xgrid - J).^2 + (ygrid-I).^2 <= roiradius.^2;
[IL,JL] = find(thismask);
keepdexes = [I,J];
while n==0
    altoi = randi(3,1)-2;
    altoj = randi(3,1)-2;
    tI = tI+altoi;
    tJ = tJ+altoj;
    if ~ismember([tI,tJ],[IL,JL],'rows') 
        acc= acc+1;
        if acc>500
            n=1;
        end
        continue
    end  
    thispoint = eqimj(tI,tJ);
    acc = 0;
    if thispoint>0
        tm(tI,tJ) = 1;
        keepdexes = [keepdexes;[tI,tJ]];
    else
        randidx = randi(size(keepdexes,1),1);
        tI = keepdexes(randidx,1);
        tJ = keepdexes(randidx,2); 
    end
    
    remdex = ismember([tI,tJ],[IL,JL],'rows');
    IL(remdex) = []; JL(remdex) = [];
    if isempty(IL)
        n=1;
    end    
end
eqimj = eqimj.*~(logical(tm));
if sum(tm(:))<CellMinArea
    continue
end
tm = tm*counter;
endmask = endmask+tm;
counter = counter+1;
imagesc(endmask)
keyboard
end

end


