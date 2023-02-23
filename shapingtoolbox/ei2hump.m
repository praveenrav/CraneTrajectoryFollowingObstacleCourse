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
  A1=0.16054+0.76699*z+2.2656*z^2-1.2275*z^3;
  A2=0.33911+0.45081*z-2.5808*z^2+1.7365*z^3;
  A3=0.34089-0.61533*z-0.68765*z^2+0.42261*z^3;
  A4=1-A1-A2-A3;
  t2=(0.4989+0.1627*z-0.54262*z^2+6.1618*z^3)*t;
  t3=(0.99748+0.18382*z-1.5827*z^2+8.1712*z^3)*t;
  t4=(1.4992-0.09297*z-0.28338*z^2+1.8571*z^3)*t;
  exactshaper=[0  A1;t2 A2;t3 A3;t4 A4];
  shaper = digseq(exactshaper,deltaT);

end
