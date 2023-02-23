% RESID.M
% residue analysis of dynamic systems

num=[0 0 0 0 0 0 0 1*9*25]
den=conv([1 2*0.1*1 1],[1 2*0.1*3 9])
den=conv(den,[1 2*0.1*5 25])
den=conv(den,[1 0])
[r,p,k]=residue(num,den)

t=linspace(0,40,60);

fr=zeros(t);
fi=zeros(t);
ft=zeros(t);

for rp=[r';p']
  % fr includes only the real part of the pole to construct the
  % exponential envelope of the response
 fr=fr+rp(1,1)*exp(real(rp(2,1))*t);
  % fi includes only the imag part of the pole to construct the
  % scaled frequency of the response
 fi=fi+rp(1,1)*exp(i*imag(rp(2,1))*t);
  % ft gives the entire combined time response for all modes
 ft=ft+rp(1,1)*exp(     rp(2,1) *t);
  % FT gives a matrix of the time responses for each POLE,
  % note for complex conjugates poles, an individual term is
  % included for each of the conjugate poles (will overplot)
 FT=[FT ; real(rp(1,1)*exp(rp(2,1)*t))];
  % FR gives a matrix of scaled exponential envelopes, one for each POLE
 FR=[FR ; real(rp(1,1)*exp(real(rp(2,1))*t))];
  % FI gives a matrix of scaled frequency terms, one for each POLE
 FI=[FI ; real(rp(1,1)*exp(i*imag(rp(2,1))*t))];
end

plot(t,ft)

% For CONTINUOUS systems:

% The absolute value of the residue scales the amplitude of the
% response.

% The complex angle of the residue corresponds to a phase shift, and is
% probably of less importance in the system tradeoff.

% The real part of the pole determines the exponential envelope shape.

% The imag part of the pole determines the damped frequency.

% For DISCRETE systems:

% The absolute value of the residue scales the amplitude of the
% response.

% The angle of the residue corresponds to a phase shift, and
% probably can be ignored in the system tradeoff.

% The absolute value of the pole determines the exponential envelope
% as a function of n:  abs(p)^n

% The complex angle of the pole determines the frequency:
% n*angle = omega*n*T, where T is the sample period.

% The above is a first step towards formulating the system tradeoff
% optimization problem (and will need to be modified for repeated
% roots).

% At this point two more things need to be added;
%       One, a residual like analysis of the prefilter.
%       Two, a metric that combines the residuals and the exponential
%               envelopes.   The second order system comparison for
%               shaped and unshaped systems is a departure point.
