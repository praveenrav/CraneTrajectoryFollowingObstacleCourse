function [ssl,ssh,ss]=senscalc2(shaper,fmin,fmax,zeta,senslimit,points)
% Calculate insensitivity of a single shaper.
% The frequency of concern should be centered between fmin and fmax.
%  [ssl,ssh,ss]=senscalc2(shaper,fmin,fmax,fc,zeta,senslimit,points)
%  Differs from senscalc by computing high and low sides of insensitivity
%  fmin=starting freq of the sensitivity curve (The sens curve must be > 
%  senslimit @ this pt.)
%  fmax=ending pt. of sens. curve ""
%  fc=center frequency
%  senslimit=insensitivity level
%  fc=center frequency
fc=(fmin+fmax)/2;
senslimit=1.01*senslimit; %Allows for numerical errors
list=sensplot(shaper,fmin,fmax,zeta,points,0);

j=find(list(:,1)>=fc);  % finds elements = center freq in vector
jm=min(j);  % finds minimum index of center frequency
k=jm;       % counter for upper limit
kk=jm;      % counter for lower limit

while list(k,2)<=1.01*senslimit & (k <= length(list)-1), %kick out if transition not found
	k=k+1;
end;
upper=list(k-1,1);  %upper = upper freq that crosses insens limit

while list(kk,2)<=1.01*senslimit & (kk <= length(list)-1), %kick out if transition not found
	kk=kk-1;
end;
lower=list(kk+1,1); %lower =lower freq that crosses insens limit

ss=(upper-lower)/fc;  %normalize the insensitivity
ssh=(upper-fc)/fc;
ssl=(fc-lower)/fc;
