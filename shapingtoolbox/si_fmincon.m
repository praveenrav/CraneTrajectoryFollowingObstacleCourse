function [shaper,exactshaper,exitflag] = si_fmincon(ShapLength,ShaperFlag,...
    neg,X0,fmin,fmax,damp,V_tol,deltaT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [shaper,exactshaper] = si_fmincon(ShapLength,ShaperFlag,...
%    neg,X0,fmin,fmax,damp,V_tol,deltaT)
%
% function to determine amplitudes and time locations
% for an SI,UM-SI, or SNA-SI shaper
%
% necessary files: digseq and optimization toolbox
%
% Can be either a SNA, UM, or positive shaper, depending on the
% value of UMFlag.  
%
% The user enters desired frequency range to suppress vibration;
% the program calculates insensitivity values and generates input shaper.
%
% ShaperLength = number of impulses, will be redefined if X0 = 0
% ShaperFlag = 0 for positive, 1 for UM shaper, 2 for SNA
% neg = max negative amplitude for SNA shaper, ignored otherwise
% X0 = initial guess - [a1 a2 ... an t1 t2 ... tn] or 0 if unknown
% fmin = lower frequency of range to suppress vibration within (Hz)
% wmin = lower frequency of range to suppress vibration within (rad/s)
% fmax = upper frequency of range to suppress vibration within (Hz)
% wmax = upper frequency of range to suppress vibration within (rad/s)
% damp = damping ratio
% V_tol = vibration level tolerated (0.05 = 5%)
% deltaT = sampling period (s)
%
% This function generates the exact sequence and then uses
% digSeq to convert the exact sequence to digital format.
%
% Joshua Vaughan
% 7/11/07
% 
% Modified:
% 4/22/09 - code "clean up" - JEV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ShaperLength = ShapLength;  % if X0 = 0 this will be redefined during intial guess
Vtol = V_tol;
UMFlag = ShaperFlag;
zeta = damp;

if UMFlag == 1;
    neg = 1;
end

%***** Determine median frequecny of range to be suppressed
%***** and Insensitivity.
wmin = 2*pi*fmin;                   % convert to rad/s
wmax = 2*pi*fmax;                   % convert to rad/s
wn = (wmin+wmax)/2;					% median frequency
Ins = (wmax-wmin)/wn;               % Insensitivity
%*******************************************************


%***** Calculate period; use for initial time guess ****
T=2*pi/wn;
%*******************************************************

if X0==0                    % if I.C.'s unknown, create X0
    if UMFlag==0            % For pos shaper
        if Ins <= 0.3992
            ShaperLength = 3;       % EI
            X0 = [0.28 0.46 0.28 0 T/2 T];                          
        elseif Ins <= 0.7262
            ShaperLength = 4;       % 2hump EI
            X0 = [0.16 0.34 0.34 0.16 0 T/2 T 1.5*T];               
        elseif Ins <= 0.9654
            ShaperLength = 5;       % 3 hump EI
            X0 = [0.0625 0.25 0.375 0.25 0.0625 0 T/2 T 1.5*T 2*T]; 
        else
            disp('Code only work for positive shapers up to I(5%) = 0.9654')
        end
    else                    % for negative shapers
        if Ins <= 0.0333*neg^2-0.0672*neg+0.3956
            ShaperLength = 5;
            t(1) = 0;
            t(2) = -0.0091*neg^2 - 0.041*neg + 0.1466;
            t(3) = 0.0923*neg^2 - 0.2134*neg + 0.4881;
            t(4) = 0.1933*neg^2 - 0.3856*neg + 0.8297;
            t(5) = 0.1843*neg^2 - 0.4267*neg + 0.9763;
            
            a(1) = 0.4067*neg^3 - 0.5703*neg^2 + 0.9112*neg + 0.25;
            a(2) = -neg;
            a(3) = -0.8135*neg^3 + 1.1401*neg^2 + 0.1782*neg + 0.4998;
            a(4) = -neg;
            a(5) = a(1);
            
            X0 = [a t*T]; % EI node
            
        elseif Ins <= 0.0604*neg^2 - 0.1061*neg + 0.7186;
            ShaperLength = 7;
           t(1) = 0;
           t(2) = -0.0698*neg^2 + 0.0185*neg + 0.1171;
           t(3) = 0.1952*neg^2 - 0.3032*neg + 0.4949;
           t(4) = 0.1571*neg^2 - 0.3053*neg + 0.7294;
           t(5) = 0.1190^neg^2 - 0.3075*neg + 0.9639;
           t(6) = 0.3839*neg^2 - 0.6290*neg + 1.3416;
           t(7) = 0.3138*neg^2 - 0.6102*neg + 1.4587;
           
           a(1) = 1.6343*neg^4 - 2.4423*neg^3 + 1.0978*neg^2 + 0.5355*neg + 0.1772;
           a(2) = -neg;
           a(3) = -1.6343*neg^4 + 2.4423*neg^3 - 1.0978*neg^2 + 0.9645*neg +0.3228;
           a(4) = -neg;
           a(5) = a(3);
           a(6) = -neg;
           a(7) = a(1);
           
           X0 = [a t*T]; % 2Hump EI Node
            
        elseif Ins <= .2895*neg^4 - 0.6258*neg^3 + 0.5211*neg^2 - 0.2382*neg + 0.9654
            ShaperLength = 9;
            t(1) = 0;
            t(2) = -0.0856*neg^2 + 0.0235*neg + 0.1148;
            t(3) = 0.3095*neg^2 - 0.4085*neg + 0.4947;
            t(4) = 0.1438*neg^2 - 0.3033*neg + 0.7011;
            t(5) = 0.2201*neg^2 - 0.3867*neg + 0.9686;
            t(6) = 0.2973*neg^2 - 0.4709*neg + 1.237;
            t(7) = 0.1308*neg^2 - 0.3648*neg + 1.4424;
            t(8) = 0.5266*neg^2 - 0.7978*neg + 1.8226;
            t(9) = 0.4407*neg^2 - 0.7738*neg + 1.9372;
            
            a(1) = 0.3615*neg^5 + 2.2773*neg^4 - 4.501*neg^3 + 2.5652*neg^2 + 0.1458*neg + 0.1537;
            a(2) = -neg;
            a(3) = -4.7821*neg^5 + 10.014*neg^4 - 7.4091*neg^3 + 2.4361*neg^2 + 0.492*neg + 0.2475;
            a(4) = -neg;
            a(5) = 8.7667*neg^5 - 24.359*neg^4 + 23.578*neg^3 - 9.8884*neg^2 + 2.7027*neg + 0.1989;
            a(6) = -neg;
            a(7) = a(3);
            a(8) = -neg;
            a(9) = a(1);
            
            X0 = [a t*T]; %3 Hump EI Node
            
            
        elseif Ins <= 1.2
            ShaperLength = 11; % ???
            X0 = [1 -1 1 -1 1 -1 1 -1 1 -1 1 ...                         
                0 0.0427*T 0.4242*T 0.5635*T 0.8305*T 1.0976*T 1.2371*T...
                1.6189*T 1.6619*T 1.85*T 2.4*T];
        else
            disp('Code only works for negative shapers up to I(5%) = 1.2')
        end
    end
end


% Increase ShapLen temporarily... it gets reduced during first iteration of
%   optimization
if UMFlag == 0
    ShaperLength = ShaperLength + 1;
else
    ShaperLength = ShaperLength + 2;
end

% Create zero vectors to store amplitudes and times
% These also trigger the while loop to execute the first time
amps=zeros(1,ShaperLength);
tms=zeros(1,ShaperLength);

%   Check for zero amplitudes and repeated impulse times
%	If they exist, decrease the shaper length by one and solve again
while ((abs(min(amps)) < 1e-4) | (min(diff(tms)) < 1e-4))
    if UMFlag == 0
        %Reduce number of impulses if min(amps) is small
        ShaperLength = ShaperLength-1;   
    else
        ShaperLength = ShaperLength-2;
    end
    
    % Define Linear Constraints based on UMFlag
    
    if UMFlag == 0      % All Positive Impulses
        %Linear Equality Constraints
        Aeq=zeros(2,2*ShaperLength);      % define to speed comp.
        for ii=1:ShaperLength
            Aeq(1,ii)=1;                  % all impulses sum to one
        end
        Aeq(2,ShaperLength+1)=1;          % first impulse at t=0
        Beq=[1;0];
        
        %Linear Inequality Constraints
        A=zeros(ShaperLength-1,2*ShaperLength); % define to speed comp.
        B=[zeros(3*ShaperLength-1,1)];

        % loop is constraints that t(i+1) > t(i)
        for ii=1:ShaperLength-1
            A(ShaperLength+ii,ShaperLength+ii)=1;
            A(ShaperLength+ii,ShaperLength+1+ii)=-1;
        end

        for ii=1:ShaperLength
            A(ii,ii)=-1;                                    %All Imp.  pos
            A((2*ShaperLength+ii-1),ShaperLength+ii)=-1;    %All times pos
        end
        
    elseif UMFlag == 1  % Unity Magnitude        
        %Linear Equality Constraints
        Aeq=zeros(ShaperLength+2,2*ShaperLength); % define to speed comp.
        for ii=1:ShaperLength
            Aeq(1,ii)=1;                       % all impulses sum to one
            Aeq(ii+1,ii)=(-1)^(ii+1);          % Alternating signs and unity magnitude constraints
        end
        Aeq(ShaperLength+2,ShaperLength+1)=1;  % first impulse at t=0
        Beq=[1;ones(ShaperLength,1);0];

        
        %Linear Inequality Constraints
        A=zeros(2*ShaperLength-1,2*ShaperLength);   % define to speed comp.
        B=[zeros(2*ShaperLength-1,1)];
        
        % loop is constraints that t(i+1) > t(i)
        for ii=1:ShaperLength-1
            A(ii,ShaperLength+ii)=1;
            A(ii,ShaperLength+1+ii)=-1;
        end
        
        for ii=1:ShaperLength            
            A((ShaperLength+ii-1),ShaperLength+ii)=-1;    %All times pos
        end
        
    elseif UMFlag == 2  % Specified Negative Amplitude
        %Linear Equality Constraints
        count = 0;                              % counter for #neg imp.
        for ii=2:2:ShaperLength
            count = count+1;
        end
        
        Aeq=zeros(2+count,2*ShaperLength);      % define to speed comp.
        
        for ii=1:ShaperLength
            Aeq(1,ii)=1;                        % all impulses sum to one            
        end
        
        count = 0;
        for ii=2:2:ShaperLength
            count = count + 1;
            Aeq(1+count,ii) = -1/neg;           % alternating negative amps
            
        end
           
        Aeq(2+count,ShaperLength+1)=1;          % first impulse at t=0
        Beq=[1;ones(count,1);0];
        
         %Linear Inequality Constraints
        A=zeros(2*ShaperLength-1,2*ShaperLength);
        B=[zeros(2*ShaperLength-1,1);neg*ones(ShaperLength,1);ones(ShaperLength,1);zeros(ShaperLength,1);ones(ShaperLength,1)];
        
        % loop is constraints that t(i+1) > t(i)
        for ii=1:ShaperLength-1
            A(ii,ShaperLength+ii)=1;
            A(ii,ShaperLength+1+ii)=-1;
        end
        
        for ii=1:ShaperLength            
            A((ShaperLength+ii-1),ShaperLength+ii)=-1;    %All times are pos
            A(2*ShaperLength+ii-1,ii) = -1;
            A(3*ShaperLength+ii-1,ii) = 1;
            % running total >= 0
            A(4*ShaperLength+ii-1,1:ii) = -1;
            A(5*ShaperLength+ii-1,1:ii) = 1;
        end
        
    else
        disp('Please enter a correct UMFlag value:')
        disp('UMFlag = 0 -> only positive impulses')
        disp('UMFlag = 1 -> Unity Magnitude shaper')
        disp('UMFlag = 2 -> Specified Negativity')
    end
    
    %******* Set maximum number of iterations ****************
    options = optimset('MaxIter',5000*ShaperLength,...
        'LargeScale','off','Display','off',...
        'MaxFunEvals',5000*ShaperLength,'TolFun',1e-9);


    %******* make call to optimizer ****************************
    %x=fmincon(@myfun,x0,A,b,Aeq,beq,lb,ub,@mycon) - format of call to
    %fmincon
    [x,fval,exitflag]=fmincon(@si_fmincon_fun,X0,A,B,Aeq,Beq,...
        [],[],@si_fmincon_const,options);

    i=2*ShaperLength;
    clear tms amps
    amps=x(1:ShaperLength);
    tms=x(ShaperLength+1:i);
    
    
    %Generate next initial guess
    if UMFlag == 0;
        % check for impulses occurign at the same time 
        % if so, remove one, sum amplitudes, and resolve
            for ii = 1:length(tms)-1;
                if tms(ii+1)-tms(ii) < 1e-4
                    tms(ii) = [];
                    amps(ii+1) = amps(ii)+amps(ii+1);
                    amps(ii) = [];
                end
            end
        X0=[amps tms]; 
    else
        X0=[amps(1:ShaperLength-2) tms(1:ShaperLength-2)]; 
    end
    
end


% Check for convergence and assign shaper
if exitflag <= 0
    disp('ERROR: optimization did not converge')
    exactshaper = [];
    shaper = [];
else
    i=2*ShaperLength;
    amps=x(1:ShaperLength);
    time=x(ShaperLength+1:i);
    time(1) = 0;
    exactshaper = [time' amps'];
    shaper = digseq(exactshaper,deltaT);
end


%%%%%  Cost Function to Minimize  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f,g]=si_fmincon_fun(x)

i=2*ShaperLength;           % length of x
f=x(i);                     % function to be minimized (time of tn)

end     %end cost function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%  Nonlinear Constraints  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c,ceq]=si_fmincon_const(x)

i=2*ShaperLength;               % length of x

ceq=[];                         % Nonlinear equality constraints

StepMax=50;                     % # of points at which vibration is limited

%Generate constraints to satisfy insensitivity parameters
for jj=1:StepMax
    w(jj)=wn*((1-Ins/2)+Ins/(StepMax-1)*(jj-1));
    w_damp(jj) = w(jj)*sqrt(1-zeta^2);

    csum=sum(x(1:i/2).*exp(zeta*w(jj)*x(i/2+1:i))...
        .*cos(-w_damp(jj)*x(i/2+1:i)));

    ssum=sum(x(1:i/2).*exp(zeta*w(jj)*x(i/2+1:i))...
        .*sin(-w_damp(jj)*x(i/2+1:i)));

    if abs(x(i/2)) < 1e-6
        g(jj,:)=exp(-zeta*w(jj)*x(i-1))*sqrt(csum^2+ssum^2)-Vtol;
    else
        g(jj,:)=exp(-zeta*w(jj)*x(i))*sqrt(csum^2+ssum^2)-Vtol;
    end

end

% uncomment next line to watch convergence
% shap = [x(ShaperLength+1:2*ShaperLength)' x(1:ShaperLength)'] 

c=g;
end     %end nonlinear constraint function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end % end main function=