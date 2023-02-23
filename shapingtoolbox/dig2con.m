function cseq = dig2con(dseq,dt)

% DIG2CON Put a digital sequence in continuous sequence form.
%
% cseq = dig2con(dseq,dt)
%
% A continuous sequence is an n*2 matrix with times (sec) in
%  the first column and amplitudes in the second column.
% A digital sequence as a vector of amplitudes, where each
%  value corresponds to a time step.  The vector has length
%  n = Time_Of_Last_Impulse/dt.
%
% Parameters:
%  dseq, the digital sequence.
%  dt, the time step for the digital sequence.
% 
% Returns:
%  cseq, the continuous sequence.
%

index = 1;
for nn=1:length(dseq),
  if dseq(nn)==0,
    %nothing
  else
    cseq(index,:) = [(nn-1)*dt dseq(nn)];
    index = index+1;
  end
end
