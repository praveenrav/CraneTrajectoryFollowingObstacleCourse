function [ts,us] = shapeSTEP(shaper,deltaT,T_final,plotflag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [ts,us] = shapeSTEP(shaper,deltaT,T_final)
%
% function convolves digital shaper, shaper, with a step to find shaped
% step command
%
% necessary files: convolve
%
% shaper = digitized shaper
% deltaT = sampling time
% T_final = desired length of unshaped step command
% plotflag = if = 1 will plot unshaped and shaped steps
%
% Joshua Vaughan
% 12/12/07
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0:deltaT:T_final;
u = ones(1,length(t));

[ts,us] = convolve(u',shaper,deltaT);

if plotflag == 1
    plot(t,u,ts,us)
end
