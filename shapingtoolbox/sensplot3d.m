function [f,z,vib] = sensplot3D(seq,flo,fhi,fpts,zlo,zhi,zpts)

%sensplot3D.m - Bill Singhose
%[f,z,vib] = sensplot3D(seq,flo,fhi,fpts,zlo,zhi,zpts)
% Calculate and plot a 3D sensitivity curve
% 3 dimensions:frequency, damping, and residual vib amplitude
% seq is the input shaper
% flo is the low end of the frequency range
% fhi is the high end of the frequency range
% zlo is the low end of the damping range
% zhi is the high end of the damping range
% fpts is the # of pts to calculate along the frequency axis
% zpts is the # of pts to calculate along the damping axis  

[rows,cols]=size(seq);
tn=seq(rows,1);           %final time
df = (fhi-flo)/fpts;
dz = (zhi-zlo)/zpts;
f=flo:df:fhi;
z=zlo:dz:zhi;

%Loop through damping ratio
for m=0:zpts,
zeta = (zlo +m*dz);

 for n=0:fpts,
  sintrm = 0;
  costrm = 0;
  freq = (flo + n*df)*2*pi;
        for i=1:rows,
          sintrm = sintrm+...     
            seq(i,2)*exp(zeta*freq*seq(i,1))*cos(freq*sqrt(1-zeta^2)*seq(i,1));
      costrm = costrm+...
        seq(i,2)*exp(zeta*freq*seq(i,1))*sin(freq*sqrt(1-zeta^2)*seq(i,1));
     end
  vib(n+1,m+1) = exp(-zeta*freq*tn)*sqrt(sintrm^2+costrm^2);
 end

end
vib=vib';
surf(f,z,vib);
grid on                  