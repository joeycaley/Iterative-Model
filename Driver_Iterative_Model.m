clear; close all; clc;

addpath('functions')

% unit conversions
hr = 3600;
deg2rad = pi/180;
mu_e = 3.986004e14;
R_e = 6378.14e3;
km = 1e3;

%% Set input

% TLE
TLE = "25544 ISS (ZARYA).txt";
t = [0:60:48*hr]; %MUST BE GREATER THAN 1 PERIOD

% measurment
t_1 = .3;
t_2 = .5;


%% Propogate orbit

[OE, x_h] = createOrbit(TLE, t);

% standard TBP check
OE = OEfromTLE("25544 ISS (ZARYA).txt")
[r_0, v_0] = OE2rv(OE);
initCond = [r_0; v_0];
options = odeset('AbsTol',1e-9,'RelTol',1e-6);
[~,x] = ode45('TBP', t, initCond, options);
r = x(:,1:3);

[t_h,x_h] = ode45('TBP_Harmonics', t, initCond, options);
r_h = x_h(:,1:3)

figure()
grid on
hold on
plot3(r(:,1),r(:,2),r(:,3))
plot3(r_h(:,1),r_h(:,2),r_h(:,3))
hold off

%% Create measurment

