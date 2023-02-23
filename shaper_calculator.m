clear all
clc 
close all
addpath([pwd '/shapingtoolbox']);

%% parameters
m1 = 0.21; %hook mass
m2 = 0.005 + 0.07; %bottle and magnet mass

L2 = 0.7; %rigging length

g = 9.81;

%% shaper calculation
L1 = .85;

R = m2/m1;
beta = sqrt((1+R)^2*(1/L1+1/L2)^2-4*(1+R)/(L1*L2));
w2 = sqrt(g/2)*sqrt((1+R)*(1/L1+1/L2)+beta);
w1 = sqrt(g/2)*sqrt((1+R)*(1/L1+1/L2)-beta);
f1 = 2*pi/w1;
f2 = 2*pi/w2;

%EI shaper
w = mean([w1,w2]);
f = 2*pi/w;
Vlim = 0.0125;
deltaT = 0.1;
[~, exactshaper_EI] = ei_undmp(f,Vlim,deltaT);

%negative 2 hump uni magnitude EI
w = mean([w1,w2]);
f = 2*pi/w;
z = 0.001;
V = 0.05;
deltaT = 0.1;
[~,exactshaper_NegUM2HEI,minBB] = negum2ei(f,z,V,deltaT);
% [shaper,exactshaper,minBB] = NEGUM2EI(f,z,V,deltaT)

%EI 2 mode
[~,exactshaper_EI2M] = ei2m_und(f1,f2,.01,.01,deltaT);

%negative 2 mode zvd
L1 = .8128;

beta = sqrt((1+R)^2*(1/L1+1/L2)^2-4*(1+R)/(L1*L2));
w2 = sqrt(g/2)*sqrt((1+R)*(1/L1+1/L2)+beta);
w1 = sqrt(g/2)*sqrt((1+R)*(1/L1+1/L2)-beta);

f1 = 2*pi/w1;
f2 = 2*pi/w2;
[~, exactshaper_2MZVD] = rap2mzvd(f1,f2,deltaT);


% 1 mode ZVD:
L_zvd = 0.825;
f_zvd = (1./(2 * pi)) * sqrt(g/L_zvd);
[shaper,exactshaper_ZVD] = zvd(f_zvd, 0 ,deltaT)


t_sh = exactshaper_EI2M(:, 1);
v_mag = exactshaper_EI2M(:, 2);
v_mag_cum_sh1 = cumsum(v_mag);
max_hoist_vel = 0.13318; % Max hoist velocity in m/s

t_sh2 = exactshaper_2MZVD(:, 1);
v_sh2 = exactshaper_2MZVD(:, 2);
v_mag_cum_sh2 = cumsum(v_sh2);

t_sh3 = exactshaper_ZVD(:, 1);
v_sh3 = exactshaper_ZVD(:, 2);
v_mag_cum_sh3 = cumsum(v_sh3);

%% Hoist 1:

dist_des = 0.731; % Desired distance to move up
t_hoist = dist_des./max_hoist_vel;

t_hoist = [0:0.04:t_hoist]';
hoist_vel1 = zeros(length(t_hoist), 1) + 1;

figure
plot(t_hoist, hoist_vel1, 'b*')

%% CCW Movement:
r = 0.819; % Radius in meters
dist_des1 = r .* (281./180) .* pi; % Desired distance to be moved
v_max1 = r .* 0.35; % Max velocity

v_mag_cum1 = v_max1 .* v_mag_cum_sh2; % Cumulative magnitudes of shaper velocities
dist_moved = trapz(t_sh2, v_mag_cum1); % Distance moved with one execution of the shaper

% Straight line velocity
dist_atmaxvel = dist_des1 - (2 .* dist_moved);
t_maxvel = dist_atmaxvel./v_max1;
t_maxvel = linspace(1.2764, (1.2764 + t_maxvel), 1000)';
v_constmax = zeros(length(t_maxvel), 1) + v_max1;

% Going back down to zero:
t_start_zero = t_maxvel(end) + 0.001;
t_diff = diff(t_sh2);
t_diff = cumsum(t_diff(end:-1:1));
t_zero = [t_start_zero; (t_start_zero + t_diff)];
v_mag_cum1_rev = v_mag_cum1(end:-1:1);

t = [t_sh2; t_maxvel; t_zero];
v = [v_mag_cum1; v_constmax; v_mag_cum1_rev];

v_mag = v./v_max1;

t1 = [t(1): 0.04: t(end)]';
v1 = zeros(length(t1), 1);

for i = 1:length(t1)
    v1_cur = interp1(t, v_mag, t1(i));
    v1(i) = v1_cur;
end

v1 = v1 * 100;

figure
plot(t1, v1, 'b*')

%% Radial Inward Movement 1:

dist_des2 = 0.322; % Desired distance to be moved in meters
v_max2 = 0.14; % Max velocity in m/s

v_mag_cum2 = v_max2 .* v_mag_cum_sh2; % Cumulative magnitudes of shaper velocities
dist_moved = trapz(t_sh2, v_mag_cum2); % Distance moved with one execution of the shaper

% Straight line velocity
dist_atmaxvel = dist_des2 - (2 .* dist_moved);
t_maxvel = dist_atmaxvel./v_max2;
t_maxvel = linspace(1.2764, (t_sh2(end) + t_maxvel), 1000)';
v_constmax = zeros(length(t_maxvel), 1) + v_max2;

% Going back down to zero:
t_start_zero = t_maxvel(end) + 0.001;
t_diff = diff(t_sh2);
t_diff = cumsum(t_diff(end:-1:1));
t_zero = [t_start_zero; (t_start_zero + t_diff)];
v_mag_cum2_rev = v_mag_cum2(end:-1:1);

t2_pre = [t_sh2; t_maxvel; t_zero];
v2_pre = [v_mag_cum2; v_constmax; v_mag_cum2_rev];

v_mag2 = v2_pre./v_max2;

t2 = [t2_pre(1): 0.04: t2_pre(end)]';
v2 = zeros(length(t2), 1);

for i = 1:length(t2)
    v2_cur = interp1(t2_pre, v_mag2, t2(i));
    v2(i) = v2_cur;
end

v2 = v2 * -100;

figure
plot(t2, v2, 'b*')

%% Hoist DOWN 805 mm:

dist_des = 0.805; % Desired distance to move up
t_hoist2 = dist_des./max_hoist_vel;

t_hoist2 = [0:0.04:t_hoist2]';
hoist_vel2 = zeros(length(t_hoist2), 1) - 1;

t_hoist2 = t_hoist2 + t2(end);

figure
plot(t_hoist2, hoist_vel2, 'b*')

%% Hoist 3 UP 830:

dist_des = 0.830; % Desired distance to move up
t_hoist3 = dist_des./max_hoist_vel;

t_hoist3 = [0:0.04:t_hoist3]';
hoist_vel3 = zeros(length(t_hoist3), 1) + 1;

t_hoist3 = t_hoist3 + t_hoist2(end);

figure
plot(t_hoist3, hoist_vel3, 'b*')

%% Radial Outward Movement 1 (PAYLOAD PICKED UP):

dist_des3 = 0.418; % Desired distance to be moved in meters
v_max2 = 0.14; % Max velocity in m/s
v_maxdes = 0.75 .* v_max2; % Desired max velocity in m/s

v_mag_cum2 = v_maxdes .* v_mag_cum_sh1; % Cumulative magnitudes of shaper velocities
dist_moved = trapz(t_sh, v_mag_cum2); % Distance moved with one execution of the shaper

% Straight line velocity
dist_atmaxvel = dist_des3 - (2 .* dist_moved);
t_maxvel = dist_atmaxvel./v_maxdes;
t_maxvel = linspace(1.2764, (t_sh(end) + t_maxvel), 1000)';
v_constmax = zeros(length(t_maxvel), 1) + v_maxdes;

% Going back down to zero:
t_start_zero = t_maxvel(end) + 0.001;
t_diff = diff(t_sh);
t_diff = cumsum(t_diff(end:-1:1));
t_zero = [t_start_zero; (t_start_zero + t_diff)];
v_mag_cum2_rev = v_mag_cum2(end:-1:1);

t2_pre = [t_sh; t_maxvel; t_zero];
v2_pre = [v_mag_cum2; v_constmax; v_mag_cum2_rev];

v_mag2 = v2_pre./v_max2;

t3 = [t2_pre(1): 0.04: t2_pre(end)]';
v3 = zeros(length(t3), 1);

for i = 1:length(t3)
    v3_cur = interp1(t2_pre, v_mag2, t3(i));
    v3(i) = v3_cur;
end

v3 = v3 * 100;

figure
plot(t3, v3, 'b*')

%% CW Movement:

r = 0.915; % Radius in meters
dist_des4 = r .* (155./180) .* pi; % Desired distance to be moved
v_max2 = 0.35 .* r; % Max velocity in m/s
v_maxdes = 0.75 .* v_max2; % Desired max velocity in m/s

v_mag_cum2 = v_maxdes .* v_mag_cum_sh1; % Cumulative magnitudes of shaper velocities
dist_moved = trapz(t_sh, v_mag_cum2); % Distance moved with one execution of the shaper

% Straight line velocity
dist_atmaxvel = dist_des4 - (2 .* dist_moved);
t_maxvel = dist_atmaxvel./v_maxdes;
t_maxvel = linspace(1.2764, (t_sh(end) + t_maxvel), 1000)';
v_constmax = zeros(length(t_maxvel), 1) + v_maxdes;

% Going back down to zero:
t_start_zero = t_maxvel(end) + 0.001;
t_diff = diff(t_sh);
t_diff = cumsum(t_diff(end:-1:1));
t_zero = [t_start_zero; (t_start_zero + t_diff)];
v_mag_cum2_rev = v_mag_cum2(end:-1:1);

t2_pre = [t_sh; t_maxvel; t_zero];
v2_pre = [v_mag_cum2; v_constmax; v_mag_cum2_rev];

v_mag2 = v2_pre./v_max2;

t4 = [t2_pre(1): 0.04: t2_pre(end)]';
v4 = zeros(length(t4), 1);

for i = 1:length(t4)
    v4_cur = interp1(t2_pre, v_mag2, t4(i));
    v4(i) = v4_cur;
end

v4 = v4 * -100;

figure
plot(t4, v4, 'b*')

%% Radial Inward Movement 2:

dist_des3 = 0.101; % Desired distance to be moved in meters
v_max2 = 0.14; % Max velocity in m/s
v_maxdes = 0.5 .* v_max2; % Desired max velocity in m/s

v_mag_cum2 = v_maxdes .* v_mag_cum_sh2; % Cumulative magnitudes of shaper velocities
dist_moved = trapz(t_sh2, v_mag_cum2); % Distance moved with one execution of the shaper

% Straight line velocity
dist_atmaxvel = dist_des3 - (2 .* dist_moved);
t_maxvel = dist_atmaxvel./v_maxdes;
t_maxvel = linspace(1.2764, (t_sh2(end) + t_maxvel), 1000)';
v_constmax = zeros(length(t_maxvel), 1) + v_maxdes;

% Going back down to zero:
t_start_zero = t_maxvel(end) + 0.001;
t_diff = diff(t_sh2);
t_diff = cumsum(t_diff(end:-1:1));
t_zero = [t_start_zero; (t_start_zero + t_diff)];
v_mag_cum2_rev = v_mag_cum2(end:-1:1);

t2_pre = [t_sh2; t_maxvel; t_zero];
v2_pre = [v_mag_cum2; v_constmax; v_mag_cum2_rev];

v_mag2 = v2_pre./v_max2;

t5 = [t2_pre(1): 0.04: t2_pre(end)]';
v5 = zeros(length(t5), 1);

for i = 1:length(t5)
    v5_cur = interp1(t2_pre, v_mag2, t5(i));
    v5(i) = v5_cur;
end

v5 = v5 * -100;

figure
plot(t5, v5, 'b*')

%% Hoist 4:

dist_des = 0.195; % Desired distance to move up
t_hoist4 = dist_des./max_hoist_vel;

t_hoist4 = [0:0.04:t_hoist4]';
hoist_vel4 = zeros(length(t_hoist4), 1) - 1;

t_hoist4 = t_hoist4 + t5(end);

figure
plot(t_hoist4, hoist_vel4, 'b*')

hoist_vel1 = hoist_vel1 * 100;
hoist_vel2 = hoist_vel2 * 100;
hoist_vel3 = hoist_vel3 * 100;
hoist_vel4 = hoist_vel4 * 100;


s1 = hoist_vel1;
s2 = v1;
s3 = v2;
s4 = hoist_vel2;
s5 = hoist_vel3;
s6 = v3;
s7 = v4;
s8 = v5;
s9 = hoist_vel4;

close all
