function dvd(a,freq,zeta,dt)
%function dvd(amp,freq,zeta,dt)
% or vd(digital_shaper,freq,zeta,dt)
% creates a vector diagram based on the
% provided f (natural frequency in hertz)
% and the time step (dt) and amplitudes of the pulses
%
%  Mapping is ->  theta = w*time
%  So each vector amp[i],time[i] has a corresponding
%  position in the vector diagram.
%
%  Currently only handles positive vectors amp = [0 to 1]
clg;
if nargin == 4, amp=a; time=0:dt:(length(amp)-1)*dt; f=freq; zeta=zeta; end
if ((nargin >4) | (nargin<4)), error('need 4 arguments'); end

if (([1,1] ~= size(f)) | ([1,1] ~= size(zeta))),
	error('Can only use one frequency to plot');
end

x_tot=0; y_tot=0;

w=2*pi*f;

figure(1);
hold off;
axis([-1 1 -1 1]); 
axis('square');
wt_axis=linspace(0,2*pi,100);
plot(cos(wt_axis),sin(wt_axis),'y-');
hold on;
plot([-1 1],[0 0],'y:');
plot([0 0],[-1 1],'y:');
dt_space=(0:w*dt:2*pi);
for k=1:length(dt_space),
plot([0 cos(dt_space(k))],[0 sin(dt_space(k))],'b:');
end

% shift all impulses in time to be relative to the last impulse
t_len=length(time); 

for i=1:length(amp),
    hold on;
    theta=w*time(i);
    amp(i)=exp(zeta*w*(time(t_len)-time(i)))*amp(i);
    xm(i)=amp(i)*cos(theta); ym(i)=amp(i)*sin(theta);
    x_tot=x_tot+xm(i); y_tot=y_tot+ym(i);
    figure(1);
    plot([0 xm(i)],[0 ym(i)],'r-');
    axis([-1 1 -1 1]);
    axis('square');
title(sprintf('Sequence plotted on a vector diagram where f = %f Hz',f));
end


%  Now, plot the history of the resultants, or the single resultant
if (length(x_tot)>1),
plot(x_tot,y_tot,'g-');
else,
plot([0 x_tot],[0 y_tot],'g-');
end
