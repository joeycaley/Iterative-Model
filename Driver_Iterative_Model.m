clear; close all; clc;

addpath('functions')

% unit conversions
hr = 3600;
deg2rad = pi/180;
mu_e = 3.986004e14;
R_e = 6378.14e3;
km = 1e3;

%% Set input
OE = OEfromTLE("25544 ISS (ZARYA).txt")
[r_0, v_0] = OE2rv(OE);

% r_0 = [-4580.3; 6582.7; -180.95]*km; %m
% v_0 = [-5.8396; 3.0075; 1.758]*km; %m/s

initCond = [r_0; v_0];


%% Propogate forward
t = [0:60:48*hr];
options = odeset('AbsTol',1e-9,'RelTol',1e-6);
[~,x] = ode45('TBP', t, initCond, options);
[t_h,x_h] = ode45('TBP_Harmonics', t, initCond, options);

r = x(:,1:3);
r_h = x_h(:,1:3)

figure()
grid on
hold on
plot3(r(:,1),r(:,2),r(:,3))
plot3(r_h(:,1),r_h(:,2),r_h(:,3))