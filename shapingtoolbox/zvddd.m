function [shaper,exactshaper] = ZVDDD(f,zeta,deltaT)

% ZVDDD -- Bill Singhose - 
% Edited on 8/7/06 to include damping -- Joshua Vaughan
% Generates a ZVDDD shaper for 1 mode.
% f - frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

Wn=2*pi*f;
shaperdeltaT=pi/(Wn*sqrt(1-(zeta)^2));
K=exp(-zeta*pi/(sqrt(1-zeta^2)));

time2=shaperdeltaT;   
time3=2*shaperdeltaT;
time4=3*shaperdeltaT;
time5=4*shaperdeltaT;

shaperdenom = 1+4*K+6*K^2+4*K^3+K^4;


amp1=1/shaperdenom;
amp2=4*K/shaperdenom;
amp3=6*K^2/shaperdenom;
amp4=4*K^3/shaperdenom;
amp5=K^4/shaperdenom;

exactshaper=[0  amp1;time2 amp2;time3 amp3;time4 amp4;time5 amp5];
shaper = digseq(exactshaper,deltaT);
