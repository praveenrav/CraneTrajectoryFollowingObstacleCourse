% GPLANE.M
% G plane analysis of the response of a second order system to damped
% sinusoid inputs.

t=-5:0.05:5;

ome=input('omega(input)= ');
sig=input('sigma(input)= ');

z=input('zeta(plant)= ');
wn=input('Wn(plant)= ');

s=sig+ome*i;

in0=exp(sig*t).*sin(ome*t);
in1=0.5*(exp(s*t) + exp(conj(s)*t));

den=[1 2*z*wn wn^2] / wn^2;
F=1/polyval(den,s);

mag=abs(F);
phi=angle(F);

ou0=mag*exp(sig*t).*sin(ome*t+phi);
ou1=0.5*(exp(s*t)/polyval(den,s)+exp(conj(s)*t)/polyval(den,conj(s)));

plot(t,in0,t,ou0);
pause
plot(t,in1,t,ou1);
title(['input/output [sig,ome]=[',num2str(sig),',',num2str(ome),']']);
