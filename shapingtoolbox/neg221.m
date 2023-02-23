function [shaper,exactshaper] = neg221(f,z,deltaT)

% [shaper,exactshaper] = neg221(f,z,deltaT)
% Generates a negative shaper for 1 mode.
%   Amplitudes = [2 -2 1]
% Returns the digital sequence by default, and
% the exact sequence as the second variable:
%
%  to Return the digital sequence, use:
%		dig_shaper=negzv(f,z,0.001)
%
% f - NATURAL frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

%fd=sqrt(1-z^2)*f;
Td=1/f;
   t2=(0.080429 + 0.12919*z+0.024804*z^2)*Td;   
   t3=(0.2902 -0.090225*z + 0.136946*z^2-0.043337*z^3)*Td;
a1=2
a2=-2;a3=1;
exactshaper=[0 a1;t2 a2;t3 a3];
shaper = digseq(exactshaper,deltaT);
