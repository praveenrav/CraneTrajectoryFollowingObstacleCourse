function list = sensplot_bode(seq,d1,d2,zeta,points)

% sensplot  Plot the residual over range of frequencies
%
% list = sensplot(seq,fmin,fmax,zeta,points)
%
% seq is the shaping sequence
% fmin is the low end of the frequency range
% fmax is the high end of the frequency range
% zeta is the damping ratio of the system
% points is the number of points to calculate
seq;
freqrange = logspace(d1,d2,points);
%range = length(freqrange);
%df = (fmax-fmin)/points;
fmin = freqrange(1);
[rows,cols]=size(seq);
tn=seq(rows,1);
% the vibration percentage formulation is:
%  t(i) is seq(i,1);
%  A(i) is seq(i,2);
%  tn is seq(num_of_rows_in_seq,1)
freq = fmin;
for nn=1:points-1,
  sintrm = 0;
  costrm = 0;
  df = freqrange(nn+1)-freqrange(nn);
  freq = (freq + df);
  for i=1:rows,
		sintrm = sintrm + seq(i,2)*exp(zeta*freq*seq(i,1))*cos(freq*sqrt(1-...
zeta^2)*seq(i,1));
        costrm = costrm + seq(i,2)*exp(zeta*freq*seq(i,1))*sin(freq*sqrt(1-...
zeta^2)*seq(i,1));
   end

  list(nn+1,1) = freq;
  list(nn+1,2) = exp(-zeta*freq*tn)*sqrt(sintrm^2+costrm^2);
end
figure
list(:,1) = freqrange';
list(:,3) = 20*log10(list(:,2));
semilogx(list(:,1),list(:,3))


