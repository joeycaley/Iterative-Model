clear; close all;

restoredefaultpath
addpath('functions')

global hr deg2rad mu_e R_e km

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
t1 = .3;
t2 = .5;

% gains
G = 0.010;

% initial guess
J2 = 1*10^-6;


%% Propogate orbit

% harmonics dynamics
[OE, x_h] = createOrbit(TLE, t);
r_h = x_h(:,1:3);

% standard TBP check
OE = OEfromTLE("25544 ISS (ZARYA).txt")
[r_0, v_0] = OE2rv(OE);
initCond = [r_0; v_0];
options = odeset('AbsTol',1e-9,'RelTol',1e-6);
[~,x] = ode45('TBP', t, initCond, options);
r = x(:,1:3);

figure()
grid on
hold on
plot3(r(:,1),r(:,2),r(:,3))
plot3(r_h(:,1),r_h(:,2),r_h(:,3))
hold off

%% Create measurment

[r1, rd1m] = create_msmt(t1, OE, r, t, 1);
[r2, rd2m] = create_msmt(t2, OE, r, t, 1);

