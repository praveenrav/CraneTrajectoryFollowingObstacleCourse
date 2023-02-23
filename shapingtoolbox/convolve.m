function [T,ShapedInput] = convolve(Input,Shaper,deltaT)

% Convolve(Input,Shaper,deltaT) -- Bill Singhose
% function [T,ShapedInput] = convolve(Input,Shaper,deltaT)
% Covolves Input and Shaper and returns the result ShapedInput.
% A time vector, T, which has the same number of rows as
% ShapedInput is also returned. T starts at zero and is incremented
% deltaT each step.
% Input can be an nxm matrix,where m is the number of inputs.
% Shaper must be a row or column vector.

[rows,columns]=size(Input);
shlen=length(Shaper);
% Pad the Input vector with j extra final values.
% Where, j is the length of the shaper.
for j=1:shlen
  for jj=1:columns
    Input(rows+j,jj)=Input(rows,jj);
  end
end

% Perform Convolution
for i=1:columns
  ShInput(:,i)=conv(Input(:,i),Shaper);
end

%Delete convolution remainder
ShapedInput=ShInput(1:rows+shlen-1,:);

T=(0:deltaT:(length(ShapedInput)-1)*deltaT)';
 
