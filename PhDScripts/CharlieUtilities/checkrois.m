function checkrois(gmranat,gm,zsel)
if nargin==2
    zsel = 1:length(gmranat.z);
end
for z = zsel
    figure
    imagesc(gm.zimg(z).aligngood2_deconv,...
        [prctile(gm.zimg(z).aligngood2_deconv(:),5),prctile(gm.zimg(z).aligngood2_deconv(:),97)])
    colormap('gray')
    hold on
    pos = cat(1,gmranat.z(z).STATScrop.Centroid);
    scatter(pos(:,1),pos(:,2),'.','MarkerEdgeColor','r')
end

end