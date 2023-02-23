function area = trap_rul(mag,dt)
%TRAP_RUL
% trap_rul uses the trapezoidal rule on a vector and
% returns the area, since the spacing on the x-axis
% is dt, the "area" returned is the sum of all the trapezoids



for n = 2:length(mag),
	area = area + (mag(n)+mag(n-1))/2*dt;
end
