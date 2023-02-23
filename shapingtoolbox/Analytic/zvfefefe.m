function [shap]=ZVFEFEFE(w,alpha,xd)%shap=ZVFETOFE(w,alpha,xd)%Generate a shaper for rest-to-rest slewing%The first three impulses acheive FE acceleration with no residual vibration%The middle 2 impulses switch the deflection from compression to extension% so that the system may be slowed down.  The transition is made without residual% by making the two -1 impulses one half cycle apart%The last three impulses bring the system to rest and are a mirror of the first 3.% w = frequency in radians% alpha = force-to-mass ratio (Umax/M)% xd = desired slew distancetau=2*pi/w;          %system period%Calculate impulse timest1=0;t2=pi/(3*w);t3=2*t2;t4=-tau/12+sqrt((tau/12)^2+xd/alpha);t5=t4+pi/w;t6=t5+t4-t3;t7=t5+t4-t2;t8=t5+t4;t=[t1 t2 t3 t4 t5 t6 t7 t8];amps=[1 -1  1 -1 -1  1 -1 1];%min slew distance is tau^2*alpha/6if xd<(tau^2*alpha/6)   	fprintf('slew distance too short\n')end                   shap=[t' amps'];shap = seqsort(shap);     %sort the shaper because t6 could be less than t5