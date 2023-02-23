function [t,u]=StepConvolve(shap,fs,tsim)
%function [t u]=StepConvolve(shap,fs,tsim)
%Convolve a shaper with a step input - faster than convolution
% shap = shaper
% fs = Sampling frequency
% tsim = length of simulation
T=1/fs;
t=(0:T:tsim)';         %generate time base
u=zeros(1,length(t));  % initialize input vector

n=length(shap);
oldindex=1;
for i=1:n-1,
  index=round(shap(i+1,1)*fs);
  u(oldindex:index)=ones(1,index-oldindex+1)*sum(shap(1:i,2));
  oldindex=index;
end
u(index+1:length(u))=ones(1,length(u)-index)*sum(shap(:,2));
u=u';
