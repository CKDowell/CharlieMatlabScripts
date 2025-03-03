function get_clustermasksCoords(centroids,scalefactor,savedir,stackname)

centroids(:,1:3) = round(centroids(:,1:3));
refdims = [1030,616,3,420];
thisstack = zeros(refdims(2),refdims(1),refdims(4));
[xgrid,ygrid] = meshgrid(1:refdims(1),1:refdims(2));
roiradius = 2.5;
for z = unique(centroids(:,3))' %edited Paride's script to use matrix operations instead of for loops: may need to change as datasets grow in size
        thiscent = centroids(centroids(:,3)==z,:);
        
    try  
        xgrids = single(repmat(xgrid,1,1,size(thiscent,1)));
        xgrids = permute(xgrids,[3 1 2]);
        ygrids = single(repmat(ygrid,1,1,size(thiscent,1)));
        ygrids = permute(ygrids,[3 1 2]);
        thesemasks = (xgrids - thiscent(:,1)).^2 + (ygrids-thiscent(:,2)).^2 <= roiradius.^2;
        clear xgrids ygrids
        thesemasks = single(thesemasks.*scalefactor);
        thismask = squeeze(sum(thesemasks,1));
        clear thesemasks
        thisstack(:,:,z-5:z+5) = thisstack(:,:,z-5:z+5)+ thismask;%give them some depth
    catch
        disp(['Cell number ' num2str(size(thiscent,1)) ' memory overload'])
        for n = 1:size(thiscent,1)
            tc = thiscent(n,:);
            thismask = (xgrid - tc(1)).^2 + (ygrid-tc(2)).^2 <= roiradius.^2;
            thismask = thismask.*scalefactor(n);
            thisstack(:,:,z-5:z+5) = thisstack(:,:,z-5:z+5)+ thismask;
        end
    end
end
stack2tiff(thisstack,savedir,stackname);
end