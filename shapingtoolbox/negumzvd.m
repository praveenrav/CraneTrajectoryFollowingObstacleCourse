function [shaper,exactshaper,minBB] = NEGUMZVD(f,z,deltaT)

% NEGUMZVD(f,zeta,deltaT)-- Bill Singhose
% Generates a negative ZVD shaper for 1 mode
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

if z>0.4,
   fprintf('WARNING: Damping Ratio is probably too large.\n');
end

amps=[1;-1;1;-1;1];
T=1/f;
t(1)=0;
t(2)=(0.08945+0.28411*z+0.23013*z^2+0.16401*z^3)*T;   
t(3)=(0.36613-0.08833*z+0.24048*z^2+0.17001*z^3)*T; 
t(4)=(0.64277+0.29103*z+0.23262*z^2+0.43784*z^3)*T; 
t(5)=(0.73228+0.00992*z+0.49385*z^2+0.38633*z^3)*T;
exactshaper=[t' amps];
shaper = digseq(exactshaper,deltaT);
minBB=2*length(shaper)*deltaT;
