function [shaper,exactshaper] = ZVD2MD(fd1,fd2,zeta1,zeta2,deltaT)

% ZVD2MD(f1,f2,zeta1,zeta2,deltaT) -- Bill Singhose
% Generates a damped 2 mode ZVD shaper 
% The solution presented here is the result of a curve fit to data
% generated by GAMS.  
% This shaper works well over the ranges of 1.2<r<2.8 and 0<z<.15
% fd1, fd2 - frequencies(Hz) of vibration being controlled
% zetas - damping ratios of low mode
% deltaT - time spacing at which input to system is updated

r=max([fd1,fd2])/min([fd1,fd2]);
z = (zeta1+zeta2)/2;
td= 1/(min([fd1,fd2]));

 rsq = r*r;
 zsq = z*z;
 rz  = r*z;
 rzsq = r*zsq;
 rsqz = rsq*z;
 rsqzsq = rsq*zsq;
  
T1 = 0.0;
A1 = 0.103322 - 0.0899412*r + 0.0459476*rsq + 0.246507*z + 0.241147*rz + 
0.0155443*rsqz;
	
T2 = (0.753347 - 0.305574*r + 0.047293*rsq + 2.01717*z - 2.69365*rz + 
0.889207*rsqz - 12.7959*zsq + 16.3423*rzsq - 4.85957*rsqzsq)/td;          
A2 = 0.0446027 + 0.290345*r - 0.100525*rsq + 1.57682*z - 0.951903*rz + 
0.221612*rsqz;
	
T3 = (1.45338 - 0.550964*r + 0.0788118*rsq - 0.142916*z + 0.23173*rz - 
0.0599463*rsqz + 3.687*zsq - 4.54357*rzsq + 1.51877*rsqzsq)/td;
A3 = 0.703026 - 0.396352*r + 0.107554*rsq - 1.47362*z + 1.52137*rz - 
0.460441*rsqz;
	
T4 = (2.20776 - 0.857887*r + 0.126523*rsq + 2.05192*z - 2.66216*rz + 
0.85682*rsqz - 9.05417*zsq + 12.0454*rzsq - 3.56146*rsqzsq)/td;
A4 = 0.0450976 + 0.284601*r - 0.0982221*rsq + 0.333623*z - 1.46572*rz + 
0.495255*rsqz;
	
T5 = (2.90784 - 1.10282*r + 0.157726*rsq + 0.75738*z - 0.820955*rz + 
0.204562*rsqz + 5.1498*zsq - 6.01001*rzsq + 2.00055*rsqzsq)/td;
A5 = 0.103738 - 0.0884252*r + 0.0451904*rsq - 0.681275*z + 0.652875*rz - 
0.271403*rsqz;
	
exactshaper=[
T1      A1;
T2      A2;
T3      A3;
T4      A4;
T5      A5];
 
shaper = digseq(exactshaper,deltaT);
