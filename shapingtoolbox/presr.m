% PRESR.M
% Step response for second order systems (res) and step response for
% second order systems with a three impulse prefilter (resp)

z=[0.0:0.1:0.9999]';
nz=length(z);
tstep=0.2;
tfinal=15
t=0:tstep:tfinal;
wn=1;
wd=wn*sqrt(1-z.^2);
% standard 2nd order system
res=1-exp(-z*t*wn).*(cos(wd*t)+((z./sqrt(1-z.^2))*ones(size(t))).*sin(wd*t));
% three impulse scaled and superposed version

tau=pi./(wn*sqrt(1-z.^2));
K=exp(-z*pi./(sqrt(1-z.^2)));

den=(1+2*K+K.^2);
a1=   1 ./ den;
a2= 2*K ./ den;
a3=K.^2 ./ den;

nzosmax=2*length(zeros(1,max(tau)/tstep));
nt=length(t);
if 2*max(tau) >= tfinal,
  sprintf('tfinal needs to be increased by around %g',2*max(tau)-tfinal),
end
resp=zeros(length(z),nt);
for ii=1:length(z)
  zos=zeros(1,tau(ii,1)/tstep);
  nzos=length(zos);
  resp(ii,:)=a1(ii,1)*[res(ii,1:nt)] + ...
             a2(ii,1)*[zos res(ii,1:(nt-nzos))] + ...
             a3(ii,1)*[zos zos res(ii,1:(nt-2*nzos))];
end

clg;
axis([0 tfinal 0 2.0]);
plot(t,res');
xlabel('Wn*t');
title('Classic second order step response for various Zeta')
ii=1;
for val=z'
        strings(1:3,ii)=[sprintf('%3.1f',val)]';
        ii=ii+1;
end
text(ones(size(z))'*3,res(:,3/tstep)',strings');
%pause
%prtsc('ff');

axis([0 tfinal 0 1.2]);
plot(t,resp');
xlabel('Wn*t');
title('Second order step response with a 3 pulse prefilter');
%text(ones(size(z))'*4,resp(:,4/tstep)',strings');
%text(2*tau',0.95*ones(size(resp(:,1)))','|');
%text(2*tau',linspace(0.6,0.9,length(tau)).*ones(size(resp(:,1)))',strings');
%pause
%prtsc('ff');

axis([0 tfinal 0.98 1.02]);
plot(t,resp');
title('Second order step reponse with a 3 pulse prefilter');
text(ones(size(z))'*6,resp(:,6/tstep)',strings');
%pause
%prtsc('ff');

plot(t,res');
title('Classic second order step response for various Zeta')
text(ones(size(z))'*7,resp(:,7/tstep)',strings');
axis;
%pause
%here
%prtsc('ff');

axis([0 tfinal -1 1]);
plot(t,[zeros(1,nz); diff(res')]/tstep);
title('Classic second order impulse response for various Zeta');
%pause
%prtsc('ff');
axis;

axis([0 tfinal 0 0.5]);
plot(t,[zeros(1,nz); diff(resp')]/tstep);
title('Second order impulse response with a 3 pulse prefilter');
%pause
%prtsc('ff');
axis;


resp1=zeros(length(z),nt);

for ii=1:length(z)
  zos=zeros(1,tau(ii,1)/(2*tstep));
  nzos=length(zos);
  resp1(ii,:)=a2(ii,1)*[zos resp(ii,1:(nt-nzos))];
end


for mult=1.0:-0.25:-1.0
  axis([0 tfinal 0 1.2]);
  plot(t,resp' + mult*[zeros(1,nz); diff(resp1')]/tstep);
  title('Second order step plus impulse response with a 3 pulse prefilter');
  text(0,0,num2str(mult),'sc');
%  pause;
%  prtsc('ff');
  axis;
end

for mult=1.0:-0.25:-1.0
%  axis([0 tfinal 0 1.2]);
  plot(t,resp' + mult*[zeros(1,nz); diff(resp')]/tstep);
  title('Second order step plus impulse response with a 3 pulse prefilter');
  text(0,0,num2str(mult),'sc');
  pause;
%  prtsc('ff');
%  axis;
end
