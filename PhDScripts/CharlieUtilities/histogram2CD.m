function histogram2CD(x,y,binx,biny,plotticks,normalisation,clims,varargin)
h = histcounts2(x,y,binx,biny,'normalization',normalisation);
h = imrotate(h,90);
imagesc(h,clims)
plotbinx = binx(2:end)-mean(diff(binx))./2;
plotbiny = biny(2:end)-mean(diff(biny))./2;
%plotbinx = [plotbinx(1)-mean(diff(binx)) plotbinx plotbinx(end)+mean(diff(binx))];
%plotbiny = [plotbiny(1)-mean(diff(biny)) plotbiny plotbiny(end)+mean(diff(biny))];
%plotticksx = findnearestCD(plotticks(:,1),plotbinx);plotticksy = findnearestCD(plotticks(:,2),plotbiny);
% plotticksx = interpdex(plotticks(:,1),plotbinx)-0.5;
% plotticksy = interpdex(plotticks(:,2),plotbiny)-0.5;
plotticksx = findnearestCD(plotticks(:,1),binx);
mpoint = size(h)./2;
plotticksx(plotticksx>mpoint(2)) = plotticksx(plotticksx>mpoint(2))-1.5;
xticks(plotticksx)
xticklabels(plotticks(:,1))

plotticksy = findnearestCD(plotticks(:,2),binx);
mpoint = size(h)./2;
plotticksy(plotticksy>mpoint(1)) = plotticksy(plotticksy>mpoint(1))-1.5;

yticks(plotticksy)
yticklabels(flipud(plotticks(:,2)));
if nargin>7
    xmid = ceil(numel(plotbinx)./2)-0.5;
    ymid = ceil(numel(plotbiny)./2)-0.5;
    hold on
    plot([xmid xmid],[0 numel(biny)],varargin{:},'LineWidth',2)
    plot([0 numel(binx)],[ymid ymid],varargin{:},'LineWidth',2)
    hold off
end
