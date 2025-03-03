function prctile = revprctile(data,query,type,dpoints)
% Function returns the percentile of a datapoint from an array. If the
% point is equidistant from two points it choses the lower bound.
%
% Option to choose between fast determination and specific decimal points.
% Difference in computation time is likely to be marginal, unless you are
% iterating this function many times.
%
% Charlie Dowell UCL 17/01/2019
if nargin<3
    type = 'fast';
end
if min(size(data))>1
    type = 'multidim';
else
    if numel(data)<100
        type = 'inter';
    end
end
data = sort(data,'ascend');
difference = abs(data-query);

switch type
    case 'fast'
        [~,I] = min(difference,[],1);
        prctile = 100*I(1)./numel(data); %takes lowest bound
    case 'accurate'
        [~,I] = min(difference,[],1);
        Ilow = max(1,I-1);
        Ihigh = min(I+1,numel(data));
        miniD = data(Ilow:Ihigh);
        dp = 10^dpoints;
        newI = linspace(Ilow,Ihigh,dp);
        expI = interp1(miniD,Ilow:Ihigh,newI);
        difference2 = abs(expI - query);
        [~,I2] = min(difference2);
        I = newI(I2);
        prctile = 100*I(1)./numel(data);
        prctile = round(prctile,dpoints);
    case 'multidim'
        [~,I] = min(difference,[],1);
        prctile = 100*(I./size(data,1));
    case 'inter'
        % interpolates points use when sample size <100
        x = linspace(1,100,numel(data));
        x2 = 1:100;
        data2 = interp1(x,data,x2);
        difference = abs(data2-query);
        [~,I] = min(difference);
        prctile = 100*I(1)./numel(data2);
end
end