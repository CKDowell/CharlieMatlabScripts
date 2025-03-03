function Idx = reorderIdx(Idx)
Idxnew = zeros(size(Idx));
[c,I] = uniquecount(Idx);
c = c(I>0);
I = I(I>0);
[~,id] = sort(c,'descend');
I = I(id);
for i = 1:numel(I)
    Idxnew(Idx==I(i)) = i;
end

Idx = Idxnew;
end
