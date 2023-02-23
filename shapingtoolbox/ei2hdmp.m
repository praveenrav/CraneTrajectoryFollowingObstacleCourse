function [shaper,exactshaper] = EI2HUMP(f,z,V,deltaT)

% EI2HUMP
% [shaper,exactshaper] = EI2HUMP(f,z,V,deltaT)
% Generates a two-hump EI shaper
% f - frequency (Hz) of vibration being controlled.
% V - vibration limit
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigSeq to convert the exact sequence to digital format.

t = 1/f;
if z==0,
  X=(V^2*(sqrt(1-V^2)+1))^(1/3);
  A1=(3*X^2+2*X+3*V^2)/(16*X);
  A2=0.5-A1;
  A3=A2;
  A4=A1;
  exactshaper=[0  A1;.5*t A2;t A3;1.5*t A4];
  shaper = digseq(exactshaper,deltaT);
else,
  fprintf('not equipped for nonzero damping yet.');
   exactshaper=[0  0;1 0];
  shaper = digseq(exactshaper,deltaT);

end
