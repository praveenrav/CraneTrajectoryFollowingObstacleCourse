function [digshap,exact] = SI(fd,z,V,ins,deltaT)

% SI(fd,z,V,ins,deltaT) -- Bill Singhose
% Generates an SI shaper for 1 mode.
%Temp Version

if ins==0.3,
  siamps=[0.2625	0.475	0.2625];
  sitimes=[0	0.47075	0.9415];
elseif ins==0.6,
  siamps=[0.1597972	0.3402028	0.3402028	0.1597972];
  sitimes=[0	0.4555201	0.9110402	1.366560];
end
sitimes=sitimes/fd;
exact=[sitimes' siamps'];
digshap = digseq(exact,deltaT);
