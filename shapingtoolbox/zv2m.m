function [shaper,exactshaper] = ZV2M(f1,f2,zeta1,zeta2,deltaT)

% ZV2M(f1,f2,zeta1,zeta2,deltaT)
% ZV2M -- Bill Singhose
% Generates a ZV shaper for 2 modes.
% The shapers for each mode are convolved together to give the
% final shaper.
% f1,f2 - frequencies (Hz) of vibration being controlled.
% zeta1,zeta2 - damping ratios of vibration being controlled.
% deltaT - time spacing at which input to system is updated.
%
% Check to see if there is sufficient frequency seperation to
% justify using this filter.
if abs(f1-f2)/f1 < .1,
		 fprintf('\t This filter should not be used for such a \n'); 
 		fprintf('\t  small frequency seperation.  Use Singer13.\n');
   return
end
[d1,exact1]=zv(f1,zeta1,deltaT);
[d2,exact2]=zv(f2,zeta2,deltaT);    

% Convolve the two shapers together 
exactshaper=seqconv(exact1,exact2);
shaper = digseq(exactshaper,deltaT);

