function [shaper,exactshaper] = EI(fd,z,V,deltaT)

% EI(fd,z,V,deltaT) -- Bill Singhose
% Generates an EI shaper for 1 mode.
% The solution comes from a surface fit to data calculated with GAMS.
% The shaper works well over the ranges of 0<V<.2 ans 0<z<.25
% fd - damped frequency (Hz) of vibration being controlled.
% z - damping ratio of vibration being controlled.
% V - vibration limit, for 5% vibration, Vlim=0.05.
% deltaT - time spacing at which input to system is updated.


A1= 0.249684+0.249623*V+0.800081*z+1.23328*V*z+0.495987*z^2+3.17316*V*z^2;
A3 = 0.251489+0.21474*V-0.832493*z+1.41498*V*z+0.851806*z^2-4.90094*V*z^2;
A2 = 1 - (A1+A3);
t1  = 0;
t2  =(0.499899+0.461586*V*z+4.26169*V*z^2+1.75601*V*z^3+8.57843*V^2*z -... 
108.644*V^2*z^2+336.989*V^2*z^3)/fd;
t3 = 1/fd;

exactshaper=[t1 A1;t2 A2;t3 A3];
shaper = digseq(exactshaper,deltaT);
