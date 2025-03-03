function files = listfiles(datadir,type,files)
if nargin<3
    files = {};
end
list = dir(datadir);
for i = 1:length(list)
    name = list(i).name;
    if name(1)=='.'
        continue
    end
    if list(i).isdir
        files = listfiles(fullfile(datadir,name),type,files);
    else
        namedot = find(name=='.');
        nametype = name(namedot(end)+1:end);
        
        if strcmp(nametype,type)
            files{length(files)+1} = fullfile(datadir,name);
        else 
            continue
        end

    end
    
end
end