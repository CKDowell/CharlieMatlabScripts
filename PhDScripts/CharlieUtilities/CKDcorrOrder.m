function neworder = CKDcorrOrder(data)
%% Function Description
% Reorders data by grouping with correlation distance. Algorithm works as
% follows. 
% 1. Most highly correlated data points are paired together, and removed from
% consideration. Most highly correlated datapoints from remainder are paired in
% the same manner until all data are paired. Remainder datapoint is paired 
% to a nan value if present.
% 2. Pairs of data points are then paired in a similar manner to above. This
% is done by finding the datapoint outside of a pair that is maximally correlated
% to a member of the pair. Pairs in this instance can be considered
% clusters, which are stored as columns in the data structure.
% 3. Step 2 is iterated until there are two clusters that are then concatenated 
% together. Pairing order is preserved in the data so that the order retains
% its correlational structure.
% Charlie Dowell UCL 2021
%% Initial pairing
disp('Initialising Pairs')
C = corr(data');
C = triu(C);
I = logical(eye(size(C)));
C(I) = 0;
pairs = [];
Co = C;
unpaired = 1:size(C,1);
while sum(C(:))>0|~isempty(unpaired)
    if numel(unpaired)==1
        pairs = [pairs,[unpaired;nan]];
        unpaired = [];
        break
    elseif numel(unpaired)==2
        pairs = [pairs,unpaired'];
        unpaired = [];
        break
    end
    [~,strt] = max(C(:));
    [i,j] = ind2sub(size(C),strt);
    pairs = [pairs,[i;j]];
    C([i,j],:) = 0;
    C(:,[i,j]) = 0;
    unpaired(ismember(unpaired,[i,j])) = [];
    disp(num2str(numel(unpaired)))
end
pairsO = pairs;
%% Now take pairs and match iteratively
clc
disp('Grouping Pairs')
pairs = pairsO;
pairs2 = [];
C = corr(data');
C(I) = 0;
maxiter = size(pairs,2)+10;
iter1 = 0;
breaker = 1;
while breaker==1
    iter1 = iter1+1;
    disp(num2str(iter1))
    if iter1>maxiter
        disp('Too many iterations: nonsense output')
        break
    end
    iter2 = 1;
    while ~isempty(pairs)
        iter2 = iter2+1;
        if size(pairs,2)==1
            pairs2 = [pairs2,[pairs(:,1);nan(size(pairs,1),1)]];
            pairs = [];
            break
        elseif size(pairs,2)==2
            pairs2 = [pairs2,pairs(:)];
            pairs = [];
            break
        end
        strt = pairs(:,1);
        strtdx = strt(~isnan(strt));
        slice = C(strtdx,:);
        dx =[strt(:);pairs2(:)];
        dx(isnan(dx)) = [];
        slice(:,dx) = 0;
        [~,i] = max(slice(:));
        [i,j] = ind2sub(size(slice),i);
        partner = find(pairs==j);
        [~,partner] = ind2sub(size(pairs),partner);
        try
        pairs2 = [pairs2,[strt;pairs(:,partner)]];
        catch
            keyboard
        end
        pairs(:,[1 partner]) = [];
    end
    pairs = pairs2;
    pairs2 = [];
    if size(pairs,2)==2
        pairs = pairs(:);
        breaker = 0;
    elseif size(pairs,1)==1
        breaker = 0;  
    end
end
clc
disp('Grouped')
%% Remove nans from pairs to give new order
neworder = pairs(~isnan(pairs));

disp('Done')


end