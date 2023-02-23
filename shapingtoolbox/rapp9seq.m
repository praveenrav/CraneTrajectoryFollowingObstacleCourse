function seq = Rapp9Seq(dt,f1,z1,f2,z2)

% seq = Rapp9Seq(dt,f1,z1,f2,z2)
%
% Whit Rappole
% Convolve, Inc.
% October 7, 1993
%
% © Copyright, 1993, Convolve, Inc.
% All Rights Reserved
%
% Find an exact digital sequence found with Rappole 2-modes,
%  5-impulse constraints.
% Uses matrix inversion technique.
%
% Parameters:
%  dt is the time step, sec.
%  f1 is the first mode frequency, hz.
%  z1 is the first mode damping ratio.
%  f2 is the second mode frequency, hz.
%  z2 is the second mode damping ratio.
%
% Returns:
%  seq, the digital sequence,
%    with times in the first column and amps in the second.
%      times have units of 1/dt
%      amps have units of 1/4096
%

%
% Sometimes the ratio between fsample and freq is
%  too large and negative impulses occur.
% To avoid this problem, we allow some flexibility
%  in the impulse timing (ctr).
% Start with ctr = 0.  Keep increasing ctr until
%  we have a sequence with no negative impulses.
% Set CounterMax to be about max flexibility of
%  5 counts per fsample/(freq*1000).
% If negative impulses still occur, then return a
%  null sequence [0 4096].
%
CounterMax = round(1/((f1+f2)*dt*100)) + 50;
found_seq = 0;
ctr = 0;

%
% Find the sequence for a given value of ctr.
%
while (found_seq == 0) & (ctr < CounterMax),

  %
  % Calculate the times of the discrete impulses. 
  %
  dtime = 1/(f1*sqrt(1-z1^2)+f2*sqrt(1-z2^2));
  times = [0
       (floor(dtime/dt) - ctr)
       (floor(dtime/dt) + ctr + 1)
       (floor(2*dtime/dt) - ctr)
       (floor(2*dtime/dt) + ctr + 1)
       (floor(3*dtime/dt) - ctr)
       (floor(3*dtime/dt) + ctr + 1)
       (floor(4*dtime/dt) - ctr)
       (floor(4*dtime/dt) + ctr + 1)];
  if ctr == 0,
    times(9)
  end

  %
  % The minimum sequence time is 4 time steps.
  %   (If we run into this threshold, it is silly
  %     to loop through for greater values of ctr)
  %   Set ctr = CounterMax - 1;
  %
  if times(9) < 8,
    times = [0;1;2;3;4;5;6;7;8];
    ctr = CounterMax - 1;
  end

  %
  % Set up the contstraint equation matrix.
  % Find the amplitudes (floating point) by inverting the
  %  matrix. 
  %
  Tlast = dt*times(9);
  for nn=1:9,
    
    % Find the floating point time.
    t = dt*times(nn);
  
    % Sum of amplitudes == 1 constraint.
    mat(1,nn) = 1;
  
    % Frequency one position and derivative constraints.
    e = exp(-2*pi*z1*f1*(Tlast-t));
    b = 2*pi*f1*t*sqrt(1-z1^2);
    mat(2,nn) = e * sin(b);
    mat(3,nn) = e * cos(b);
    mat(4,nn) = t * e * sin(b);
    mat(5,nn) = t * e * cos(b);
  
    % Frequency two position and derivative constraints.
    e = exp(-2*pi*z2*f2*(Tlast-t));
    b = 2*pi*f2*t*sqrt(1-z2^2);
    mat(6,nn) = e * sin(b);
    mat(7,nn) = e * cos(b);
    mat(8,nn) = t * e * sin(b);
    mat(9,nn) = t * e * cos(b);
  end
  
  % 
  % Invert the matrix to find amplitudes.
  %
  amps = inv(mat)*[1 0 0 0 0 0 0 0 0]';

  %
  % Check for negative impulses.
  %
  foo = sort(amps);
  if foo(1) >= 0,
    found_seq = 1;
  else
    ctr = ctr + 1;
  end
end

%
% If no sequence without negative impulses was found, 
%  return a null sequence.
%
if found_seq == 0,
  seq = [0 4096];
else
  %
  % Turn amplitudes into integers with sum 4096
  % 
  sum = 4096;
  for nn=1:9,
    amp = round(4096*amps(nn));
    sum = sum-amp;
    amps(nn) = amp;
  end
  
  %
  % If the rounding has made us lose a count add it to amp(1)
  %
  amps(1) = amps(1) + sum;
  
  %
  % Assemble the final sequence,
  %  eliminate impulses with amplitude 0
  %
  n = 0;
  for nn=1:9,
    if amps(nn) ~= 0,
      n = n+1;
      seq(n,:) = [times(nn),amps(nn)];
    end
  end

end
