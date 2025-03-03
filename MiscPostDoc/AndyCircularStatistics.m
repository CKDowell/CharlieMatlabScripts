datadir = 'Y:\Papers, Review, Theses\RutaLabPapers\ET_2024\AndyCircStats\entry_directions.csv';
T = readtable(datadir);
%% Compile dataclc
clc
directions = [0,45,90];
times = {'entry','5','10','30','60'};

bigdat = [];
for d = 1:numel(directions)
    td = directions(d);
    smalldat = [];
    for t = 1:numel(times)
        t_name = ['x' num2str(td) '_' times{t}];
        tdat = T(:,t_name);
        smalldat = [smalldat;[table2array(tdat),ones(size(tdat))*t]];
    end
    bigdat(d).data = smalldat;
end

%% Do stats
clc
for i = 1:3
    statsdata = bigdat(i).data;
    snan = ~isnan(statsdata(:,1));
    %%sum(snan)/5
    statsdata = statsdata(snan,:);
    [pval,tab] = circ_wwtest(statsdata(:,1),statsdata(:,2));
    disp([num2str(directions(i)) ' : p = ' num2str(pval)])
end
%% Polar plots
rho = 1:5;
figure
colours = [
    %166,189,219;
116,169,207;
%54,144,192;
5,112,176;
4,90,141;
2,56,88]/255;
colours = flipud(colours);

for i = 1:3
    cm = [];
    td =bigdat(i).data;
    ndx = ~isnan(td(:,1));
    td = td(ndx,:);
    
    for r = rho
        
        cm = [cm,circ_mean(td(td(:,2)==r,1))];
        cs = circ_std(td(td(:,2)==r,1))/sqrt(sum(td(:,2)==r));
        as = linspace(cm(r)-cs,cm(r)+cs,100);
        rs = ones(1,100)*(r);
        polarplot(as,rs,'Color',colours(i,:))
        hold on
        
        %polar([(cm(r)-cs),cm(r)+cs],[r,r])
        
    end
    

    polarplot([0,cm],[0,rho],'Color',colours(i,:))
    hold on
    polarscatter(cm,rho,25,colours(i,:),'filled')
end
g = gca;
g.RTick = [1:5];
g.RTickLabel = times;
g.ThetaTick = 0:90:360;
g.ThetaTickLabel = [90,180,270,0];
%% stats comp
scombo = [1,2;1 3;2 3];
pmat = zeros(3,1);
for s = 1:size(scombo,1)
    dat1 = bigdat(scombo(s,1)).data(:,1);
    dat2 = bigdat(scombo(s,2)).data(:,1);
    dat1 = dat1(~isnan(dat1));
    dat2 = dat2(~isnan(dat2));
    datin = [dat1;dat2];
    idx = [ones(size(dat1));ones(size(dat2))*2];
    [pmat(s),~] = circ_wwtest(datin,idx);
end
pmat = pmat*3;