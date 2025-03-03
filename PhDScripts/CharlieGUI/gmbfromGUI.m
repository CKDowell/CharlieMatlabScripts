function [g,g2] = gmbfromGUI(trial,start,gmb,datatype)
i = trial;
ti = 0.01;
frt = gmb.frtime;
nfr = size(gmb.p(1).resampled,1);
timebase = [0:ti:nfr*frt./1000-ti]';
Lall = cat(1,gmb.p(:).Langles);
Lmed = median(Lall);
Rall = cat(1,gmb.p(:).Rangles);
Rmed = median(Rall);
thisL = interp1([gmb.p(i).tt' gmb.p(i).tt(end)+[0.01:0.01:0.5]], [gmb.p(i).Langles' repmat(gmb.p(i).Langles(end),1,50)],timebase);
thisR = interp1([gmb.p(i).tt' gmb.p(i).tt(end)+[0.01:0.01:0.5]], [gmb.p(i).Rangles' repmat(gmb.p(i).Rangles(end),1,50)],timebase);
thisL = removenans(thisL);
thisR = removenans(thisR);
thisL = speciallowess(thisL,[10,0.5,0.15,5,0.3]);
thisR = speciallowess(thisR,[10,0.5,0.15,5,0.3]);

Verg = thisL-thisR;
startdex = findnearest(start,timebase);
predex = findnearest(start-0.200,timebase);
postdex = findnearest(start+0.200,timebase);


switch datatype
    case 'Convergences'
        PostVerg = max(Verg(startdex:postdex)); 
        postdex2 = find(Verg==PostVerg);
        PreVerg = min(Verg(predex:startdex));
        predex2 = find(Verg==PreVerg);
        g = [i,start,1,1,PreVerg,PostVerg,thisL(predex2)...
            ,thisL(postdex2),thisR(predex2),thisR(postdex2)];
        g2 = [];
    case 'Left Conj'
        thisL = thisL-Lmed; %Only median subtract conjs. May want to change gmb orginal to median subtract convs
        thisR = thisR-Rmed;
        postL = min(thisL(predex:postdex));
        preL = max(thisL(predex:postdex));
        g = [i,start,preL,postL,postL-thisL(predex),startdex];
        postR = min(thisR(predex:postdex));
        preR = max(thisR(predex:postdex));
        g2 = [i,start,thisR(predex),postR,postR-thisR(predex),startdex];
    case 'Right Conj'
        thisL = thisL-Lmed;
        thisR = thisR-Rmed;
        postL = max(thisL(predex:postdex));
        preL = min(thisL(predex:postdex));
        g = [i,start,preL,postL,postL-thisL(predex),startdex];
        postR = max(thisR(predex:postdex));
        preR = min(thisR(predex:postdex));
        g2 = [i,start,thisR(predex),postR,postR-thisR(predex),startdex];
end
        
end

function data = removenans(data)
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