function [shaper,exactshaper] = ZV(f,zeta,deltaT)

% ZV(f,zeta,deltaT) -- Bill Singhose
% Generates a ZV shaper for 1 mode.
% f - frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

Wn=2*pi*f;
shaperdeltaT=pi/(Wn*sqrt(1-(zeta)^2));
K=exp(-zeta*pi/(sqrt(1-zeta^2)));
shaperdenom=1 + K;

time2=shaperdeltaT;   
 
amp1=1/shaperdenom;
amp2=K/shaperdenom;

exactshaper=[0  amp1;time2 amp2];
shaper = digseq(exactshaper,deltaT);
