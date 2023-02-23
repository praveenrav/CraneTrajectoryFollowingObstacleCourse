function seq = DIGEI5(dt,freq,zeta,vlim)

% seq = DIGEI5(dt,freq,zeta,vlim)
%
% Whit Rappole
% Convolve, Inc.
% October 14, 1993
%
% © Copyright, 1993, Convolve, Inc.
% All Rights Reserved
%
% Find an exact digital Extra-Insensitive shaper.
% Uses matrix inversion technique.
%
% Parameters:
%  dt is the time step, sec.
%  freq is the frequency, hz.
%  zeta is the damping ratio.
%  vlim is the vibration limit at freq. (0.00 < vlim < 1.00)
%
% Returns:
%  seq, the digital three impulse sequence,
%    with times in the first column and amps in the second.
%      times have units of 1/dt
%      amps have units of 1/4096
%

% Algorithm:
%
%  To find the digital time spacing, we use Bill's curve
%   fits for damped extra-insensitive sequences.
%  We use these time steps to find the exact solution.
%  Transform from freq,vlim form to f1, f2 form (needed for
%   the matrix equations) using Whit's undamped 2-mode, 
%   3-impulse sequences.
%
%
% Transform from vlim-freq to f1,f2
%   r = f2/f1, found for the undamped case.
%
r = pi/asin(sqrt(1/(1+vlim))) - 1;
f1 = 2*freq*sqrt(1-zeta^2)/(1+r);
f2 = f1*r;

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
CounterMax = round(1/(freq*dt*200)) + 5;
found_seq = 0;
ctr = 0;

%
% Calculate the guesses for the times of the sequence.
%
time2 = 1/(freq*sqrt(1-zeta^2));
time1 = 0.5000 + (0.4616 * vlim * zeta) + (4.262 * vlim * zeta * zeta) +  1.756 ...
* vlim * zeta * zeta * zeta + 8.578 * vlim * vlim * zeta - 108.6 * vlim * vlim *... 
zeta * zeta + 337.0 * vlim * vlim * zeta * zeta * zeta;

%
% Find the sequence for a given value of ctr.
%
while (found_seq == 0) & (ctr < CounterMax),

  %
  % Calculate the times of the discrete impulses. 
  %
  times = [0
       (floor(time2*time1/dt) - ctr)
       (floor(time2*time1/dt) + ctr + 1)
       (floor(time2/dt) - ctr)
       (floor(time2/dt) + ctr + 1)];
  %
  % The minimum sequence time is 4 time steps.
  %   (If we run into this threshold, it is silly
  %     to loop through for greater values of ctr)
  %   Set ctr = CounterMax - 1;
  %
  if times(5) < 4,
    times = [0;1;2;3;4];
    ctr = CounterMax - 1;
  end

  %
  % Set up the contstraint equation matrix.
  % Find the amplitudes (floating point) by inverting the
  %  matrix. 
  %
  Tlast = dt*times(5);
  for nn=1:5,
    
    % Find the floating point time.
    t = dt*times(nn);
  
    % Sum of amplitudes == 1 constraint.
    mat(1,nn) = 1;
  
    % Frequency one position constraints.
    e = exp(-2*pi*zeta*f1*(Tlast-t));
    b = 2*pi*f1*t*sqrt(1-zeta^2);
    mat(2,nn) = e * sin(b);
    mat(3,nn) = e * cos(b);
  
    % Frequency two position constraints.
    e = exp(-2*pi*zeta*f2*(Tlast-t));
    b = 2*pi*f2*t*sqrt(1-zeta^2);
    mat(4,nn) = e * sin(b);
    mat(5,nn) = e * cos(b);
  end
  
  % 
  % Invert the matrix to find amplitudes.
  %
  amps = inv(mat)*[1 0 0 0 0]';

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
  for nn=1:5,
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
  for nn=1:5,
    if amps(nn) ~= 0,
      n = n+1;
      seq(n,:) = [dt*times(nn),amps(nn)/4096];
    end
  end

end
