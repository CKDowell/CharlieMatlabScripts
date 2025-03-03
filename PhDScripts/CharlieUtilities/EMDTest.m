function [ptab,infout] =EMDTest(bins1,bins2,distr1,distr2,nshuff,version)
% Function uses EMD to identify differences between distributions from two
% groups:
% Version 1: compares each distribution vs shuffle between the two and
% outputs position of EMD vs shuffle for each distribution pair.
% Version 2: computes EMD for all within group and across group pairs, then
% does a non parametric stats test between the EMD values.Output is the EMD
% values and the stats test results.
if version ==1
    infout = [];
    nbins = numel(bins1);
    ptab = nan(size(distr1,2),2);
    for f = 1:size(distr1,2)
        [~,EMD] =  earthmd(bins1,bins2,distr1(:,f),distr2(:,f),@gdf);
        EMDshuff = nan(nshuff,1);
        for s = 1:nshuff
            randlist  = randperm(numel(bins1),ceil(numel(bins1)./2));
            sdis1 = distr1(:,f);
            sdis2 = distr2(:,f);
            sdis1(randlist) = distr2(randlist,f);
            sdis2(randlist) = distr1(randlist,f);
            [~,EMDshuff(s)] = earthmd(bins1,bins2,sdis1,sdis2,@gdf);
            clc
        end
        ptab(f,1) = EMD;
        ptab(f,2) = revprctile(EMDshuff,EMD);
    %     if ptab(f,2)<95
    %         keyboard
    %     end
    end
    % ptab(:,2) = 100-ptab(:,2);

elseif version==2
    nsamps = size(distr1,2);
    nulln = ((nsamps-1)+1)*(nsamps-1)./2;
    null = nan(nulln,2);
    test = nan(nulln,1);
    samplist = 1:nsamps-1;
    samplist = fliplr(samplist);
    cntnull = [1 1];
    cntest = [1];
    for i = samplist
        for r = 1:2
            if r==1
                thisp = distr1(:,i);
            else
                thisp = distr2(:,i);
            end
            for j = 1:samplist(i)
                if r==1
                    [~,null(cntnull(r),r)] = earthmd(bins1,bins1,thisp,distr1(:,i+j),@gdf);
                else
                    [~,null(cntnull(r),r)] = earthmd(bins2,bins2,thisp,distr2(:,i+j),@gdf);
                end
                clc
                cntnull(r) =cntnull(r)+1;
            end
        end


        thisp = distr1(:,i);
        for j = 1:samplist(i)
            [~,test(cntest)] = earthmd(bins1,bins2,thisp,distr2(:,i+j),@gdf);
            clc
            cntest =cntest+1;
        end
    
    end
% Non parametric stats test
[~,~,stats] = kruskalwallis([test,null],[],'off');
ptab = multcompareCD(stats,'ctype','dunn-sidak','display','off');
infout = [null,test];
end
end

