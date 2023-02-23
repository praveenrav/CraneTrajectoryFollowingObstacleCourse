function [c]= pretf(z,w,s)
% PRETF(Z,W,S) evaluates the transfer fuction of a three impulse prefilter
% designed for a system with the given z and w, at the given value of
% the complex variable s.
K= exp(-z*pi/sqrt(1-z^2));
tau= pi/(w*sqrt(1-z^2));
a1= 1/(1+2*K+K^2);
a2= 2*K/(1+2*K+K^2);
a3= K^2/(1+2*K+K^2);
c= a1 + a2*exp(-s*tau) + a3*exp(-s*2*tau);
