function [shaper,exactshaper,minBB] = NEGUMZV(f,z,deltaT)

% NEGUMZV(f,zeta,deltaT)-- Bill Singhose
% Generates a negative ZV shaper for 1 mode
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

amps=[1;-1;1];
T=1/f;
t(1)=0;
t(2)=(0.16658+0.29277*z+0.075438*z^2+0.21335*z^3)*T;   
t(3)=(0.33323+0.0053322*z+0.17914*z^2+0.20125*z^3)*T; 
exactshaper=[t' amps];
shaper = digseq(exactshaper,deltaT);
minBB=2*length(shaper)*deltaT;
