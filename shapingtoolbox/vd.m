function [x_tot,y_tot]=vd(a,t,freq,zeta)
%function vd(amp,time,freq,zeta)
% or vd(exact_shaper,freq,zeta)
% creates a vector diagram based on the
% provided f (natural frequency in hertz)
% and the times and amplitudes of the pulses
%
% returns the residual vibration x and y coordinates
%
%  Mapping is ->  theta = w*time
%  So each vector amp[i],time[i] has a corresponding
%  position in the vector diagram.
%
%  Currently only handles positive vectors amp = [0 to 1]
if nargin == 3, amp=a(:,2); time=a(:,1); f=t; zeta=freq; end
if nargin == 4, amp=a; time=t; f=freq; zeta=zeta; end
if ((nargin >4) | (nargin<3)), error('need 3 or 4 arguments'); end

if (([1,1] ~= size(f)) | ([1,1] ~= size(zeta))),
	error('Can only use one frequency to plot');
end

x_tot=0; y_tot=0;

w=2*pi*f;

t_len=length(time); 

for i=1:length(amp),
    hold on;
    theta=w*time(i);
    amp(i)=amp(i)*exp(-zeta*w*(time(t_len)-time(i)));
    xm(i)=amp(i)*cos(theta); ym(i)=amp(i)*sin(theta);
    x_tot=x_tot+xm(i); y_tot=y_tot+ym(i);
end


% do all the plotting out here:
figure(1); clg; hold off;
axis([-1 1 -1 1]); 
wt_axis=linspace(0,2*pi,100);
plot(cos(wt_axis),sin(wt_axis),'b-');
hold on;
% unknown command on mac dbstop if error;
plot([-1 1],[0 0],'b:');
plot([0 0],[-1 1],'b:');
for i=1:length(xm),
	if(amp(i)<0),
		col='r:'; 
	else, 
		col='g-'; 
	end
	plot([0 xm(i)],[0 ym(i)],col);
end
axis off; axis('square');
title(sprintf('Vector diagram with f = %f Hz & Zeta = %f',f,zeta));


%  Now, plot the history of the resultants, or the single resultant
if (length(x_tot)>1),
plot(x_tot,y_tot,'y-');
else,
plot([0 x_tot],[0 y_tot],'y-');
end
