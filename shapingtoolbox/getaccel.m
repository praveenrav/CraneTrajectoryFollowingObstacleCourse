function Accel = getaccel(seq,vmax,amax,des,dt)

% getaccel(seq,vmax,amax,des,dt)
%
% Whit Rappole
% Convolve, Inc.
% February 1, 1993
%
% c Copyright 1993, Convolve, Inc., All Rights Reserved.
%
% Get an acceleration matrix for calculating shaped
% trapezoidal trajectories using changing accelerations.
%
% Parameters:
% seq - Digital Sequence in Continuous Form
% vmax - Maximum Velocity (in/sec)
% amax - Maximum Acceleration (in/sec^2)
% des - Desired Position (in)
% dt - Time step (sec/step)
%
% Returns:
% Accel - A Matrix with Time Steps in the first column 
%    and Accelerations in the second column.
%
% See also acc2trap, dig3imp
%


% Parameters for the trapezoidal profile
Bsteps = ceil(des/(vmax*dt))
actvmax = des/(Bsteps*dt);
Asteps = ceil(actvmax/(amax*dt))
actaccel = actvmax/(dt*Asteps);

% Change the sequence to time steps and stepacceleration
seq(:,1) = round(seq(:,1)/dt);
seq(:,2) = seq(:,2)*actaccel*dt;

len = length(seq);
for nn=1:len,
  foo(nn,:) = seq(nn,:);
  foo(len+nn,:)   = [Asteps+foo(nn,1)        -seq(nn,2)];
  foo(2*len+nn,:) = [Bsteps+foo(nn,1)        -seq(nn,2)];
  foo(3*len+nn,:) = [Asteps+Bsteps+foo(nn,1)  seq(nn,2)];
end

mat = seqsort(foo);

sum = 0;
for nn=1:length(mat),
  sum = sum + mat(nn,2);
  Accel(nn,:) = [mat(nn,1) sum];
end
