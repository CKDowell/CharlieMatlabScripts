datadir = 'Y:\Data\FCI\Hedwig\SS82335_D605_sytGC7f\240222\f1\Trial1\registered\240222_f1_Trial1_All.tif';
%datadir = 'Y:\Data\FCI\Hedwig\SS82335\240305\f1\Trial1\registered\240305_f1_Trial1_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\SS70711_FB4X\240313\f1\Trial3\registered\240313_f1_Trial3_All.tif';
%datadir = 'Y:\Data\FCI\Hedwig\SS60291_PFL3_60D05_sytGC7f\240314\f1\Trial2\registered\240314_f1_Trial2_All.tif';
%datadir = 'Y:\Data\FCI\Hedwig\FC2_60D05_sytGC7f\240308\f1\Trial4\registered\240308_f1_Trial4_All.tif';
%datadir = 'Y:\Data\FCI\AndyData\hdb\20220520_hdb_60D05_sytjGCaMP7f_Fly1-001\registered\AndyData_hdb_20220520_hdb_60D05_sytjGCaMP7f_Fly1-001_All.tif';
datadir = 'E:\Data\Hedwig\FC2_maimon2\240404\f1\Trial4\registered\240404_f1_Trial4_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FC2_maimon2\240502\f1\Trial1\registered\240502_f1_Trial1_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FC2_maimon2\240514\f1\Trial3\registered\240514_f1_Trial3_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\TH_GC7f\240521\f2\Trial2\registered\240521_f2_Trial2_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\TH_GC7f\240529\f3\Trial1\registered\240529_f3_Trial1_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\SS70711_FB4X\240531\f1\Trial3\registered\240531_f1_Trial3_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FB5I_SS100553_sytGC7f\240607\f1\Trial3\registered\240607_f1_Trial3_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FB5I_SS100553\240628\f1\Trial2\registered\240628_f1_Trial2_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FB4P_b_SS67631\240720\f1\Trial3\registered\240720_f1_Trial3_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FB4P_b_sytGC7f\240806\f1\Trial6\registered\240806_f1_Trial6_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FB4P_b_sytGC7f\240809\f2\Trial3\registered\240809_f2_Trial3_All.tif';
datadir = 'Y:\Data\FCI\Hedwig\FC2_maimon2\240821\f2\Trial3\registered\240821_f2_Trial3_All.tif';
datadir ='Y:\Data\FCI\Hedwig\FB4P_b_sytGC7f\240906\f2\Trial4\registered';
datadir = 'Y:\Data\FCI\Hedwig\FB5I_SS100553\240917\f3\Trial4\registered';
datadir = 'Y:\Data\FCI\Hedwig\FC2_maimon2\241025\f2\Trial4\registered';
datadir = 'Y:\Data\FCI\Hedwig\FC2_maimon2\241029\f2\Trial2\registered';
datadir = 'Y:\Data\FCI\Hedwig\FB5AB_SS53640\241205\f2\Trial4\registered';
datadir = 'Y:\Data\FCI\Hedwig\PFL3_maimon3\241219\f2\Trial4\registered';

datadir = 'Y:\Data\FCI\Hedwig\FC2_508E03\250219\f1\Trial3\registered';

d = dir(datadir);
for i = 1:length(d)
    n = d(i).name;
    if length(n)<7
        continue
    end
    if n(end-6:end)=='All.tif'
        full_dir = fullfile(datadir,n);
        break
    end
end
DrawMasksCX(full_dir)
