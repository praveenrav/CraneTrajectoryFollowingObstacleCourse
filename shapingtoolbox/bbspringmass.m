function [impulses]=BBspringmass(L,m1,m2,umax)
%function [impulses]=BBspringmass(L,m1,m2,umax)
%Bang-Bang command generator for 2-mass/spring system
%L=move distance
%m1,m2 = mass values
%umax = maximum actuator effort
amps=[1 -2 1]';
times=[0 sqrt(L*(m1+m2)/umax) 2*sqrt(L*(m1+m2)/umax)]';
impulses=[times amps];
