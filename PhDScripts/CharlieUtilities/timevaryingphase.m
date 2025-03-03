function [Cxy,F,Mxy,t] = timevaryingphase(x,y,window,noverlap,fs,wantcoh,ppool)
if nargin<7
    ppool = false;
end
% function performs time varying cpsd and mscohere
    numsamps = (numel(x))./(window-noverlap);
    numsamps = ceil(numsamps);
    jumps= window-noverlap;
    if numsamps ==1;
        sts = 1;
        stse = numel(x);
    else
        sts = 1:jumps:(numsamps-1)*jumps;
        stse = sts+window-1;
        if stse(end)>numel(x)|(numel(x)-sts(end))>8
            stse(stse>numel(x)) = numel(x);
        elseif stse(end)>numel(x)|(numel(x)-sts(end))<8
            stse(end) = [];sts(end) = [];
            stse(end) = numel(x);
        end
    end
    t= (1./fs).*((sts+stse)./2);
    Cxy = nan(129,numel(sts));
    
    Mxy = Cxy;
    dx = 1:window;
    if ppool
        parfor i = 1:numel(sts)
            dx = sts(i):stse(i);
    %         if numel(dx)<9
    %             break
    %         end
            try
            [Cxy(:,i)] = cpsd(x(dx),y(dx),[],[],[],fs);
            catch
                keyboard
            end
            if wantcoh
               Mxy(:,i) =  mscohere(x(dx),y(dx),[],[],[],fs);
            end
        end
    else
        for i = 1:numel(sts)
            dx = sts(i):stse(i);
    %         if numel(dx)<9
    %             break
    %         end
            try
            [Cxy(:,i)] = cpsd(x(dx),y(dx),[],[],[],fs);
            catch
                keyboard
            end
            if wantcoh
               Mxy(:,i) =  mscohere(x(dx),y(dx),[],[],[],fs);
            end
        end

    end
    dx = sts(1):stse(1);
    [~,F] = cpsd(x(dx),y(dx),[],[],[],fs);
end