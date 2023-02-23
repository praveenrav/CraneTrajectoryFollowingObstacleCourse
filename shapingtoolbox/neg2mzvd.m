function shaper = NEG2MZVD(f1,deltaT)

% NEG2MZVD(f1,dt)
% NEG2MZVD Generates a negative 2 mode ZVD shaper
% based on Rappole equations
%
% f1 - Frequency to shape for (Hz.)
% deltaT - Time spacing (sec/step)
%

f2 = f1 *(pi/asin(sqrt(3/8)) - 1);

shaper = RAP2MZVD(f1,f2,deltaT);
end