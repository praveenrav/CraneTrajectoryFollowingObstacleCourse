function [t]=symswitch(ts);%function [ts]=symswitch(ts);%generate a symmetrical shaper from the first half+1 impulsesn=length(ts);t=zeros(2*n,1);t(1:n+1)=[0;ts];   %add zero for first impulse locationfor i=1:n-1,  t(n+1+i)=t(n+1)+t(n)-t(n-i);end