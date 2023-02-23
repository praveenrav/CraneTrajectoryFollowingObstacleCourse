%ACTTF.M
% Actuator laplace transform analysis for systems with and without
% prefilters.
% For a system without a prefilter the transfer function from the
% reference input to the actuator is given by CLS(s)/OLP(s) where
% CLS(s) is the closed loop sysstem response transfer function.
% OLP(s) is the open loop system response transfer function.
% For a system with a prefilter the transfer function from the
% reference input to the actuator is given by PRE(s)*CLS(s)/OLP(s)
% where PRE(s) is the prefilter transfer function.

for a=[[0.05 3 0.05 6]' [0.05 6 0.05 3]' ...
       [0.05 3 0.30 3]' [0.30 3 0.05 3]']

        z1olp=a(1,1);
        w1olp=a(2,1);
        z1cls=a(3,1);
        w1cls=a(4,1);

        % Open loop plant dynamics
        den1olp=[1 2*z1olp*w1olp w1olp^2] ./ w1olp^2;

        % Closed loop system dynamics
        den1cls=[1 2*z1cls*w1cls w1cls^2] ./ w1cls^2;

        % Prefilter transfer functions from a function file pretf(z,w,s)

        % Meshing and indexing
        [x,y]=meshdom(linspace(-10,10,31),linspace(0,15,32));
        cind=16; %cind is the column index corresponding to the imaginary axis

        s=x+y*i;
        [nx,ny]=size(s);
        X=x(1,:);
        Y=y(:,1);
        YR=Y(nx:-1:1);

        clslap=polyval(den1olp,s) ./ polyval(den1cls,s);
        prelap=pretf(z1cls,w1cls,s) .* clslap;

        clg; %clear old graphs
        subplot(221),contour(log(abs(clslap)),20,X,YR);
        title('Lap-x-form w/o prefiltering');

        subplot(222),contour(log(abs(prelap)),20,X,YR);
        title('Lap-x-form w/ prefiltering');

        subplot(223),plot(Y,[abs(clslap(:,cind)),abs(prelap(:,cind))]);
        title('Magnitude');

        subplot(224),plot(Y,[angle(clslap(:,cind)),angle(prelap(:,cind))]);
        title('Phase');
        label=['  z1olp=',num2str(z1olp),'  w1olp=',num2str(w1olp), ...
               '  z1cls=',num2str(z1cls),'  w1cls=',num2str(w1cls)];
        text(0,0,label,'sc');
       % pause
        prtsc('ff');
end
