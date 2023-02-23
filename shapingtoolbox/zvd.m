function [shaper,exactshaper] = ZVD(f,zeta,deltaT)

% [shaper,exactshaper]=ZVD(f,zeta,deltaT)-- Bill Singhose
% Generates a ZVD shaper for 1 mode.
%
% Returns the digital sequence by default, and
% the exact sequence as the second variable:
% eg: to generate the exact shaper, use:
%		  [dig_shaper,exact_shaper]=singer13(f,z,0.01)
%	note:  the 0.01 is ignored for the exact shaper and 
%	       dig_shaper can be ignored
%
%  to Return the digital sequence, use:
%		dig_shaper=singer13(f,z,0.001)
%
% f - frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

Wn=2*pi*f;
shaperdeltaT=pi/(Wn*sqrt(1-(zeta)^2));
K=exp(-zeta*pi/(sqrt(1-zeta^2))); 
shaperdenom=1 + 2*K + K^2;

time2=shaperdeltaT;   
time3=2*shaperdeltaT;

amp1=1/shaperdenom;
amp2=2*K/shaperdenom;
amp3=K^2/shaperdenom;
exactshaper=[0	amp1;time2 amp2;time3 amp3];
shaper = digseq(exactshaper,deltaT);
