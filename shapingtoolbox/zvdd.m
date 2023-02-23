function [shaper,exactshaper] = ZVDD(f,zeta,deltaT)

% ZVDD -- Bill Singhose
% Generates a ZVDD shaper for 1 mode.
% f - frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

Wn=2*pi*f;
shaperdeltaT=pi/(Wn*sqrt(1-(zeta)^2));
K=exp(-zeta*pi/(sqrt(1-zeta^2)));
shaperdenom=1 + 3*K + 3*K^2 + K^3;

time2=shaperdeltaT;   
time3=2*shaperdeltaT;
time4=3*shaperdeltaT;
amp1=1/shaperdenom;
amp2=3*K/shaperdenom;
amp3=3*K^2/shaperdenom;
amp4=K^3/shaperdenom;

exactshaper=[0  amp1;time2 amp2;time3 amp3;time4 amp4];
shaper = digseq(exactshaper,deltaT);
