function r=circlep(p);
% CIRCLEP.M
% plots the root locations of the polynomial around in the unit circle
p=p/sum(p); % normalize for a DC magnitude of 1
figure(1);
clg;
axis('equal');
plot(roots(p),'r+');
title('Root locations around the unit circle');
gridspacing=4*length(p);
t=linspace(0,2*pi,3*gridspacing);
x=cos(t);
y=sin(t);
hold;
axis('equal');
plot(x,y,'.');
pause;
figure(2);
clg
plot(t,abs(polyval(p,x+i*y)));
ax=axis;
axis([0 pi 0 ax(1,4)]);
title('Prefilter Magnitude up to the Nyquist Rate (pi)');
pause;
figure(3);
z=cplxgrid(gridspacing);
cplxmap(z,abs(z.^(length(p)-1).*polyval(p,z)));
title('Modified Prefilter Magnitude Plot');
