function [EA_n] = EviAcc2CD(Idx_set)
%
% same as normal function, but outputs a linear form matrix
%%
% Generates evidence accumulation matrix that can be used for concensus
% clustering.
% Previous script EviAcc has been divided into EviAcc2 and ConsClust2
% Together, they perform consensus clustering based on evidence accumulation, in
% accordance with process proposed by Fred ALN and Jain AK, 2005.
% Voting mechanism is based on frequency with which pairs of observations
% are assigned to the same cluster. Agglomerative hierarchical clustering
% is then applied to the resulting EA matrix.
%
% INPUTS:
% Idx: n x r matrix. <double> Cluster assignments for n observations over r clusterings.
%
% OUTPUTS
% EA: Evidence accumulation matrix


%%

Idx = Idx_set; % some rebranding
clear Idx_set
nrunz = size(Idx, 2);
nsamples = size(Idx, 1);
h = waitbar(0, 'EviAcc...');

I = 1:nsamples;
I2 = I;
I = nsamples-I(1:end-1);
I = cumsum(I);
I = [0 I];






sz = (nsamples*(nsamples-1))./2;


EA_n = zeros(sz,1,'single');
nmat = zeros(sz,1,'uint8');
%EA = zeros(sz,1,'uint16');






for r = 1:nrunz
    waitbar(r/nrunz, h, 'Evidence Accumulation ...');
    tidx = Idx(:,r);
    clidz = unique(tidx);
    clidz(clidz==0) = [];
    clidz(isnan(clidz)) = [];
    for c = clidz(:)'
        ixx = find(tidx==c);
        
        
        
        for i = ixx(:)'
            if i==1
                continue
            end
            tdx = ixx(ixx<i);
            tdx2 = I(tdx)+(i-I2(tdx));
            EA_n(tdx2) = EA_n(tdx2)+1;% for increased memory capacity can make EA_n and nmat linear
            %EA_n(i, ixx) = EA_n(i, ixx) + 1;
        end
    end
    washere = find( ~isnan(tidx) ); % all observations in this clustering
    for i = washere(:)'
        if i==1
            continue
        end
        tdx = washere(washere<i);
        tdx2 = I(tdx)+(i-I2(tdx));
        nmat(tdx2) = nmat(tdx2) + 1;
    end
end






% need to do a bit part divide to save memory

for i = 1:numel(EA_n)
    td = EA_n(i);
    if mod(i,100000000)==0
        disp(num2str(i))
    end
    if td>0
        te = 1-double(td)./double(nmat(i));
        EA_n(i) =single(te);
    end
end

clear nmat

close(h);

  