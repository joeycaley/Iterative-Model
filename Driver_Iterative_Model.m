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
t_msmt = [.3 .5];

% gains
Kp = 0.010;

% initial guess
J2est = 1*10^-6;

% Max number of iterations
maxiter = 500;

%% Propogate orbit

% harmonics dynamics
[OE, x_h, initCond] = createOrbit(TLE, t);
r_orbit = x_h(:,1:3);
v_orbit = x_h(:,4:6);

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
t_msmt = t_msmt*P;

for i = 1:length(t_msmt)
    [r_msmt(i), dr_msmt(i)] = create_msmt(1, t_msmt(i), P, r_orbit, t);
end

%% Setup first run

% create histories
rest_hist = zeros(maxiter, length(t_msmt));
err_hist = zeros(maxiter, length(t_msmt));
J2est_hist = zeros(maxiter, length(t_msmt));

%% Iterations

for i = 1:maxiter
    for j = 1:length(t_msmt)
        % Propogate from 0
        options = odeset('AbsTol',1e-9,'RelTol',1e-6);
        [t_loop,x_loop] = ode45(@(t_loop,x_loop) TBP_UnknownHarmonics(...
            t_loop,x_loop,J2est), [0 t_msmt(j)], initCond, options);
        r_est = norm(x_loop(end,1:3));

        err = r_est - r_msmt(j);
        J2est = J2est - Kp*err;

        % input histories
        err_hist(i,j) = err;
        rest_hist(i,j) = r_est;
        J2est_hist(i,j) = J2est;
    end
end
