function [x,v,a,nd]=mdsizer(Dist,AccSeq,T)
% MDSIZER - Point to Point move profile based on a given Acceleration Pulse
%	[x,v,a,nd]=mdsizer(Dist,AccSeq,T)
%	For an AccSeq [1 1 1 ... 1 1 1], mdsizera generates a trapezoidal
%	velocity profile.
%
%   INPUTS:
%
%	Dist   - move distance
%       AccSeq - acceleration sequence
%	T      - sample period
%
%   OUTPUTS:
%
%	x - position
%	v - velocity
%	a - acceleration
%      nd - sample delay before start of second pulse.	
%
% NOTE: the derivation involved using the final value theorem and in
%       the model used, zero order holds were assumed.
%
% An arbitrary acceleration pulse is combined with a negative and delayed
% (by nd samples) version of the pulse to generate the overall
% acceleration profile.  If the desired move distance (dist) cannot be
% achieved with an integer delay (nd), then the delay is rounded up to
% the next integer value and the acceleration pulse scaled down to meet 
% the desired move distance (dist).  Note that for very short moves, (nd)
% approaches zero, and the length of the overall acceleration profile
% approaches that of the arbitrary acceleration pulse.  This function is
% designed to be used with acceleration pulses that have built in
% vibration cancellation and this is why the pulse shape is not modified 
% in the case of short moves.
% Note, the length of the sequences [x], [v], and [a] are different due 
% to a pole/zero cancellation that occurs during integration.

% compute non-integer delay time for second jerk (& acceleration) pulse
n=Dist/(T*T*sum(AccSeq));

% round up to nearest integer delay.
nd=ceil(n);

% scale down jerk to compensate for increased (rounded up)
% delay and generate composite sequence
a=(n/nd)*([AccSeq zeros(1,nd)] - [zeros(1,nd) AccSeq]);
v=T*cumsum(a);
v=v(1:length(v)-1); % This sequence is shorter because of a pole/zero
                    % cancellation that occurs during integration
x=T*cumsum(v);
