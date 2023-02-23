function num = shapres(seq,freq,zeta)

% shapres  Calculate the residual for a given freq and zeta
%
% num = shapres(seq,freq,zeta)
%
% seq is the sequence being used
% freq is the frequency of the system, Hz.
% zeta is the damping ratio
%

num = sqrt(s_sinsum(seq,freq,zeta)^2 + s_cossum(seq,freq,zeta)^2);
