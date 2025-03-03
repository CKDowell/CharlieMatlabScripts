function [fspec,freq] = fspecCD(data,Fs)
% function outputs the single sided fourier spectrum of a signal
warning('off')
L = numel(data);
y = fft(data);
P2 = abs(y/L);
fspec = P2(1:L/2+1);
fspec(2:end-1) = 2*fspec(2:end-1);
freq = Fs*(0:(L/2))/L;
warning('on')
end