function [PN,wn] = normp(P1)
% [PN,wn]=NORMP(P1)
% Normalizes a characteristic polynomial such
% that there are decending powers of S from the left and decending
% powers of W from the right (rightmost and leftmost coefficients are
% always unity.  Returns the normalized polynomial and the WN used in
% the normalization.  Polynomials should be entered such that the
% coefficient of the highest power of S is unity.
l1=length(P1);
wn=P1(1,l1)^(1/(l1-1));
SCALE= wn .^ [0:-1:-(l1-1)];
PN=P1 .* SCALE;
