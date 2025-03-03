function [R2_shuffle,revp] = bootstrapRegression(x,y,R2,repeats)
R2_shuffle = nan(repeats,1);
for j = 1:repeats
   y2 = y(randperm(numel(y)));
   bet2 = x\y2;
   R2_shuffle(j) = R_squared_ihb(y2,x*bet2);
end
revp = revprctile(R2_shuffle,R2);
end