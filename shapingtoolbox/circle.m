function r=circleplot(p);
% CIRCLE.M
% plots the root locations of the polynomial around in the unit circle
figure(1)
clg
axis('equal')
plot(roots(p))
title('Root locations around the unit circle')
t=0:0.1:2*pi;
x=cos(t);
y=sin(t);
hold
plot(x,y);
