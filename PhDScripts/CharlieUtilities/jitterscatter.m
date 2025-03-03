function jitterscatter(data,normdoffset,plotmean,varargin)
% function plots column data with a normal noise jitter
if isempty(normdoffset)
    normdoffset = 0;
end
x = 1:10:size(data,2)*10;
normd = randn(size(data));
t = abs(normd)>2;
while sum(t(:))>0
normd(abs(normd)>2) = randn(sum(t(:)),1);
t = abs(normd)>2;
end
normd = normd+x;
blah = varargin;
for v = 1:length(varargin)
    if strcmp(blah{v},'MarkerEdgeColor')
        cmemf = v+1;
        break
    end
end

if size(varargin{cmemf},1)>1
    colour = varargin{cmemf};
    for d = 1:size(data,2)
        scatter(normd(:,d)+normdoffset,data(:,d),varargin{1:cmemf-1},colour(d,:),varargin{cmemf+1:end});
        hold on
        if plotmean
            plot([x(d)-1 x(d)+1]+normdoffset,[nanmean(data(:,d)) nanmean(data(:,d))],'Color','k')
        end
    end
    
else
    scatter(normd(:)+normdoffset,data(:),varargin{:});
    hold on
    xes = [x-1;x+1];
    mns = nanmean(data,1);
    if plotmean
        plot(xes,[mns;mns],'Color','k')
    end
    xticks(x)
    hold off
end
end