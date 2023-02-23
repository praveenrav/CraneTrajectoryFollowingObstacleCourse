i=0
for insens=0.3:.01:1;i=i+1;
   insens
	[d,exact] = SI(1,0,0.05,insens,0.01);
   dat(i,1:7)=[insens exact(:,2)' exact(:,1)'];
end
