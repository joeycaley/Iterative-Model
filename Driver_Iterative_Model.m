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

J2_truth = 1082.63*10^-6;

%% Set inputs and settings

%-TLE---------------------------------------------------------------------%
% TLE = "25544 ISS (ZARYA).txt";
TLE = "MOLNIYA-3-50.txt";
% TLE = 'LANDSAT-7.txt';


%-MEASUREMENT SETTINGS----------------------------------------------------%
t_msmtFrac = [.05:.1:.25]; %as a fraction of orbit period, NO NEGATIVES
msmt_type = 2;
% 1: range msmt, perfect with no noise
% 2: range msmt with noise


%-SOLVER------------------------------------------------------------------%
solv_type = 2;
% 1: start prop from 0 each time
% 2: start prop from prev msmt


%-GAINS-------------------------------------------------------------------%
Kp = -1.0e-8;


%-INITIAL J2 GUESS--------------------------------------------------------%
J2_estInit = 1*10^-3;
% J2_estInit = 6.484993079129698e-04;
% J2_estInit = J2_truth;


%-MAX NUMBER OF ITERATIONS------------------------------------------------%
max_iter = 125;


%-SEED--------------------------------------------------------------------%
rng(0)


%% Propogate orbit

% harmonics dynamics
[OE, x_h, t_msmt, initCond] = createOrbit(TLE, t_msmtFrac);
r_orbit = x_h(:,1:3);
v_orbit = x_h(:,4:6);

% standard TBP check
% OE = OEfromTLE("25544 ISS (ZARYA).txt");
% [r_0, v_0] = OE2rv(OE);
% initCond = [r_0; v_0];
% options = odeset('AbsTol',1e-9,'RelTol',1e-6);
% [~,x] = ode45('TBP', t, initCond, options);
% r_2BP = x(:,1:3);

%% Create measurment
num_msmt = length(t_msmt);
a = OE(1);
P = 2*pi*sqrt(a^3/mu_e);

[r_msmt, dr_msmt] = create_msmt(msmt_type, t_msmtFrac, r_orbit);

% for i = 1:num_msmt
%     [r_msmt(i), dr_msmt(i)] = create_msmt(msmt_type, t_msmt(i), P, r_orbit);
% end

%% Setup first run

J2_est = J2_estInit;

% viable solver types
viable_solv = [1 2];

% create histories
r_estHist = zeros(max_iter, length(t_msmt));
err_hist = zeros(max_iter, length(t_msmt) + 1);
J2_estHist = zeros(max_iter, length(t_msmt) + 1);

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

            % calculate mean error and J2 estimate after last measurement run
            if j == num_msmt
                err_hist(i,j+1) = mean(err_hist(i,1:j));
                J2_estHist(i,j+1) = mean(J2_estHist(i,1:j));
            end
        end
    end
else
    error("ERROR SOLVER TYPE UNDEFINED")
end

format shortEng

fprintf("\nTRUE J2:          ")
disp(J2_truth)

fprintf("FINAL J2 ESTIMATE:")
disp(J2_estHist(end,end))

format short

%% Plot
Plot_Iterative_Model
