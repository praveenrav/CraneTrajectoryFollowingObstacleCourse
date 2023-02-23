function [shaper,exactshaper,minBB] = NEG2HEI(f,z,V,deltaT)

% NEG2HEI(f,zeta,deltaT)-- Bill Singhose
% Generates a negative 2-Hump EI shaper for 1 mode
% that when used with a Step unshaped command
% will NOT cause over-currenting.
%
% Returns the digital sequence by default, and
% the exact sequence as the second variable.
% The minimum duration for the unshaped bang-bang command to 
% avoid over-currenting is also returned(minBB=2*shaper length)
% eg: to generate the exact shaper, use:
%		  [dig_shaper,exact_shaper]=NEGBBEI(f,z,0.01)
%
%  to Return the digital sequence, use:
%		dig_shaper=NEGBBEI(f,z,0.001)
%
% f - undamped frequency (Hz) =Wn/2*pi.
% z - damping ratio 
% deltaT - sampling period
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.
%
% This function produces good answers over the range 0<z<0.4.
% Only V=0.05 is available at this time.


amps=[1;-2;2;-2;2;-2;2];
T=1/f;
if V~=0.05,
   fprintf('Only V=0.05 can be used at this time.\n');
end
if z>0.4,
   fprintf('WARNING: Damping Ratio is probably too large.\n');
end
  
  t(1)=0;
  t(2)=(0.12876+0.33944*z-0.27144*z^2+2.5697*z^3)*T;   
  t(3)=(0.2737+0.26903*z-0.59539*z^2+2.7676*z^3)*T; 
  t(4)=(0.5813+0.56889*z-0.48854*z^2+2.6709*z^3)*T; 
  t(5)=(0.68252+0.31673*z-0.39106*z^2+2.745*z^3)*T;
  t(6)=(1.0883+0.41645*z-0.059331*z^2+0.92914*z^3)*T; 
  t(7)=(1.1204+0.28229*z+0.15677*z^2+0.79107*z^3)*T;

  exactshaper=[t' amps];
  shaper = digseq(exactshaper,deltaT);
minBB=2*length(shaper)*deltaT;

