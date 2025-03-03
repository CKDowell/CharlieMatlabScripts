function sccheckrois(sm,planeidx)

for z = planeidx+1
    figure
    im = sm.templates{z};
    imagesc(im,[prctile(im(:),5),prctile(im(:),97)])
    colormap('gray')
    hold on
    pos = cat(1,sm.seg(z).STATScrop.Centroid);
    scatter(pos(:,1),pos(:,2),'.','MarkerEdgeColor','r')
end

end