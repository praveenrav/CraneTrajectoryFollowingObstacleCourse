function [T,P,V] = trapprof(endpos,curpos,amax,vmax,dt,steps)

% [T,P,V] = trapprof(endpos,curpos,amax,vmax,dt,steps)
%
% Whit Rappole
% Convolve, Inc.
% February 1, 1993
%
% c Copyright, 1993, Convolve, Inc.
% All Rights Reserved
%
% Generate position and velocity commands for a trapezoidal
% velocity profile.
%
% Parameters:
% endpos - Final position desired (in)
% curpos - Current position (in)
% amax - Maximum allowable acceleration (in/sec^2)
% vmax - Maximum allowable velocity (in/sec)
% dt - Time step for command string.
% steps - Total number of steps for command.
%
% Returns:
% T - Vector of times (sec)
% P - Vector of position commands (in)
% V - Vector of velocity commands (in/sec)
% T, P, and V are all of length STEPS
%
% If the desired motion requires more than STEPS time steps,
% TRAPEZOIDPROFILE returns [].
%


vel = 0;
pos = curpos;
AccSteps = ceil(vmax/(amax*dt));
des = endpos - curpos;  

if des<0.0,
    des = -des;
    neg = 1;
else
    neg = 0;
end

if des==0.0,
    SquareSteps = 0;
    ActVelMax = 0.0;
    AccSteps = 0;
    ActAcc = 0.0;
elseif des<AccSteps*dt*vmax,
    SquareSteps = ceil(sqrt(des/(amax*dt*dt)));
    AccSteps = SquareSteps;
    ActAcc = des/(AccSteps*AccSteps*dt);
else
    SquareSteps = ceil(des/(vmax*dt));
    ActVelMax = des/SquareSteps;
    AccSteps = ceil(des/(amax*dt*SquareSteps*dt));
    ActAcc = ActVelMax/(AccSteps*dt);
end

if neg==1,
    ActAcc = -ActAcc;
end

TotalSteps = SquareSteps + AccSteps;

if TotalSteps>steps,
  com = [];
else
  for i=1:steps,
    pos = pos+vel*dt;
    if i<=AccSteps, 
      vel = vel+ActAcc;
    elseif i<=SquareSteps,
      vel = vel;
    elseif i<=SquareSteps+AccSteps,
      vel = vel-ActAcc;
    else
      vel = 0.0;
				end
    P(i) = pos;
    V(i) = vel;
  end
end

T = (0:dt:(steps-1)*dt)';
P = P';
V = V';

