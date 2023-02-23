function list = sensplot(seq,fmin,fmax,zeta,points,plotflag)

% sensplot  Plot the residual over range of frequencies
%
% list = sensplot(seq,fmin,fmax,zeta,points,plotflag)
%
% seq is the shaping sequence
% fmin is the low end of the frequency range
% fmax is the high end of the frequency range
% zeta is the damping ratio of the system
% points is the number of points to calculate
% plotflag plots the data if plotflag=1 
seq;
df = (fmax-fmin)/points;

[rows,cols]=size(seq);
tn=seq(rows,1);
% the vibration percentage formulation is:
%  t(i) is seq(i,1);
%  A(i) is seq(i,2);
%  tn is seq(num_of_rows_in_seq,1)
for nn=0:points,
  sintrm = 0;
  costrm = 0;
  freq = (fmin + nn*df)*2*pi;
  for i=1:rows,
		sintrm = sintrm + seq(i,2)*exp(zeta*freq*seq(i,1))*cos(freq*sqrt(1-...
zeta^2)*seq(i,1));
        costrm = costrm + seq(i,2)*exp(zeta*freq*seq(i,1))*sin(freq*sqrt(1-...
zeta^2)*seq(i,1));
   end

  list(nn+1,1) = freq/2/pi;
  list(nn+1,2) = exp(-zeta*freq*tn)*sqrt(sintrm^2+costrm^2);
end
if plotflag==1
plot(list(:,1),list(:,2))
end

