function y = specialsmooth(data,type,params)
% Function is an addition to lowess that does not reduce the slope of large
% amplitude changes:
% params:
% 1: lowess window
% 2-4: start threshold, increment and end threshold
% 5: weight for original data.

% Addition to lowess works by differentiating the smoothed data and finding
% points above the start threshold. These points are then replaced by a
% weighted average of the smoothed vs orignal data. The function runs
% through the for loop steadily raising the threshold and weigting the
% points that have higher diffs more by the original data, therefore
% keeping large amplitude slopes more faithful to the original data, whilst
% sparing noise smoothing. 

% eg params: [10,0.5,0.15,5,0.3]
% CDowell 23/10/2018
if nargin<2
    params = [10,0.5,0.15,5,0.3];
end
y = smoothts(data,type,params(1));
dy = diff(y);


for i = params(2):params(3):params(4)
    dyind = abs(dy)>i;
    y(dyind) = data(dyind)*params(5) + y(dyind)*(1-params(5));%weight original data over new data.
end
end