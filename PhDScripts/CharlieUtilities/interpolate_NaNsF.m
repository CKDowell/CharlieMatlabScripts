function dataout = interpolate_NaNsF(datain)

dataout = datain;

datasz = size(datain);

datain = datain(:);

nanix = find(isnan(datain));
nanix = nanix(:)'; % ensure row vector
goodix = find(~isnan(datain));

parfor i = nanix
    
    dL = datain(max(goodix(goodix < i)));
    dH = datain(min(goodix(goodix > i)));
    if isempty(dL) || isempty(dH)
        dataout(i) = 0;
    else
        dataout(i) = nanmean([dL dH]);
    end
end

dataout = reshape(dataout, datasz);