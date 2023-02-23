function [shap]=ZVDFE2ZVFEFE(w,alpha,xd)%shap=ZVDFE2ZVFEFE(w,alpha,xd)%Generate a shaper for rest-to-rest slewing%The first 5 impulses acheive FE acceleration with no residual vibration%The middle 5 impulses switch the deflection from compression to extension % in a FE manner using 2 ZV switches% so that the system may be slowed down.  The transition is made without residual%The last 5 impulses bring the system to rest and are a mirror of the first 5.% w = frequency in radians% alpha = force-to-mass ratio (Umax/M)% xd = desired slew distancetau=2*pi/w;          %system period%Calculate impulse timest1=0;t2=0.562424/w;t3=2.301115/w;t4=2*t3-t2;t5=2*t3;t8=t3+sqrt(2*t2^2-4*t2*t3+tau^2/12+xd/alpha);t6=t8-tau/3;t7=t8-tau/6;  t9=2*t8-t7;t10=2*t8-t6;t11=2*t8-t5;t12=2*t8-t4;t13=2*t8-t3;t14=2*t8-t2;t15=2*t8;t=[t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15];amps=[1 -1 1 -1 1 -1 1 -2 1 -1 1 -1 1 -1 1];%min slew distance is alpha*(t3^2+2*t3*tau/3-2*t2^2+4*t2*t3-tau^2/36)if xd<alpha*(t3^2+2*t3*tau/3-2*t2^2+4*t2*t3-tau^2/36)	fprintf('slew distance too short\n')end                   shap=[t' amps'];shap = seqsort(shap);     %sort the shaper because t6 could be less than t5