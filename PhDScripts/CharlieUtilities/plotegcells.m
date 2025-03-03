datadir = 'S:\DBIO_Bianco_Lab2\CHARLIE\Data\2P FCI\GCaMP_HindBrain\190115\f1';
load([datadir filesep 'gmROIts.mat'])
figure(4)
ptile = 99.99;
cell_1 = 896;
offset = 100;
colour = distinguishable_colors(15);
colour(4,:) =[];
x = 1:length(gmROIts.z(1).roi_tsz(:,cell_1));
fl = speciallowess3(gmROIts.z(1).roi_tsz(:,cell_1));
i = 1;
plot(offset+fl./prctile(fl,ptile),'LineWidth',2,'Color',colour(i,:))
hold on
spks = offset+0.5*gmROIts.z(1).roi_oasis_s(gmROIts.z(1).roi_oasis_s(:,cell_1)>0,cell_1)./max(gmROIts.z(1).roi_oasis_s(:,cell_1));
plot([x(gmROIts.z(1).roi_oasis_s(:,cell_1)>0);x(gmROIts.z(1).roi_oasis_s(:,cell_1)>0)],...
    [spks';ones(size(spks'))*offset],'LineWidth',2,'Color','k')
cell_2 = 1884;
ofincr = 0.6;
offset = offset-ofincr;
fl = speciallowess3(gmROIts.z(1).roi_tsz(:,cell_2));
i = i+1;
plot(offset+fl./prctile(fl,ptile),'LineWidth',2,'Color',colour(i,:))
hold on
spks = offset+0.5*gmROIts.z(1).roi_oasis_s(gmROIts.z(1).roi_oasis_s(:,cell_2)>0,cell_2)./max(gmROIts.z(1).roi_oasis_s(:,cell_2));
plot([x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0);x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0)],...
    [spks';ones(size(spks'))*offset],'LineWidth',2,'Color','k')
cell_2 = 1128;
offset = offset-ofincr;
fl = speciallowess3(gmROIts.z(1).roi_tsz(:,cell_2));
i = i+1;
plot(offset+fl./prctile(fl,ptile),'LineWidth',2,'Color',colour(i,:))
hold on
spks = offset+0.5*gmROIts.z(1).roi_oasis_s(gmROIts.z(1).roi_oasis_s(:,cell_2)>0,cell_2)./max(gmROIts.z(1).roi_oasis_s(:,cell_2));
plot([x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0);x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0)],...
    [spks';ones(size(spks'))*offset],'LineWidth',2,'Color','k')

cell_2 = 416;
offset = offset-ofincr;
fl = speciallowess3(gmROIts.z(1).roi_tsz(:,cell_2));
i = i+1;
plot(offset+fl./prctile(fl,ptile),'LineWidth',2,'Color',colour(i,:))
hold on
spks = offset+0.5*gmROIts.z(1).roi_oasis_s(gmROIts.z(1).roi_oasis_s(:,cell_2)>0,cell_2)./max(gmROIts.z(1).roi_oasis_s(:,cell_2));
plot([x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0);x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0)],...
    [spks';ones(size(spks'))*offset],'LineWidth',2,'Color','k')

cell_2 = 977;
offset = offset-ofincr;
fl = speciallowess3(gmROIts.z(1).roi_tsz(:,cell_2));
i = i+1;
plot(offset+fl./prctile(fl,ptile),'LineWidth',2,'Color',colour(i,:))
hold on
spks = offset+0.5*gmROIts.z(1).roi_oasis_s(gmROIts.z(1).roi_oasis_s(:,cell_2)>0,cell_2)./max(gmROIts.z(1).roi_oasis_s(:,cell_2));
plot([x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0);x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0)],...
    [spks';ones(size(spks'))*offset],'LineWidth',2,'Color','k')

cell_2 = 2101;
offset = offset-ofincr;
fl = speciallowess3(gmROIts.z(1).roi_tsz(:,cell_2));
i = i+1;
plot(offset+fl./prctile(fl,ptile),'LineWidth',2,'Color',colour(i,:))
hold on
spks = offset+0.5*gmROIts.z(1).roi_oasis_s(gmROIts.z(1).roi_oasis_s(:,cell_2)>0,cell_2)./max(gmROIts.z(1).roi_oasis_s(:,cell_2));
plot([x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0);x(gmROIts.z(1).roi_oasis_s(:,cell_2)>0)],...
    [spks';ones(size(spks'))*offset],'LineWidth',2,'Color','k')