function [shaper,exactshaper] = ZVD2M(f1,f2,zeta1,zeta2,deltaT)

% ZVD-2M(f1,f2,zeta1,zeta2,deltaT)
% ZVD-2M -- Bill Singhose
% Generates a ZVD shaper for 2 modes.
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
Wn1=2*pi*f1; 
Wn2=2*pi*f2; 
% Mode 1  
shaperdeltaT1=pi/(Wn1*sqrt(1-(zeta1)^2));
K1=exp(-zeta1*pi/(sqrt(1-zeta1^2)));
shaperdenom1=1 + 2*K1 + K1^2;

time21= shaperdeltaT1;
time31= 2*shaperdeltaT1;
amp11=1/shaperdenom1;
amp21=2*K1/shaperdenom1;
amp31=K1^2/shaperdenom1;
exactshaper1=[0 amp11;time21 amp21;time31 amp31];

% Mode 2  
shaperdeltaT2=pi/(Wn2*sqrt(1-(zeta2)^2));
K2=exp(-zeta2*pi/(sqrt(1-zeta2^2)));
shaperdenom2=1 + 2*K2 + K2^2;

time22= shaperdeltaT2;
time32= 2*shaperdeltaT2;
amp12=1/shaperdenom2;
amp22=2*K2/shaperdenom2;
amp32=K2^2/shaperdenom2;
exactshaper2=[0 amp12;time22 amp22;time32 amp32];
    
% Convolve the two shapers together 
exactshaper=seqconv(exactshaper1,exactshaper2);
shaper = digseq(exactshaper,deltaT);

