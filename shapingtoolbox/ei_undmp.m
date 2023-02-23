function [shaper,exactshaper] = EI_UNDMP(f,Vlim,deltaT)

% EI_UNDMP(f,Vlim,deltaT) -- Bill Singhose
% Generates an EI shaper for 1 UNDAMPED mode.
% (The vibration at the modeling frequency is limited to Vlim
%  and the insensitivity is maximized)
% f - frequency (Hz) of vibration being controlled.
% Vlim - vibration limit, for 5% vibration, Vlim=0.05.
% deltaT - time spacing at which input to system is updated.
 
Wn=2*pi*f;
shaperdeltaT=pi/Wn;

T2=shaperdeltaT;
T3= 2*shaperdeltaT;
      
A1=(1+Vlim)/4;
A2=2*(1-Vlim)/4;
A3=(1+Vlim)/4;

exactshaper=[0 A1;T2 A2;T3 A3];
shaper = digseq(exactshaper,deltaT);
      
