function y = speciallowess3(data,params)
% Function is a new special lowess. It conducts lowess twice: once with a
% wide window and another time with a narrow window. Instances of large
% change in the data are replaced with the narrow window lowess to preserve
% the temporal dynamics. This should enable good read out of the velocity
% of noisy signals for example.

% params(1): wide window
% params(2): narrow window (half size?)
% params(3): delta threshold
% params(4): annealing window
% params(5): conv window thresh (good to be the same as the lowess window)
% params(6): optional tau control for taper strength
% eg params: [10,5,0.5,50,10]
% CDowell 10/01/2019
ck = [-1,1];
if nargin<2
    params = [10,5,0.2,50,10,2];
end
if size(data,2)>1
    data = data';
end
cn = [ones(floor(params(5)./2),1);ones(ceil(params(5)./2),1)*-1];
data2 = [repmat(data(1),50,1);data;repmat(data(end),50,1)]; %need to pad
y = smooth(data2,params(1),'lowess');
y = y(51:length(data)+50);
yo = y; 
if params(2)==0
    y2 = data;
else
    y2 = smooth(data,params(2),'lowess');
end
dy = conv(y2,cn,'same');
dyind = double(abs(dy)>params(3));
%dyind = double(dy>params(3));
dyind(dyind==0) = -1;
edges = conv(dyind,ck,'same');
onset = find(edges<0);
offset = find(edges>0);
srchdistance = params(4);
if numel(params)>5
    tau = srchdistance./params(6);
else
    tau = srchdistance./2;
end
t = 0:srchdistance;
srchweights = 1-exp(-t./tau)';

% srchweights = ones(srchdistance+1,1);
% srchweights(1:round(srchdistance*0.5)) = linspace(0,1,round(srchdistance*0.5)); % want to taper in faster
srchweightsb = flipud(srchweights);
if numel(onset)<numel(offset)
    onset = [1;onset];
elseif numel(offset)<numel(onset)
    offset = [offset;numel(y)];
end
set = [onset,offset];
for i = 1:size(set,1)
    thison = set(i,1);
    thisoff = set(i,1);
    y([thison thisoff]) = y2([thison thisoff]);
    thison2 = max(1,thison-srchdistance);
    thisoff2 = min(numel(y),thisoff+srchdistance);
    weightdexOn = 1:(thison-thison2+1);
    weightdexOff = 1:(thisoff2-thisoff+1);
    y([thison2:thison]) = y2([thison2:thison]).*srchweights(weightdexOn) ...
        + y([thison2:thison]).*(1-srchweights(weightdexOn));
    y([thisoff:thisoff2]) = y2([thisoff:thisoff2]).*srchweightsb(weightdexOff)...
        + y([thisoff:thisoff2]).*(1-srchweightsb(weightdexOff));
end


% figure
% plot(data,'Color','k')
% hold on
% plot(yo,'Color','b')
% plot(y2,'Color',[0.3 0.3 0.3])
% plot(y,'Color','r')
% 
% keyboard
end