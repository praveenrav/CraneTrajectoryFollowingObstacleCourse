% ShapGen -- 
% This programs Generates an Input Shaper
% from user supplied parameters
clear
clc
clear freq;
clear zeta;
clear samp_freq;
clear deltaT;

fprintf('\n\n')
fprintf('\t *******************************************\n')
fprintf('\t Welcome to Convolves Input Shaping Toolbox \n')
fprintf('\t *******************************************\n')
fprintf('\n\n\n')
fprintf('\n_____________________________________________\n')

fprintf('\n1) Introduction and Demonstration\n')
fprintf('2) Generate an Input Shaper for one or two modes\n')
fprintf('\n\n9) Exit\n\n')
nchoice=input('Enter an option:  ');

if ((nchoice<=0) | (nchoice>2)),
	break;
end

if nchoice==1,
	fprintf('\n\n  First, we will generate a demo transfer function');
	fprintf(' \n based on a specified frequency and damping ratio\n');
	f1 = input('Enter the a frequency [Hz]:');
	Wnx=2*pi*f1;
	zetax=input('Enter the damping ratio for that frequency [0 to 1]:');
	m=1;
	kx=Wnx^2*m;
	bx=2*m*zetax*Wnx;
	Wdx=Wnx*sqrt(1-zetax^2);
	num=[0 bx/m kx/m];
	den=[1 bx/m kx/m];
	fprintf('\nThe Generated Transfer function is:\n');
	printsys(num,den);

	fprintf('\nwith eigenvalues and damping and natural frequency of:\n');
	damp(den);

	fprintf('\n\nHit Enter to see the step response of the system\n');
	pause;
	clg;
	deltaT=.01;
	time_unshaped=(0:deltaT:10)';
	u_unshaped=ones(1,length(time_unshaped))';
%	period = f1*5;
%	u_unshaped=(rem(time_unshaped,period) >= period./2);
	[y_unshaped,x_unshaped]=lsim(num,den,u_unshaped,time_unshaped);
	plot(time_unshaped,y_unshaped);
	xlabel('Time (sec)'); ylabel('Amplitude'); title('Response of Demo System to a Step');

	fprintf('\n\nHit Enter to see the bode plot of the system\n');
	pause;
	bode(num,den);
	fprintf('\n\nNow, design an Input shaper for the one mode\n');
	fprintf('\nHit Enter to continue\n');
	pause;
	[digital_shaper,exact_shaper]=singer13(f1,zetax,deltaT);
	fprintf('\n The designed shaper is stored in exact_shaper\n');
	fprintf('\tTime\t\tAmplitude\n\t[sec]\t\t[]\n');
	fprintf('\t%f\t%f\n',exact_shaper(1,1),exact_shaper(1,2));
 fprintf('\t%f\t%f\n',exact_shaper(2,1),exact_shaper(2,2));
 fprintf('\t%f\t%f\n',exact_shaper(3,1),exact_shaper(3,2));
%	exact_shaper
	fprintf('Hit Enter to see the Sensitivity plot of the Input Shaper\n');
	pause;
	sensplot(exact_shaper,f1/2,f1*1.5,zetax,200);
	fprintf('\n\nHit Enter to apply the Shaper to the System\n');
	pause;
	[time_shaped,u_shaped]=convolve(u_unshaped,digital_shaper,deltaT);
	[y_shaped,x_shaped]=lsim(num,den,u_shaped,time_shaped);
	plot(time_shaped,y_shaped);
	xlabel('Time (sec)'); ylabel('Amplitude'); title('Response of Demo System to a Shaped Step');
	fprintf('\n\nHit Enter to overlay the shaped and unshaped plots\n');
	pause;
	clg;
	plot(time_shaped,y_shaped,'r');
	hold on;
	plot(time_unshaped,y_unshaped,'y');	
	xlabel('Time (sec)'); ylabel('Amplitude'); 
 title('System Responses: Red is Shaped, Yellow is Unshaped');

%	is_bode(exact_shaper,num,den);

end

if nchoice==2,
     n = input('Enter number of frequencies: ');
     if ((n <= 0) | (n >= 3)),
          break;
     end

for i=1:n,
        freq(i) = input('Enter frequency [Hz]:  ');
      	zeta(i) = input('Enter damping ratio for that frequency[ ]: ');
end

fsample = input('Enter the sampling frequency [Hz]: ');

if max(freq) >0.1*fsample,
     fprintf('Danger!! \nSampling frequency may be too low for highest mode.\n')
end
if min(freq) > 0.1*fsample,
	fprintf('All Frequencies are above the Nyquist Limit!!\nEnding.\n');
	break;
end

deltaT = 1/fsample;
if n==1,
	[shaper,exact] = shap1mod(freq,zeta,deltaT);
	total = sensplot(exact,freq/2,freq*1.5,zeta,200);
elseif n==2,
	[shaper,exact] = shap2mod(freq,zeta,deltaT);
	avefreq=sum(freq)/2;
	avezeta=sum(zeta)/2;
	if min(freq)==freq(1), zi=1; else zi=2; end
	part1=sensplot(exact,min(freq)/2,min(freq)*1.5,zeta(zi),200);
	part2=sensplot(exact,min(freq)*1.5,max(freq)*1.5,zeta(3-zi),200);
	total=[part1;part2];
else
          n
end

hold off;
clg;
hold on;
plot(total(:,1),total(:,2))
heading = sprintf('Total Time Delay for This Shaper is: %f sec',max( exact(:,1) ) );
title(heading);
xlabel('Frequency [Hz]');
ylabel('Magnitude of Residual Vibration []');

fprintf('\nResults:');
if n==2,
	plot([min(freq)*1.5 min(freq)*1.5],[0 1],'r');
	fprintf('\nThe plot is split for two modes\n');
	fprintf('The red line marks the separation between modes\n');
end
fprintf('\nThe exact shaper is in the variable "exact"\n')
fprintf('The amplitudes of the digital shaper are stored in vector "shaper"\n')
fprintf('The time spacing of the digital version is 1/fsample')
fprintf('\n\nDesigned Shaper:\n');
fprintf('Time[sec]   Amplitude[]\n')
exact



% end of n==2 if statement for the input generator portion
end
