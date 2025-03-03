function [data2,dx] = subsampleCD(data1,data2,bins)
% function produces a subsample of data2 based upon ths distribution of
% data1 as defined in its bins

[N1,~,bin1] = histcounts(data1,bins,'Normalization','probability');
[N2,~,bin2] = histcounts(data2,bins);
N1 = N1./max(N1);
N2new = floor(N2.*N1);
N2new(N2new>N2) = N2(N2new>N2); %keep original distribution if it doesn't scale well ammend later perhaps
dx = zeros(size(data2));
for n = 1:numel(N1)
    if N2new(n)==0
        continue
    end
    nd = find(bin2==n);
    nd = nd(randperm(numel(nd),N2new(n)));
    dx(nd) = 1;
end
dx= logical(dx);
data2 = data2(dx);

end