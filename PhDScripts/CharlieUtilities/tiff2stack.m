function IM = tiff2stack(tiffdir)
warning('off')
info_ref = imfinfo(tiffdir);
TifLink = Tiff(tiffdir, 'r');
no_planes = length(info_ref);
IM = [];
if no_planes>1
    for z = 1:no_planes
        TifLink.setDirectory(z);
        IM(:,:,z) = TifLink.read();
    end
else
    IM = TifLink.read();
end
warning('on')
end
