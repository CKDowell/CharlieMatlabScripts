function folder = listfolder(datadir,content,folder)
if nargin<2
    content = [];
end
if nargin<3
    folder = {};
end
list = dir(datadir);
for i = 1:length(list)
    name = list(i).name;
    if name(1)=='.'
        continue
    end
    if list(i).isdir
        if isempty(content)
            folder{length(folder)+1} = fullfile(datadir,name);
        end
        folder = listfolder(fullfile(datadir,name),content,folder);
    else
        if strcmp(name,content)
            folder{length(folder)+1} = datadir;
        end
    end
    
end
end