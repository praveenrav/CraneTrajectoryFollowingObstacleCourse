function [shaper,exactshaper] = negzv(f,zeta,P,deltaT)

% [shaper,exactshaper] = negzv(f,zeta,P,deltaT)
% Generates a negative ZV shaper for 1 mode.
%
% Returns the digital sequence by default, and
% the exact sequence as the second variable:
%
%  to Return the digital sequence, use:
%		dig_shaper=negzv(f,z,0.001)
%
% f - frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% P - Input Peak
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

fd=sqrt(1-zeta^2)*f;
Td=1/fd;
if P ==1,
   t2=(0.20963 + .22433*zeta)*Td;   
   t3=(0.29027 + .08865*zeta + .02646*zeta^2)*Td;
   a1=1;a2=-2;a3=2;
elseif P ==2,
   t2=(0.12929 + .09393*zeta - .06204*zeta^2)*Td;   
   t3=(0.20975 + .02418*zeta - .07474*zeta^2)*Td;
    a1=2;a2=-4;a3=3;
elseif P ==3,
   t2=(0.10089 + .05976*zeta - .05376*zeta^2)*Td;   
   t3=(0.17420 + .01145*zeta - .07317*zeta^2)*Td;
    a1=3;a2=-6;a3=4;
end

exactshaper=[0	a1;t2 a2;t3 a3];
shaper = digseq(exactshaper,deltaT);
