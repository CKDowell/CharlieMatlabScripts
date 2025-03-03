rootdir = 'Y:\Data\FCI\Hedwig\FC2_maimon2';
flist = listfolder(rootdir);
%%
for f = 1:length(flist)
    tdir = flist{f};
    if tdir(end-9:end) =='registered'
        d = dir(fullfile(tdir,'*old.tiff'));
        for i = 1:length(d)
            if i==1
                disp(tdir)
            end
            guimask = tiff2stack(fullfile(tdir,d(i).name));
            figure
            subplot(1,2,1)
            imagesc(guimask(:,:,2))
            guimask(guimask>0) = abs(guimask(guimask>0)-17);
            subplot(1,2,2)
            imagesc(guimask(:,:,2))
            guimask = uint8(guimask);
            sname = d(i).name(1:end-9);
            
            stack2tiff(guimask,tdir,sname)
            
        end
        
        
    end
end