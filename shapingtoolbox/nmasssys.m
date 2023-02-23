function [a,b,c,d]=nmasssys(m,k,gains)
% NMASSSYS  [a,b,c,d]=nmasssys(m,k,gains)
% 	Creates a state space model of an n mass system and returns
%	the [a,b,c,d] matrices of the system.
%	[m] is a vector of masses (the input force acts on mass m(1)).
%	[gains] is a vector of feedback gains, (+) for neg feedback;
%	    to build a model without feedback use a null matrix []
%           for gains.
%	    
%	[k] is a vector of springs between the masses; k(1) is 
%	    between masses m(1) and m(2); a picture follows:
%
%	F-->m(1)--k(1)--m(2)--k(2)--m(3)--...
%
%	System output y = [x1 act]'
%
%	Where: 	act - force output of ideal actuator acting on mass 1;
%                     the transfer function of the actuator is 1/1.
%		x1  - position of the mass being pushed by act (m[1]).
%
%	If "gains" exists, then negative feedback of the states
%       x1dot,x1,x2dot,x2,... is included in the state space model.

% Check to make sure that there is one spring to go between each
% adjacent pair of masses.
if length(m)-1 ~= length(k) 
   'Warning: There should be one less spring than there are masses.', 
end

nmass=length(m);
nstates=nmass*2;

% Build up the [a] matrix.
a=zeros(nstates,nstates);
% Add entries for d(xi)/dt = xidot.
for ind=1:nmass
  a(2*ind,2*ind-1)=1;
end
% Add entries corresponding to spring forces.
for ind=1:length(k)
  row=2*ind-1;
  col=2*ind;
  a(row,col)  =  a(row,col)    -k(ind)/m(ind);
  a(row,col+2)=  a(row,col+2)  +k(ind)/m(ind);
  a(row+2,col)=  a(row+2,col)  +k(ind)/m(ind+1);
  a(row+2,col+2)=a(row+2,col+2)-k(ind)/m(ind+1);
end
% Include feedback of states if feedback gains are provided.
if ~isempty(gains)
   a(1,:)=a(1,:)-gains/m(1);
end

% Build up the [b] matrix.
b=zeros(nstates,1);
% Add actuator force input on mass m(1).
b(1,1)=1/m(1); 
% Include a scale factor to compensate for non-unity feedback of 
% mass positions.
if ~isempty(gains) 
   b(1,1)=b(1,1)*sum(gains(2:2:nstates)); % even states are the 
					  % positions of the masses
end

% Build up the [c] matrix.
c=zeros(2,nstates);
% set output y(1) to the position of m(1) (state(2)).
c(1,2)=1;
% set output y(2) to the feedback from the states.
if ~isempty(gains)
   c(2,:)=-gains; % force ouput of ideal actuator sans reference input r.
end

d=zeros(2,1);
d(2,1)=1;  % include term for reference input r.
% Include a scale factor to compensate for non-unity feedback of
% mass positions.
if ~isempty(gains) 
   d(2,1)=d(2,1)*sum(gains(2:2:nstates)); % even states are the 
					  % positions of the masses
end

% I put the following statement in for your viewing pleasure and as 
% a reminder to check the stability of the (closed loop) system.
%[num,den]=ss2tf(a,b,c,d,1);pzmap(num(1,:),den)
