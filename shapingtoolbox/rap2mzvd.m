function [shaper,exactshaper] = RAP2MZVD(f1,f2,deltaT)

% RAP2MZVD(f1,f2,deltaT) -- Bill Singhose
% Generates a 2 Mode ZVD shaper on based Rappole equations 
% for 2 undamped modes.
% Do not use this for frequency ratios over 3.76679 - it will
% result in gains larger than one.
% f1, f2 - frequencies(Hz) of vibration being controlled
 
sum=(f1+f2);
k=sin(pi*f1/sum);
sqk=k*k;
t=1/sum; 

d=16*sqk^2;
time2=t;
time3=2*t;
time4=3*t;
time5=4*t;

amp1=1/d;
amp2=(8*sqk-4)/d;
amp3=1-2*amp1-2*amp2;
amp4=amp2;
amp5=amp1;

exactshaper=[
0       amp1
time2 amp2
time3 amp3
time4 amp4
time5 amp5];
 
shaper = digseq(exactshaper,deltaT);
