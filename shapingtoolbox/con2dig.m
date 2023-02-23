function dseq = con2dig(cseq,dt)

% con2dig CONTINUOUS2DIGITAL Put a continuous sequence in digital
%  sequence form.
%
% dseq = con2dig(cseq,dt)
%
% A continuous sequence is an n*2 matrix with times (sec) in
%  the first column and amplitudes in the second column.
% A digital sequence as a vector of amplitudes, where each
%  value corresponds to a time step.  The vector has length
%  n = Time_Of_Last_Impulse/dt.
%
% Parameters:
%  cseq, the continuous sequence.  Assumes that the 
%   continuous sequence is spaced at intervals of dt.
%  dt, the time step for the digital sequence.
% 
% Returns:
%  dseq, the digital sequence.
%
% See also DigitizeSeq, Digital2Continuous
%

errflag = 0;
for nn=1:length(cseq),
  if abs(round(cseq(nn,1)/dt)-cseq(nn,1)/dt)<0.0001,
    cseq(nn,1) = round(cseq(nn,1)/dt) + 1;
  else
    errflag = 1;
    dseq = [];
    break;
  end
end

index = 1;
if errflag == 0,
  for nn=1:cseq(length(cseq),1),
    if nn==cseq(index,1),
      dseq(nn) = cseq(index,2);
      index = index+1;
    else
      dseq(nn) = 0;
    end
  end
end

dseq = dseq';
