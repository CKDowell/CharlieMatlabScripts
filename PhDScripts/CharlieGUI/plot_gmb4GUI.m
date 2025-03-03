function plot_gmb4GUI(p,currentdata,gmb,toggle,gmbt,tstd,isdel)
if nargin==6
    isdel = false;
end
ti = 0.01;
frt = gmb.frtime;
nfr = size(gmb.p(1).resampled,1);
timebase = [0:ti:nfr*frt./1000-ti]';
if numel(timebase)<10
    timebase = [0:ti:nfr*frt-ti]';
end
if numel(size(currentdata))==3
    currentdata = squeeze(mean(currentdata,3));
end
i = currentdata(p,1);
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
if strcmp(toggle,'Conj')
    timepos = 2;
elseif strcmp(toggle,'Conv')
    timepos = 2;
end
visstim = gmb.p(i).visstim;
stimon = (gmb.frtime./1000)*gmb.trfr;
stimoff = visstim(6)+stimon;
plot([stimon stimoff],[0 0],'LineWidth',4,'Color',[0.2 1 0.2])
hold on

if ~isdel&currentdata(p,timepos)>0;
    plot(gmbt.p(i).tt,gmbt.p(i).cumtail./tstd,'Color','k') 
    hold on    
    plot(timebase,thisL,'Color','b')
    plot(timebase,thisR,'Color','r')
else isdel|currentdata(p,timepos)==0;
    plot(gmbt.p(i).tt,gmbt.p(i).cumtail./tstd,'Color',[0.3 0.3 0.3]) 
    hold on
    plot(timebase,thisL,'Color',[0.5 0.5 1])
    plot(timebase,thisR,'Color',[1 0.5 0.5])
end


if currentdata(p,timepos)>0
    onset = currentdata(p,timepos);
    posonset = findnearest(onset,timebase);
    LeyeO = thisL(posonset);
    ReyeO = thisR(posonset);
    scatter(timebase(posonset),LeyeO,200,'.','MarkerEdgeColor','k')
    scatter(timebase(posonset),ReyeO,200,'.','MarkerEdgeColor','k')
end
hold off
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