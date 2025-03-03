function dataout = interpolate_NaNsedit(datain)

dataout = datain;

datasz = size(datain);

datain = datain(:);

nanix = find(isnan(datain));
nanix = nanix(:)'; % ensure row vector
goodix = find(~isnan(datain));

for i = nanix
    dL = datain(max(goodix(goodix < i)));
    dH = datain(min(goodix(goodix > i)));
    if isempty(dL) & ~isempty(dH)
        dataout(i) = dH;
    elseif isempty(dH)& ~isempty(dL)
        dataout(i) = dL;
    elseif ~isempty(dH)&~isempty(dL)
        dataout(i) = nanmean([dL dH]);
    else
        dataout(i) = 0;
    end
end

dataout = reshape(dataout, datasz);
