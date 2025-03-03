function gm = getfakegm2(datadir)
disp(['Creating fake gm ' gmname])
datadirparts = strsplit(datadir, filesep);
gm.name = [datadirparts{end-1} '_' datadirparts{end}];
mdir = fullfile(datadir,'m');
fid = fopen([datadir filesep 'm' filesep '00_readme.txt'], 'r');
Ctxt = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
gm.frtime
gm.trfr
gm.name = gmname;
d = dir([datadir filesep 'm']);
filename = ['m\' d(3).name];
Iinfo = imfinfo([datadir '\' filename]);
Zrange = 1:size(Iinfo,1);
for z = Zrange
    disp(num2str(z))
    gm.zimg(z).aligngood2_deconv = double(imread([datadir '\' filename],z));
    
end
clc
gm.zrange = Zrange;
gm.xpx = size(gm.zimg(1).aligngood2_deconv,2);
gm.ypx = size(gm.zimg(1).aligngood2_deconv,1);
load([datadir filesep 'gmb.mat'])
gm.frtime = gmb.frtime;
if opto
    load([datadir filesep 'gmbt.mat'])
    gm.nfr = max(gmbt.p(1).tt)./(gm.frtime./1000);
    gm.visstim = zeros(length(gmb.p),6);
else
    gm.nfr = length(gmb.p(1).resampled);
    gm.visstim = cat(1,gmb.p.visstim);
end
gm.trfr = gmb.trfr;
gm.ScanType = 'Q1';
disp('Saving...')
save([datadir '\' 'gmfake.mat'],'gm','-v7.3')
disp('Saved')
end