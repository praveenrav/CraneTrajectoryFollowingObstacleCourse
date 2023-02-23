function sortedseq = seqsort(unsortedseq)

% SEQUENCESORT  Sort a continuous sequence into correct 
%  order and combine impulses at the same time.
%
% sortedseq = seqsort(unsortedseq)
%
% A sequence is an n*2 matrix with times (sec) in the first
%  column and amplitudes in the second column.
%
% PARAMETERS:
%  unsortedseq is the continuous sequence to sort
%
% RETURNS:
%  sortedseq, the sorted sequence.
%

[badsortseq,sortingindex] = sort(unsortedseq);

for nn=1:length(unsortedseq),
  goodsortseq(nn,1) = badsortseq(nn,1);
  goodsortseq(nn,2) = unsortedseq(sortingindex(nn,1),2);
end


% Combine impulses with the same times
% (creates seq from goodsortseq)

idx = 1;
seq = [];
seq(1,:) = goodsortseq(1,:);
for nn=2:length(goodsortseq),
  if    goodsortseq(nn,1)==seq(idx,1),
		  seq(idx,2) = seq(idx,2)+goodsortseq(nn,2);
  else
    idx = idx+1;
    seq(idx,:) = goodsortseq(nn,:);
  end
end


% Eliminate any impulse with amplitude less than 0.0001
% (creates sortedseq from seq)

idx = 1;
for nn=1:length(seq),
  if    abs(seq(nn,2))>=0.0001,
    sortedseq(idx,:) = seq(nn,:);
    idx = idx+1;
  end
end

