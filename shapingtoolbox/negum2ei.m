function [shaper,exactshaper,minBB] = NEGUM2EI(f,z,V,deltaT)

% [shaper,exactshaper,minBB] =NEGUM2EI(f,zeta,V,deltaT)-- Bill Singhose
% Generates a negative 2-Hump EI shaper for 1 mode
% that when used with a BANG-BANG unshaped command
% will NOT cause over-currenting if the pulses in the 
% bang-bang are longer than the shaper length.
%
% Returns the digital sequence by default, and
% the exact sequence as the second variable.
% The minimum duration for the unshaped bang-bang command to 
% avoid over-currenting is also returned(minBB=2*shaper length)
%
% f - undamped frequency (Hz) =Wn/2*pi.
% z - damping ratio 
% deltaT - sampling period
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.
%
% This function produces good answers over the range 0<z<0.4.
% Only V=0.05 and V=0.0125 are available at this time.


amps=[1;-1;1;-1;1;-1;1];
T=1/f;
if z>0.3,
   fprintf('WARNING: Damping Ratio is probably too large.\n');
end
  
if V==0.05,
  t(1)=0;
  t(2)=(0.059696+0.3136*z+0.31759*z^2+1.5872*z^3)*T;   
  t(3)=(0.40067-0.085698*z+0.14685*z^2+1.6059*z^3)*T; 
  t(4)=(0.59292+0.38625*z+0.34296*z^2+1.2889*z^3)*T; 
  t(5)=(0.78516-0.088283*z+0.54174*z^2+1.3883*z^3)*T;
  t(6)=(1.1264+0.20919*z+0.44217*z^2+0.30771*z^3)*T; 
  t(7)=(1.1864-0.029931*z+0.79859*z^2+0.10478*z^3)*T;
elseif V==0.0125,
  t(1)=0;
  t(2)=(0.052025+0.25516*z+0.33418*z^2+0.70993*z^3)*T;   
  t(3)=(0.39946-0.13396*z+0.23553*z^2+0.59066*z^3)*T; 
  t(4)=(0.58814+0.33393*z+0.4242*z^2+0.4844*z^3)*T; 
  t(5)=(0.77682-0.13392*z+0.61271*z^2+0.63186*z^3)*T;
  t(6)=(1.1244+0.21132*z+0.55855*z^2+0.12884*z^3)*T; 
  t(7)=(1.1765-0.016188*z+0.9134*z^2-0.068185*z^3)*T;
else
   fprintf('Only V=0.05 or V=0.0125 can be used at this time.\n');
end

exactshaper=[t' amps];
shaper = digseq(exactshaper,deltaT);
minBB=2*length(shaper)*deltaT;
end
