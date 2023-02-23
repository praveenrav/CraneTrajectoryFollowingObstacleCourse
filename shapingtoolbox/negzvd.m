function [shaper,exactshaper] = NEGZVD(f,zeta,P,deltaT)

% NEGZVD(f,zeta,P,deltaT)-- Bill Singhose
% Generates a negative ZVD shaper for 1 mode.
%
% Returns the digital sequence by default, and
% the exact sequence as the second variable:
% eg: to generate the exact shaper, use:
%		  [dig_shaper,exact_shaper]=singer13(f,z,0.01)
%	note:  the 0.01 is ignored for the exact shaper and 
%	       dig_shaper can be ignored
%
%  to Return the digital sequence, use:
%		dig_shaper=singer13(f,z,0.001)
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
   t2=(0.15236 + .2323*zeta + .09745*zeta^2)*Td;   
   t3=(0.2775 + .10237*zeta - .00612*zeta^2)*Td;
   t4=(0.63139 + .33716*zeta - .07724*zeta^2)*Td;
   t5=(0.67903 + .18179*zeta - .06008*zeta^2)*Td;
elseif P ==2,
   t2=(0.117 + .15424*zeta + .03449*zeta^2)*Td;   
   t3=(0.26041 + .11899*zeta - .0591*zeta^2)*Td;
   t4=(0.49378 + .15092*zeta - .2538*zeta^2)*Td;
   t5=(0.56273 + .04255*zeta - .19898*zeta^2)*Td;
else
   t2=(0.10022 + .11695*zeta + .00246*zeta^2)*Td;   
   t3=(0.24352 + .10877*zeta - .0879*zeta^2)*Td;
   t4=(0.44109 + .11059*zeta - .23127*zeta^2)*Td;
   t5=(0.51155 + .02121*zeta - .20054*zeta^2)*Td;
end

exactshaper=[0	1;t2 -2;t3 2;t4 -2;t5 2];
shaper = digseq(exactshaper,deltaT);
