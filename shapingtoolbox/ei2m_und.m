function [shaper,exactshaper] = EI2M_UND(f1,f2,Vlim1,Vlim2,deltaT)

% EI2M_UND(f1,f2,Vlim1,Vlim2,deltaT) -- Bill Singhose
% Generates an EI shaper 2 UNDAMPED modes.
% (The vibration at the modeling frequency is limited to Vlim
%  and the insensitivity is maximized)
% The shapers for each mode are convolved together to give the
% final shaper.
% f1,f2 - frequency (Hz) of vibration being controlled.
% Vlim1,Vlim2 - vibration limits, for 5% vibration, Vlim=0.05.
% deltaT - time spacing at which input to system is updated.
 

% Mode 1 
Wn1=2*pi*f1; 
shaperdeltaT1=pi/Wn1;

T21=shaperdeltaT1;
T31= 2*shaperdeltaT1;     
A11=(1+Vlim1)/4;
A21=2*(1-Vlim1)/4;
A31=(1+Vlim1)/4;

% shaper for mode1
exactshaper1=[0 A11;T21 A21;T31 A31]

% Mode 2  
Wn2=2*pi*f2; 
shaperdeltaT2=pi/Wn2;

T22=shaperdeltaT2;
T32= 2*shaperdeltaT2;     
A12=(1+Vlim2)/4;
A22=2*(1-Vlim2)/4;
A32=(1+Vlim2)/4;
% shaper for mode2
exactshaper2=[0 A12;T22 A22;T32 A32]

% Convolve the two shapers together 
exactshaper=seqconv(exactshaper1,exactshaper2);
shaper = digseq(exactshaper,deltaT);

