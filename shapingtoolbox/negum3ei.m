function [shaper,exactshaper,minBB] = NEGUM3EI(f,z,V,deltaT)

% [shaper,exactshaper,minBB]=NEGUM3EI(f,zeta,deltaT)-- Bill Singhose
% Generates a negative 3-Hump EI shaper for 1 mode
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
% This function produces good answers over the range 0<z<0.26.
% Only V=0.05 and V=0.0125 is available at this time.
amps=[1;-1;1;-1;1;-1;1;-1;1];
T=1/f;

if z>0.2,
   fprintf('WARNING: Damping Ratio is probably too large.\n');
end

if V==0.05,
  t(1)=0;
  t(2)=(0.042745+0.31845*z+0.46272*z^2+3.3763*z^3)*T;   
  t(3)=(0.42418-0.05725*z+0.049893*z^2+3.9768*z^3)*T; 
  t(4)=(0.56353+0.48068*z+0.38047*z^2+4.2431*z^3)*T; 
  t(5)=(0.83047-0.097848*z+0.34048*z^2+4.4245*z^3)*T;
  t(6)=(1.0976+0.38825*z+0.3529*z^2+2.9484*z^3)*T; 
  t(7)=(1.2371-0.08706*z+0.81706*z^2+2.8367*z^3)*T;
  t(8)=(1.6189+0.099638*z+0.4278*z^2+1.3151*z^3)*T; 
  t(9)=(1.6619-0.097105*z+0.80045*z^2+1.0057*z^3)*T;
elseif V==0.0125,
  t(1)=0;
  t(2)=(0.032665+0.23238*z+0.33164*z^2+1.8423*z^3)*T;   
  t(3)=(0.42553-0.12863*z+0.052687*z^2+1.7964*z^3)*T; 
  t(4)=(0.55502+0.36614*z+0.50008*z^2+1.7925*z^3)*T; 
  t(5)=(0.82296-0.19383*z+0.45316*z^2+2.0989*z^3)*T;
  t(6)=(1.091+0.31654*z+0.46985*z^2+1.2683*z^3)*T; 
  t(7)=(1.2206-0.14831*z+0.93082*z^2+1.2408*z^3)*T;
  t(8)=(1.6137+0.1101*z+0.68318*z^2+0.18725*z^3)*T; 
  t(9)=(1.6466-0.063739*z+1.0423*z^2-.10591*z^3)*T;
else
   fprintf('Only V=0.05 or V=0.0125 can be used at this time.\n');
end

exactshaper=[t' amps];
shaper = digseq(exactshaper,deltaT);
minBB=2*length(shaper)*deltaT;

