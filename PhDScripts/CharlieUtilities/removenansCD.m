function data = removenansCD(data)
if sum(isnan(data))>0
        nannies = find(isnan(data));
        notnan = find(~isnan(data));
        nannies2 = [nannies-1,nannies+2];
        for n = 1:numel(nannies)
        shoot = 0;
        if nannies2(n,1)<1
            shoot =-1;
        elseif nannies2(n,2)>numel(data)
            shoot = 1;
        else 
            thisrep = data(nannies2(n,1):nannies2(n,2));
            while sum(isnan(thisrep))>0
                nannies2(n,1) = nannies2(n,1)-1;
                nannies2(n,2) = nannies2(n,2)+1;
                if nannies2(n,1)<1
                    shoot = -1;
                    break
                elseif nannies2(n,2)>numel(data)
                    shoot = +1;
                    break
                else
                    thisrep = data(nannies2(n,1):nannies2(n,2));
                end
            end
        end
        if shoot==0
            data(nannies(n)) = mean(thisrep);
        elseif shoot ==-1
            data(nannies(n)) = data(notnan(1));
        elseif shoot == 1
            data(nannies(n)) = data(notnan(end));
        end
        
        end
else
    return
end
end