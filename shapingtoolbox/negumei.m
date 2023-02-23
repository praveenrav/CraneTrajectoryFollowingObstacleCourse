function [shaper,exactshaper,minBB] = NEGUMEI(f,z,V,deltaT)

% [shaper,exactshaper,minBB] = NEGUMEI(f,zeta,V,deltaT)-- Bill Singhose
% Generates a negative Bang-Bang EI shaper for 1 mode
% that when used with a bang-bang unshaped command
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
amps=[1;-1;1;-1;1];
T=1/f;
if z>0.4,
   fprintf('WARNING: Damping Ratio is probably too large.\n');
end

if V==0.05,
  t(1)=0;
  t(2)=(0.09374+0.31903*z+0.13582*z^2+0.65274*z^3)*T;   
  t(3)=(0.36798-0.05894*z+0.13641*z^2+0.63266*z^3)*T; 
  t(4)=(0.64256+0.28595*z+0.26334*z^2+0.24999*z^3)*T; 
  t(5)=(0.73664+0.00162*z+0.52749*z^2+0.19208*z^3)*T;
elseif V==0.0125,
  t(1)=0;
  t(2)=(0.09051+0.29315*z+0.20436*z^2+0.29053*z^3)*T;   
  t(3)=(0.36658-0.081044*z+0.21524*z^2+0.27994*z^3)*T; 
  t(4)=(0.64274+0.28822*z+0.25424*z^2+0.34977*z^3)*T; 
  t(5)=(0.73339+0.006322*z+0.51595*z^2+0.29764*z^3)*T;
else
   fprintf('Only V=0.05 or V=0.0125 can be used at this time.\n');
end
  
exactshaper=[t' amps];
shaper = digseq(exactshaper,deltaT);
minBB=2*length(shaper)*deltaT;

