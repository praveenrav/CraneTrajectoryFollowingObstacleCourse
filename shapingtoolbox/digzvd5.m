function dseq = DigZVD5(dt,freq,zeta)

% seq = DigZVD5(dt,freq,zeta)
%
% Whit Rappole
% Convolve, Inc.
% October 7, 1993
%
% © Copyright, 1993, Convolve, Inc.
% All Rights Reserved
%
% Finds a digital ZVD shaper by linearizing
% the times to the nearest two time discrete time steps and
% then inverting the matrix of the original equations
%
% Parameters:
%  dt is the time step, sec.
%  freq is the frequency, hz.
%  zeta is the damping ratio.
%
% Returns:
%  seq, the digital three impulse sequence,
%    with times in the first column and amps in the second.
%      times have units of 1/dt
%      amps have units of 1/4096
%

%
% Calculate the times of the discrete impulses.
%
dtime = 1/(2*freq*sqrt(1-zeta^2));
times = [0.0
       floor(dtime/dt)
       (floor(dtime/dt) + 1)
       floor(2*dtime/dt)
       (floor(2*dtime/dt) +1)];

%
% Find the amplitudes (floating point) by inverting the
%  matrix.
%
Tlast = dt*times(5);
for nn=1:5,
  t = dt*times(nn);
  e = exp(-2*pi*zeta*freq*(Tlast-t));
  b = 2*pi*freq*t*sqrt(1-zeta^2);
  mat(1,nn) = 1;
  mat(2,nn) = e * sin(b);
  mat(3,nn) = e * cos(b);
  mat(4,nn) = t * e * sin(b);
  mat(5,nn) = t * e * cos(b);
end
amps = inv(mat)*[1 0 0 0 0]';


%
% Assemble the final sequence
%
n = 1;
for nn=0:times(5),
  dseq(nn+1) = 0;
  if (n<=5) & (nn==times(n)),
    dseq(nn+1) = amps(n);
    n=n+1;
  end
end

dseq = dseq';
