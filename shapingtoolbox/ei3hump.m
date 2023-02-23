function [shaper,exactshaper] = EI3HUMP(f,V,deltaT)

% EI3HUMP
% [shaper,exactshaper] = EI3HUMP(f,V,deltaT)
% Generates a three-hump EI shaper
% f - frequency (Hz) of vibration being controlled.
% V - vibration limit
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigSeq to convert the exact sequence to digital format.

t = 1/f;

A1=(1+3*V+2*sqrt(2*(V^2+V)))/(16);
A2=(1-V)/4;
A3=1-2*(A1+A2);
A4=A2;
A5=A1;
exactshaper=[0  A1;.5*t A2;t A3;1.5*t A4;2*t A5];
shaper = digseq(exactshaper,deltaT);
