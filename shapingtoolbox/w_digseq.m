function dseq = W_DigSeq(seq,step,freq,zeta)

% W_DIGSEQ Map a sequence onto digital timing loop
% dseq = W_DigSeq(seq,step,freq,zeta)
%
% Uses Watanabe's formula to split each continuous
% impulse into two digital impulses
% It is derived for Singer three impulse sequences.
%
% freq is the natural frequency in Hz.
% zeta is the damping ratio
% step is the time step of the timing loop, in sec.
% seq is the continuous sequence, an n x 2 matrix of 
%     times and amplitudes
% 

wn = freq*2*pi;
wd = wn*sqrt(1-zeta^2);
den = sin(step*wd);

dseq = zeros(round(seq(length(seq),1)/step),1);
for nn=1:length(seq),
			index = floor(seq(nn,1)/step);
   tk = index*step;
   tkk = (index+1)*step;
   tj = seq(nn,1);
			dseq(index+2) = seq(nn,2)*exp(-zeta*wn*(tkk-tj))* ...
								sin(wd*(tj-tk))/den;
			dseq(index+1) = seq(nn,2)*exp(-zeta*wn*(tk-tj))* ...
	sin(wd*(tkk-tj))/den;
end

% If the last impulse is zero, eliminate it.
if dseq(length(dseq)) == 0,
		dseq = dseq(1:(length(dseq)-1));
end

% Get rid of very small impulses.
for(nn=1:length(dseq)),
  if dseq(nn) < 0.0001,
    dseq(nn) = 0;
  end
end

% This is the part that Murphy and Watanabe forgot in 
%  their paper:  the sequency must be renormalized to 1.
den = sum(dseq);
for(nn=1:length(dseq)),
  dseq(nn) = dseq(nn)/den;
end

