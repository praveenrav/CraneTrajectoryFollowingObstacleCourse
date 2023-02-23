function rot3D

%rot3D.m - Bill Singhose
%rotate a 3-D plot

disp('Arrow keys rotate figure.')
disp('RETURN exits.')

grid

but=0;
i=-30;j=30;
while (but ~= 13),
   view(i,j)  
   [X,Y,but] = GINPUT(1);
   if (but ==28),
      i=i-5;
   elseif (but==29),
      i=i+5;
   elseif (but==30),
      j=j+5;
   elseif (but ==31),
      j=j-5;
        end
end                