function dseq = digseq(seq,step)

% digseq - Whit Rappole
% DIGITIZESEQ Map a sequence onto digital timing loop
% dseq = digseq(seq,step)
%
% Uses a linear extrapolation to split each continuous
% impulse into two digital impulses

dseq = zeros(round(seq(length(seq),1)/step)+2,1);
for nn=1:length(seq),
			index = floor(seq(nn,1)/step);
			woof = (seq(nn,1)-index*step)/step;
			dseq(index+2) = dseq(index+2)+woof*seq(nn,2);
			dseq(index+1) = dseq(index+1)+seq(nn,2) - woof*seq(nn,2);
end

while dseq(length(dseq)) == 0,
		dseq = dseq(1:(length(dseq)-1));
end

