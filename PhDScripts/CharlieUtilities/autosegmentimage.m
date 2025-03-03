function segments = autosegmentimage(IM,params)
% Home brew autosegmentation for nuclear localised proteins
% finds maximum point and searches around it
scalef = params.pixels_per_micron; 
dim=[params.FOVy,params.FOVx];


CellMinArea = round(params.cell_min*scalef);
CellMaxArea = round(params.cell_max*scalef); 
CellMaxEccent = .9;
PAlimit = 0.55;
smwindow1 = ceil(5./scalef);
smwindow2 = ceil(10./scalef);
window = ceil(3*scalef);

minvalue= max(floor(window^2*0.2),1); 
maxvalue=floor(window^2*0.8);
filter1=fspecial('gaussian', [smwindow1 smwindow1], smwindow1/2+1);
filter3 = fspecial('gaussian', [smwindow1 smwindow1], smwindow1/4+1)-filter1;
filter2=fspecial('gaussian', [smwindow2 smwindow2], smwindow1/2+1);
allmask=zeros(dim(1),dim(2));
filter4 = fspecial('sobel');
Fxy = IM;
%     Fxy = sm.maximjs{planeidx(z)+1};
%     Fxy = Fxy.*Fxy2;
%     allmask(:)=0;


Fxy = (Fxy-mean(Fxy(:)))./std(Fxy(:));

     
Fxy2 = imfilter(Fxy,filter4);
SmFxy=imfilter(Fxy,filter3);
eqimj = adapthisteq(SmFxy,'Distribution','rayleigh');
mask = SmFxy<0.3;


C = ordfilt2(SmFxy,maxvalue,true(window)); % replace each px with 80th percentile value from neighbours
B = ordfilt2(SmFxy,minvalue,true(window*2)); % replace each px with 20th percentile value from neighbours
Fresc=double((SmFxy-B)./(C-B));% rescale image

Fresc1=Fresc;
R1=find(Fresc<0);
R2=find(Fresc>1);
Fresc1(R1)=0;
Fresc1(R2)=1;
R3=find(isnan(Fresc1));
Fresc1(R3)=0;
if isfield(params,'filter2')
    SmFresc1=Fresc1.*~mask;
    SmFresc1(SmFresc1==0) = inf;
    L = watershed(-1*SmFresc1);
else
    L = watershed(Fresc1);
    segments.L=L;

end
% SmFresc1=imfilter(Fresc1,filter2);%.*~mask;
% SmFresc2=imfilter(Fresc1,filter4);
%Fresc1(Fresc1==0) = inf;

watershedpx=L.*0;
R4=find(L==0);
watershedpx(R4)=1;
segments.watershedpx=watershedpx;

STATS = regionprops(double(L), 'Area','Eccentricity','Centroid');

Area=field2num(STATS,'Area');
Eccent=field2num(STATS,'Eccentricity');
% rois to exclude
excludeIdx=find( Area<CellMinArea| Eccent>CellMaxEccent |Area>CellMaxArea );

segments.STATScrop=[1:length(STATS)]';
segments.excludeIdx=excludeIdx;

STATScrop=STATS;
STATScrop(excludeIdx)=[];
segments.allIdx = [1:size(STATScrop,1)]';
segments.STATScrop=STATScrop;
segments.STATScrop = STATScrop;
disp(['n cells = ' num2str(length(STATScrop))])
%figure('Name',[gm.name ' z = ' num2str(z)])
cnt=field2num(STATScrop,'Centroid');
subplot(1,2,1)
imshow(Fxy,[0 .8*max(Fxy(:))])
hold on
plot(cnt(:,1),cnt(:,2),'r.')
title('zimg, centroids')

subplot(1,2,2)
imshow(imoverlay(Fxy./10,watershedpx,[0 1 0]))
hold on
plot(cnt(:,1),cnt(:,2),'r.')
title('zimg, centroids, watershed px')
end