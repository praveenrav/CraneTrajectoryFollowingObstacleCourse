function [shaper,exactshaper] = NEGEI(f,zeta,V,P,deltaT)

% NEGEI(f,zeta,V,PdeltaT)-- Bill Singhose
% Generates a negative Extra-Insensitive shaper for 1 mode.
%
% Returns the digital sequence by default, and
% the exact sequence as the second variable:
% eg: to generate the exact shaper, use:
%		  [dig_shaper,exact_shaper]=singer13(f,z,0.01)
%	note:  the 0.01 is ignored for the exact shaper and 
%	       dig_shaper can be ignored
%
%  to Return the digital sequence, use:
%		dig_shaper=singer13(f,z,0.001)
%
% f - frequency (Hz) of vibration being controlled.
% zeta - damping ratio of vibration being controlled.
% V - Vibration Limit
% P - Input Peak
% deltaT - time spacing at which input to system is updated.
%
% This function generates the exact sequence and then uses
% DigitizeSeq to convert the exact sequence to digital format.

fd=sqrt(1-zeta^2)*f;
Td=1/fd;

if V==0.05,
   if P ==1,
      t2=(0.15687 + .24004*zeta + .20367*zeta^2)*Td;   
      t3=(0.28151 + .10650*zeta + .0928*zeta^2)*Td;
      t4=(0.63431 + .33886*zeta - .12776*zeta^2)*Td;
      t5=(0.68414 + .18236*zeta - .000839*zeta^2)*Td;
	  a1=1;a2=-2;a3=2;a4=-2;a5=2;
   elseif P ==2,
      t2=(0.11955 + .16127*zeta + .05206*zeta^2)*Td;   
      t3=(0.26356 + .12551*zeta - .03963*zeta^2)*Td;
      t4=(0.49804 + .15508*zeta - .24101*zeta^2)*Td;
      t5=(0.56866 + .04558*zeta - .18732*zeta^2)*Td;
	   a1=2;a2=-4;a3=4;a4=-4;a5=3;
   else
      t2=(0.10219 + .12192*zeta + .01197*zeta^2)*Td;   
      t3=(0.24639 + .11404*zeta - .07655*zeta^2)*Td;
      t4=(0.44526 + .11468*zeta - .2223*zeta^2)*Td;
      t5=(0.51719 + .02439*zeta - .19225*zeta^2)*Td;
	   a1=3;a2=-6;a3=6;a4=-6;a5=4;
   end
elseif V==0.1,
   if P ==1,
      t2=(0.16136 + .24772*zeta + .31367*zeta^2)*Td;   
      t3=(0.28547 + .11044*zeta + .19967*zeta^2)*Td;
      t4=(0.63719 + .33687*zeta - .14612*zeta^2)*Td;
      t5=(0.68919 + .17941*zeta - .01215*zeta^2)*Td;
	  	  a1=1;a2=-2;a3=2;a4=-2;a5=2;
   elseif P ==2,
      t2=(0.12207 + .16808*zeta + .07038*zeta^2)*Td;   
      t3=(0.26661 + .13190*zeta - .019712*zeta^2)*Td;
      t4=(0.50210 + .15873*zeta - .22743*zeta^2)*Td;
      t5=(0.57439 + .04813*zeta - .17499*zeta^2)*Td;
	  	  	a1=2;a2=-4;a3=4;a4=-4;a5=3;
   else
      t2=(0.10412 + .12667*zeta + .02201*zeta^2)*Td;   
      t3=(0.24916 + .11908*zeta - .06480*zeta^2)*Td;
      t4=(0.44925 + .11835*zeta - .21300*zeta^2)*Td;
      t5=(0.52261 + .02720*zeta - .18377*zeta^2)*Td;
	  a1=3;a2=-6;a3=6;a4=-6;a5=4;
   end
else
   fprintf('\nV out of range [0.05 or 0.1]\n');
end
exactshaper=[0	a1;t2 a2;t3 a3;t4 a4;t5 a5];
shaper = digseq(exactshaper,deltaT);
