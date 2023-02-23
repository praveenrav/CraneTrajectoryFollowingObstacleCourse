function seq = seqconv(seq1,seq2)

% SEQUENCECONVOLVE Convolve two continuous sequences together.
%
% seq = seqconv(seq1,seq2)
%
% Convolves two sequences together.  
% A Sequence is an n*2 matrix with impulse times (sec) in
% the first column and amplitudes in the second column.
% 
% Parameters: 
%  seq1, seq2 the two sequences to convolve together.
%
% Returns:
%  seq, the sequence resulting from the convolution.
%

index = 1;
tempseq = [];
for i=1:length(seq1),
  for j=1:length(seq2),
     tempseq(index,1) = seq1(i,1)+seq2(j,1);
     tempseq(index,2) = seq1(i,2)*seq2(j,2);
     index = index+1;
  end
end

seq = seqsort(tempseq);
