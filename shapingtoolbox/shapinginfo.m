% Input Shaping Toolbox, Copyright Convolve, Inc 1993 9/9/93
%
%
%       Input Shaping Toolbox
%
%  One-mode Shapers
%
% EI:A three-impulse sequence that limits the vibration to V at the 
%    modeling frequency, (instead of forcing it to zero), to acheive
%    larger amounts of insensitivity than the ZVD shaper. Shaper length 
%    equals 1 period. The shaper works well for 0<V<.2 ans 0<zeta<.25.
% EI2HUMP: A 4-impulse shaper that has two humps in its sensitivity
%          curve.  It has the same length as a ZVDD, but has a larger
%          insensitivity to modelling errors.
% EI3HUMP: A 5-impulse shaper that has three humps in its sensitivity
%          curve.  It has the same length as a ZVDDD, but has a larger
%          insensitivity to modelling errors.
% EI_UNDMP: An exact EI shaper for 1 UNDAMPED mode.  Shaper length
%           equals 1 period of vibration.
% DIGEI5: An exact digital EI shaper, using matrix inversion technique.
% DIGZVD5: An digital ZVD shaper calculated by linearizing the
%          times to the nearest two time discrete time steps and
%          then inverting the matrix of the original equations.
% NEGEI: A negative EI shaper for 1 mode.  This shaper is shorter
%        than the positive EI.  The amount of overcurrenting is
%        controlled with the parameter P.  For P=1, the negative
%        shaper is approximately 30% shorter than the positive EI.
% NEGZV: A negative ZV shaper for 1 mode.
% NEGZVD: A negative ZVD shaper.
% ZV :  A two-impulse sequence that gives no vibration at
%       the modeling frequency, but has poor insensitivity.
%       Shaper length equals 1/2 period of vibration.
% ZVD : A three-impulse sequence that has both zero vibration
%       and zero slope of the sensitivity curve at the modeling
%       frequency.  Shaper length equals 1 period of vibration.
% ZVDD :A four-impulse sequence that has zero vibration and zero 1st
%       and 2nd derivatives of the sensitivity curve at the modeling
%       frequency.  Shaper length equals 1.5 periods of vibration.
% ZVDDD:A five-impulse sequence that has zero vibration and zero 1st
%       2nd, & 3rd derivatives of the sensitivity curve at the modeling
%       frequency.  Shaper length equals 2 periods of vibration.
%
%	Two-mode Shapers
% EI2M_DMP: An EI shaper for 2 modes. The solution comes from a surface 
%           fit to data calculated with GAMS. The shaper works well over
%           the ranges of 0<V<.2 ans 0<z<.25. The shapers for each mode 
%           are convolved together to give the final shaper.
% EI2M_UND: An exact EI shaper 2 UNDAMPED modes. The shapers for each 
%           mode are convolved together to give the final shaper.
% NEG2MZVD: A negative 2 mode ZVD shaper based on Rappole eqns.
%           This shaper is shorter than a 2 mode shaper formed
%           by convolving two single-mode shapers together.
% RAP2MZV: A 2 mode ZV shaper based on Rappole equations for 2 
%          undamped modes.  This shaper is shorter than two
%          single-mode ZV shaper convolved together.  Do not use
%          this for frequency ratios over 3.76679 - it will
%          result in gains larger than one (overcurrenting).
% RAP2MZVD: A 2 mode ZVD shaper based on Rappole equations for 2 
%          undamped modes.  This shaper is shorter than two
%          single-mode ZVD shaper convolved together.  Do not use
%          this for frequency ratios over 3.76679 - it will
%          result in gains larger than one (overcurrenting).
% RAPP9SEQ: An exact digital sequence found with Rappole 2-modes,
%           5-impulse constraints. Uses matrix inversion.
% ZVD-2M : A two-mode shaper that uses two ZVD shapers convolved
%          together.  Shaper length equals the sum of the two periods.
%          For a shorter 2-mode shaper see ZVD2MD.
% ZVD2MD: A two-mode shaper that uses ZVD constraints.  The solution 
%         is based on the result of a curve fit to data from GAMS.  
%         The shaper length is shorter than the sum of the two periods.
%         The shaper works well for 1.2<r<2.8 and 0<z<.15.
%
%
%       Trapezoidal Profiling Utilities
%
% Acc2Trap :       Calculate a shaped trapezoidal trajectory (both
%                  velocity and position) using an acceleration table
% TrapProf :       Generate position and velocity commands for a trapezoidal
%                  velocity profile.
%
%
%       Additional Input shaping utilities
%
% Convolve :       Covolves Input and Shaper and returns the 
%                  result ShapedInput.
% Dig2con  :       Put a digital sequence in continuous
% DigSeq   :       Map a sequence onto digital timing loop
% SeqConv  :       Convolve two continuous sequences together.
% SeqSort  :       Sort a continuous sequence into correct 
%                  order and combine impulses at the same time.
% ShapRes  :       Calculate the residual for a given freq and zeta
% Con2Dig  :       Puts a continuous sequence in digital sequence form.
%
% SensPlot :       Plot the residual over range of frequencies
%
% Dig3Imp  :       Finds a digital sequence for a ThreeImpSeq by linearizing
%                  the times to the nearest two time discrete time steps and
%                  then inverting the matrix of the original equations
% W_DigSeq :       Uses Watanabe's formula to split each continuous
%                  impulse into two digital impulses
