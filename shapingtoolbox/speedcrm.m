function [resy,Q2CxPoles]=speedcrm(PRE,T,a,b,c,d)
% SPEEDCRM Speedy version of the controller redesign metric used
%	to compute the residuals associated with residual vibration
%	PRE - given prefilter
%	T   - sample period
% a,b,c,d   - state space system description
%
%     resy  - vector of residuals for each Q2CxPole for output y.
% Q2CxPoles - vector of complex poles in the 2nd quadrant
%
% [resy,Q2CxPoles]=speedcrm(PRE,T,a,b,c,d)
%
% This function is on the fringe of numerical stability, speedy,
% and compact.  The parameter delta is how far away from the 
% actual pole that the "residual" is being evaluated.  If we get 
% too close to the pole, we have a 0/0 numerical situation; if
% we get too far away from the pole we no longer approximate the 
% residual.  The delta used here (1e-7) was determined by varing
% delta from 1E-2 to 1E-12 without a change in the printed
% output (0.0000 accuracy).  1e-7 is midway between the two 
% values.

delta=1E-7;
N=length(PRE)-1;

poles=eig(a);
NyqT=pi/max(abs(poles));
if NyqT < T 'Hit Nyquist Limit!', return; end
CplxPoles=cplxpair(poles(find(imag(poles))));
Q2CxPoles=CplxPoles(2:2:length(CplxPoles));

ii=0;
for p=Q2CxPoles'
	ii=ii+1;
	Z=exp(T*p);
	p1=p+delta;
	p2=p-delta;
	PRER=polyval(PRE,Z);

	%res=abs((p1-p)*PRER*(c*inv(p1*eye(size(a))-a)*b+d)+...
	%        (p2-p)*PRER*(c*inv(p2*eye(size(a))-a)*b+d))/2;


	% non-averaging approach
        res=abs((p1-p)*PRER*(c*inv(p1*eye(size(a))-a)*b+d));
	resy(ii,1)=res(1);
	resa(ii,1)=res(2);
end
