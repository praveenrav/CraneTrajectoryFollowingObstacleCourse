function [shaper,exactshaper] = RAP2MZV(f1,f2,deltaT)

% RAP2MZV(f1,f2,deltaT) -- Bill Singhose
% Generates a 2 mode ZV shaper based on 
% Rappole equations for 2 undamped modes.
% Do not use this for frequency ratios over 3.76679 - it will
% result in gains larger than one.
% f1, f2 - frequencies(Hz) of vibration being controlled
% deltaT - time spacing at which input to system is updated
 
sum=f1+f2;
k=sin(pi*f1/sum);
t=1/sum; 

d=4*k*k;
time2=t;
time3=2*t;

amp1=1/d
amp2=(4*k*k-2)/d;
amp3=amp1;

exactshaper=[0	amp1;
         time2 amp2;
         time3 amp3];
 
shaper = digseq(exactshaper,deltaT);
