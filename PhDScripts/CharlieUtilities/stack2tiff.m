function stack2tiff(stack,datadir,stackname)
filename = fullfile(datadir,[stackname '.tiff']);
imwrite(stack(:,:,1),filename,'Compression','lzw')
    for g = 2:size(stack,3)
        imwrite(stack(:,:,g),filename,'Writemode','append','Compression','lzw') 
    end
    disp('Done')
end