function [p1,f] = Fspectrum(x,timebase)
sfreq = 1./mean(diff(timebase));
if sum(isnan(x))>0 
    x = resample(x,timebase);
end
speriod = 1./sfreq;
slength = max(timebase);
F = fft(x);
p2 = abs(F./numel(timebase));
p1 = p2(1:round(numel(timebase)./2)+1);
f = sfreq*(timebase(1:round(numel(timebase)./2)+1))./slength;
end