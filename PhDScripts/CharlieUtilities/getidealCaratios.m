function ratmatrix = getidealCaratios(ton,toff,increments)
blocks = nan(size(increments,1),1);
ratmatrix = nan(size(blocks,1),size(blocks,1)-1);
for i = 1:size(increments,1)
    t0 = increments(i,1);
    t1 =increments(i,2);
    b1 = -ton*exp(-t0./ton)+((ton*toff)./(ton+toff))*exp(-(ton+toff)*t0./(ton*toff));
    b2 = -ton*exp(-t1./ton)+((ton*toff)./(ton+toff))*exp(-(ton+toff)*t1./(ton*toff));
    blocks(i) = b2-b1;
end
for i = 1:size(ratmatrix,2)
    ratmatrix(:,i) = blocks./circshift(blocks,i);
end
end

