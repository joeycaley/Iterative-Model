clear; close all;

restoredefaultpath
addpath('functions\')
addpath('TLE\')

global hr deg2rad mu_e R_e km AbsTol RelTol

% unit conversions & constants
hr = 3600;
deg2rad = pi/180;
mu_e = 3.986004e14;
R_e = 6378.14e3;
km = 1e3;
AbsTol = 1e-9;
RelTol = 1e-8;

J2 = 1082.63*10^-6;

%% Set input and settings

% TLE
TLE = "25544 ISS (ZARYA).txt";
% TLE = "MOLNIYA-3-50.txt";
% TLE = 'LANDSAT-7.txt';
t = [0:1:48*hr]; %MUST BE GREATER THAN 1 PERIOD

% measurment time as function of period
t_msmt = [.05:.1:.6];
msmt_type = 1;
% 1: range msmt


% solver
solv_type = 2;
% 1: start prop from 0 each time
% 2: start prop from prev msmt

% gains
Kp = 1.0e-8;

% initial guess
J2_estInit = 1*10^-3;
% J2_estInit = 6.484993079129698e-04;
% J2_estInit = 1082.63*10^-6;

% Max number of iterations
max_iter = 50;

%% Propogate orbit

% harmonics dynamics
[OE, x_h, initCond] = createOrbit(TLE, t);
r_orbit = x_h(:,1:3);
v_orbit = x_h(:,4:6);

% standard TBP check
% OE = OEfromTLE("25544 ISS (ZARYA).txt");
% [r_0, v_0] = OE2rv(OE);
% initCond = [r_0; v_0];
% options = odeset('AbsTol',1e-9,'RelTol',1e-6);
% [~,x] = ode45('TBP', t, initCond, options);
% r_2BP = x(:,1:3);

% plot
figure()
grid on
hold on
% plot3(r_2BP(:,1),r_2BP(:,2),r_2BP(:,3))
plot3(r_orbit(:,1),r_orbit(:,2),r_orbit(:,3),'r')
plot3(0,0,0,'.b','MarkerSize',40)
hold off

%% Create measurment

% convert to times
a = OE(1);
P = 2*pi*sqrt(a^3/mu_e);
t_msmt = t_msmt*P;
num_msmt = length(t_msmt);

for i = 1:num_msmt
    [r_msmt(i), dr_msmt(i)] = create_msmt(msmt_type, t_msmt(i), P, r_orbit, t);
end

%% Setup first run

J2_est = J2_estInit;

% viable solver types
viable_solv = [1 2];

% create histories
r_estHist = zeros(max_iter, length(t_msmt));
err_hist = zeros(max_iter, length(t_msmt));
J2_estHist = zeros(max_iter, length(t_msmt));

%% Iterations

if max(solv_type == viable_solv)
    for i = 1:max_iter
        for j = 1:num_msmt
        
            % Set initial condition depending on solver & msmt #
            if solv_type == 2 && j ~= 1
                initCondLoop = x_loop(end)';
            else
                initCondLoop = initCond;
            end
    
            % propogate
            options = odeset('AbsTol',AbsTol,'RelTol',RelTol);
    
            [t_loop,x_loop] = ode45(@(t_loop,x_loop) TBP_UnknownHarmonics(...
                t_loop,x_loop,J2_est), [0 t_msmt(j)], initCond, options);
    
            % create final range
            r_est = norm(x_loop(end,1:3));
    
            % Error and correction
            err = r_est - r_msmt(j);
            J2_est = J2_est - Kp*err;
    
            % input histories
            err_hist(i,j) = err;
            r_estHist(i,j) = r_est;
            J2_estHist(i,j) = J2_est;
        end
    end
else
    error("ERROR SOLVER TYPE UNDEFINED")
end


%% Plot
Plot_Iterative_Model
