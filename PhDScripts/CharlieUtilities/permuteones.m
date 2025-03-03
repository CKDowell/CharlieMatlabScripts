function outarray = permuteones(numones)
outarray = [];
basearray = zeros(1,numones);
for i = 1:numones
    thisarray = basearray;
    thisarray(i) = 1;
    outarray = [outarray;thisarray];
    cnt = 1;
    while sum(thisarray(i:end))<numones-i+1
        for n = i+cnt:numones
            thisarray2 = thisarray;
            thisarray2(n) = 1;
            outarray = [outarray;thisarray2];
        end
        thisarray(i+cnt) = 1;
        cnt = cnt+1;
        
    end
end
end