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

%% Set input and settings

% TLE
TLE = "25544 ISS (ZARYA).txt";
t = [0:60:48*hr]; %MUST BE GREATER THAN 1 PERIOD

% measurment time as function of period
t_m = [.3 .5];

% gains
G = 0.010;

% initial guess
J2est = 1*10^-6;

% Max number of iterations
maxiter = 500;

%% Propogate orbit

% harmonics dynamics
[OE, x_h, initCond] = createOrbit(TLE, t);
r_orbit = x_h(:,1:3);

% standard TBP check
OE = OEfromTLE("25544 ISS (ZARYA).txt");
[r_0, v_0] = OE2rv(OE);
initCond = [r_0; v_0];
options = odeset('AbsTol',1e-9,'RelTol',1e-6);
[~,x] = ode45('TBP', t, initCond, options);
r_2BP = x(:,1:3);

% plot
figure()
grid on
hold on
plot3(r_2BP(:,1),r_2BP(:,2),r_2BP(:,3))
plot3(r_orbit(:,1),r_orbit(:,2),r_orbit(:,3))
hold off

%% Create measurment

% convert to times
a = OE(1);
P = 2*pi*sqrt(a^3/mu_e);
t_m = t_m*P;

for i = 1:length(t_m)
    [r_m(i), r_dm(i)] = create_msmt(1, t_m(i), P, r_orbit, t);
end

%% Setup first run

% create histories
J2est_hist = zeros(maxiter,1);
r2est_hist = zeros(maxiter,1);


options = odeset('AbsTol',1e-9,'RelTol',1e-6);
[~,x] = ode45('TBP', t, initCond, options);

%% Iterations

for i = 2:maxiter
    
    

end
