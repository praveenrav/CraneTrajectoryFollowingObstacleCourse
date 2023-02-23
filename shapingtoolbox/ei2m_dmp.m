function [shaper,exactshaper] = EI2M_DMP(fd1,fd2,z1,z2,V1,V2,deltaT)

% EI2M_DMP(fd1,fd2,z1,z2,V1,V2,deltaT) -- Bill Singhose
% Generates an EI shaper for 2 modes.
% The solution comes from a surface fit to data calculated with GAMS.
% The shaper works well over the ranges of 0<V<.2 ans 0<z<.25
% The shapers for each mode are convolved together to give the
% final shaper.
% fd1,fd2 - frequency (Hz) of damped vibration being controlled.
% zeta1,zeta2 - damping ratios of vibration being controlled.
% Vlim1,Vlim2 - vibration limits, for 5% vibration, Vlim=0.05.
% deltaT - time spacing at which input to system is updated.


Td1=1/fd1;
Td2=1/fd2;

% Mode 1
amp11= 0.249684+0.249623*V1+0.800081*z1+1.23328*V1*z1+0.495987*z1^2+3.17316*V1*z1^2;
amp31 = 0.251489+0.21474*V1-0.832493*z1+1.41498*V1*z1+0.851806*z1^2-...
4.90094*V1*z1^2;
amp21 = 1 - (amp11+amp31);
t21 = (0.499899+0.461586*V1*z1+4.26169*V1*z1^2+1.75601*V1*z1^3+8.57843*V1^2*z1 - ...
108.644*V1^2*z1^2+336.989*V1^2*z1^3)*Td1;
t31 = Td1;
shaper1=[0 amp11;t21 amp21;t31 amp31];

% Mode 2
amp12= 
0.249684+0.249623*V2+0.800081*z2+1.23328*V2*z2+0.495987*z2^2+3.17316*V2*z2^2;
amp32 = 0.251489+0.21474*V2-0.832493*z2+1.41498*V2*z2+0.851806*z2^2-...
4.90094*V2*z2^2;
amp22 = 1 - (amp12+amp32);
t22 = (0.499899+0.461586*V2*z2+4.26169*V2*z2^2+1.75601*V2*z2^3+8.57843*V2^2*z2 - ...
108.644*V2^2*z2^2+336.989*V2^2*z2^3)*Td2;
t32 = Td2;
shaper2=[0 amp12;t22 amp22;t32 amp32];

% Convolve the two shapers together 
exactshaper=seqconv(shaper1,shaper2);
shaper = digseq(exactshaper,deltaT);
 
