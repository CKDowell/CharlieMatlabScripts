function segments = autosegmentvolume(stack,params)
% Home brew volume segmentation
% Plan is to find maxima then search along spheres and stop searching once
% threshold is breached or the delta is large.
disp('Preparing data')
radius = params.radius;
radius2 = 3;
minthresh = params.minthresh;

segments = zeros(size(stack));
stack(stack<minthresh) = 0; %threshold image
[dx,dy,dz] =gradient(stack);
stacksize = size(stack);
segid = 1;
[ygrid,xgrid,zgrid] = ndgrid(1:size(stack,1),1:size(stack,2),1:size(stack,3));
coords = [ygrid(:) xgrid(:) zgrid(:)];
Ismaster = sub2ind(size(stack),coords(:,1),coords(:,2),coords(:,3));
clear xgrid ygrid zgrid
while sum(stack(:))>0
    disp(['Doing Segment ' num2str(segid)])
    [mx,mxi] = max(stack(:));
    [mxi,mxj,mxk] = ind2sub(size(stack),mxi);
    %dpos = sqrt(sum((coords - [mxi,mxj,mxk]).^2,2));
    %spheredex = find(dpos<radius);
    [Is,dpos] = quickradius(radius,mxi,mxj,mxk,stacksize);
    spheredex = find(ismember(Ismaster,Is));
    %Is = Ismaster(spheredex);
    thissec = stack(Is);
    thisdx = dx(Is);
    thisdy = dy(Is); 
    thisdz =dz(Is);
    smallgrad = thisdx<0.0001&thisdy<0.0001&thisdz<0.0001;
    isdex = find(~smallgrad&thissec>0);
    thisIs = Is(isdex);
    if ~isempty(thisIs)
        segments(thisIs) = segid;
        segments(mxi,mxj,mxk) = segid;
        stack(thisIs) =0;
        stack(mxi,mxj,mxk) = 0;
        perimeter = dpos(isdex);
        pdex = isdex(perimeter>(radius-1));
        Isp = Is(pdex);
        while ~isempty(Isp) %second search around perimeter
            disp(num2str(numel(Isp)))
            thisIsp = Isp(1);
            Isp(1) =[];
            [i,j,k] = ind2sub(size(stack),thisIsp);
%             dpos = sqrt(sum((coords - [i,j,k]).^2,2)); % Cut this down with fast radius
%             spheredex = find(dpos<radius);         
%             Is = Ismaster(spheredex);
            spheredex = find(ismember(Ismaster,Is));
            Is = quickradius(radius2,i,j,k,stacksize);
            Isp(ismember(Isp,Is)) = []; % will massively speed up process
            thissec = stack(Is);
            thisdx = dx(Is);
            thisdy = dy(Is); 
            thisdz =dz(Is);
            smallgrad = thisdx<0.0001&thisdy<0.0001&thisdz<0.0001;
            isdex = find(~smallgrad&thissec>0);
            thisIs = Is(isdex);
            if ~isempty(thisIs)
                segments(thisIs) = segid;
                segments(i,j,k) = segid;
                stack(thisIs) =0;
                stack(i,j,k) = 0;
                perimeter = dpos(isdex);
                pdex = isdex(perimeter>radius2-1);
                Isp =unique([Isp;Is(pdex)]);
            end
        end
        
        
    else
        segid = segid+1;
    end
    
end

end

function [Is,dpos] = quickradius(radius,i,j,k,stacksize)
% will hopefull speed up slow radius calculation
boxdex = [i-radius:i+radius;j-radius:j+radius;k-radius:k+radius]';
boxmin = sum(boxdex<1,2)>0;
boxmax = boxdex(:,1)>stacksize(1)|boxdex(:,2)>stacksize(2)|boxdex(:,2)>stacksize(2);
boxdex = boxdex(~boxmin&~boxmax,:);
[ygrid,xgrid,zgrid] = ndgrid(boxdex(:,1),boxdex(:,2),boxdex(:,3));
coords = [ygrid(:) xgrid(:) zgrid(:)];
dpos = sqrt(sum((coords - [i,j,k]).^2,2)); % Cut this down with fast radius
spheredex = dpos<radius;
dpos = dpos(spheredex);
Is = sub2ind(stacksize,coords(spheredex,1),coords(spheredex,2),coords(spheredex,3));
end


























