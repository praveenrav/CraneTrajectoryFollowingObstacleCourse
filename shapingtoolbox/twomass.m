function [num,den]=twomass(w1,w2)
% [num,den]=twomass(w1,w2)
% TWOMASS(w1,w2) returns a transfer function model for a two mass
% 	system with masses m1, m2 and a spring k between the masses.
%	w1^2=k/m1, w2^2=k/m2; the natural frequencies that correspond
%	to holding one mass fixed and twanging the other mass.
%	The transfer function is for a force input to mass m1 with
%	a displacement outputs at masses m1 and m2. (m1 case co-located)
%	The transfer functions are for x1/(F/m1), x2/(F/m1)
numm1=[0 0 1 0 w2^2];
numm2=[0 0 0 0 w2^2];
num=[numm1 ; numm2];
den=[1 0 (w1^2+w2^2) 0 0];
