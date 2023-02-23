function [FIRy,FIRact,PRE,TFIR,RESID,s]=crmetric(a,b,c,d,T)
% Function CRMETRIC(a,b,c,d,T)
%       [FIRy,FIRact,PRE,TFIR,resid,s]=crmetric(a,b,c,d,T)
%	"Controller Redesign Metric"
%	Given a continuous system description [a,b,c,d], where
%	the first and second outputs are position and actuator
%	effort, computes the FIR components of the response for
%	the two outputs and the overall prefilter time period TFIR

C2DMMethod='tustin';

[z,p,k]=ss2zp(a,b,c,d,1); 	% for residual based analysis

z1=z(find(z(:,1)~=Inf),1);	% remove zeros at Inf if any
z2=z(find(z(:,2)~=Inf),2);	% remove zeros at Inf if any

% p=eig(a); for non residual based analysis

NyqT=pi/max(abs(p));

if NyqT < T 'Hit Nyquist Limit!', end

% Single out the poles that have a complex component and sort them;
% these are the poles that give rise to oscillations.  It may also be
% possible to use the prefilter approach to cancell the tail of the
% exponential envelope associated with a real pole if necessary.
CplxPoles=cplxpair(p(find(imag(p))));

% Select one pole from each complex pair (in second quadrant Q2)
Q2CplxPoles=CplxPoles(2:2:length(CplxPoles));

% Design a three impulse prefilter for each complex mode and combine
% them into an overall prefilter
Freq=abs(Q2CplxPoles)/(2*pi);
Zeta=-real(Q2CplxPoles)./abs(Q2CplxPoles);
if any(Zeta<0) 'Pole in R.H.S-Plane, System is unstable!', end
Prefilter=[1];

for n=1:length(Freq)
	Prefilter=conv(Prefilter,singer13(Freq(n),Zeta(n),T));
end


% Compute overall time period of the Prefilter
TFIR=T*(length(Prefilter)-1);

% Convert the continuous SSSystem to a discrete transfer function
[ad,bd,cd,dd]=c2dm(a,b,c,d,T,C2DMMethod);
[numd,dend]=ss2tf(ad,bd,cd,dd,1);

% Form the Prefilter Step response
PREStep=cumsum(Prefilter);

% Compute the FIR components of the system outputs
FIRy=  deconv(conv(PREStep,numd(1,:)),dend);
FIRact=deconv(conv(PREStep,numd(2,:)),dend);
PRE   =Prefilter;

%plot([PREStep FIRy PRE FIRact]);
%title('Prefilter*Step, FIRy, Prefilter, FIRact');


% Q2CplxPoles	% complex poles in the second quadrant
% p		% all poles
% Find the indices of all of the poles besides each given pole
% for use in the residual calculations.
[I,J]= find(p*ones(size(Q2CplxPoles))'~=ones(size(p))*Q2CplxPoles');
pind=reshape(I,length(p)-1,length(Q2CplxPoles));

s=Q2CplxPoles;

% Computation of the residuals assumes non repeated complex
% poles.  Only the complex poles in the second quadrant are
% considered.  The factor of two (2) in the formula below
% adds-in the effect of the conjugate pole.  The exp(-s*TFIR)
% factor accounts for the vibration decay that is completed
% at the time of the last prefilter pulse.  The 
% sum(exp(-s*PRE)) factor accounts for the gain of the
% prefilter.  The last term is the classic residual computation
% for a dynamic system model that inculdes only order one poles.
% The subscripts (1) refer to the transfer function of the output
% y (position of mass(1)); (2) refers to the actuator input level.

PREt=T*[0:length(PRE)-1]'; % time corresponding to each pulse of the
                           % Prefilter

% 10 percent perturbation of the poles in the Re and Im directions
s=[s;s+0.1*real(s);s+0.1*i*imag(s);s-0.1*real(s);s-0.1*i*imag(s)];

F1=abs(2*exp(TFIR*real(s')));
F2=abs(sum(PRE*ones(size(s')).*exp(-PREt*s')));
F3=abs(k(1)*prod( ones(size(z1(:,1)))*s' - z1(:,1)*ones(size(s')) ));
F4=abs(prod(ones(length(p)-1,1)*s'- ...
      reshape(p([pind pind pind pind pind]),length(p)-1,length(s))));

RESID=F1.*F2.*F3./F4;
