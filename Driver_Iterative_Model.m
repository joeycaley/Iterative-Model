clear; close all;
restoredefaultpath

addpath('functions\')
addpath('TLE\')

global hr deg2rad mu_e R_e km AbsTol RelTol num_msmt

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
TLE = "25544 ISS (ZARYA).txt";
% TLE = "MOLNIYA-3-50.txt";
% TLE = 'LANDSAT-7.txt';


%-MEASUREMENT SETTINGS----------------------------------------------------%
t_msmtFrac = [.05:.1:.55]; %as a fraction of orbit period, NO NEGATIVES
% t_msmtFrac = [.05:.1:.45];
msmt_type = 3;
% 1 PERFECT: range msmt, perfect with no noise
% 2 NOISY:   range msmt with noise
% 3 FLAWED:  range msmt with noise AND a bad measurement


%-SOLVER------------------------------------------------------------------%
solv_type = 3;
% 1: prop to all msmts in sequence each loop, start prop from 0 each time
% 2: prop to all msmts in sequence each loop, start prop from prev msmt
% 3: loop over one msmt at a time, start prop from 0 each time
% 4: loop over one msmt at a time, start prop from prev msmt

%-GAINS-------------------------------------------------------------------%
Kp = 1.0e-8; % works for sovler 1 & 2. + for ISS/LANDSAT, - for Molniya
% Kp = 7.0e-10;


%-INITIAL J2 GUESS--------------------------------------------------------%
J2_estInit = 1000*10^-5;
% J2_estInit = 1000*10^-6;
% J2_estInit = 6.484993079129698e-04;
% J2_estInit = J2_truth;


%-MAX NUMBER OF ITERATIONS------------------------------------------------%
max_iter = 100;
% max_iter = 250;


%-SEED--------------------------------------------------------------------%
rng(0)


%% Propogate orbit

% harmonics dynamics
[OE, x_h, t_msmt, initCond] = createOrbit(TLE, t_msmtFrac);
r_orbit = x_h(:,1:3);
v_orbit = x_h(:,4:6);

%% Create measurment

num_msmt = length(t_msmt);

[r_msmt, dr_msmt] = create_msmt(msmt_type, t_msmtFrac, r_orbit);

%% Setup first run

% viable solver types
viable_solv = [1 2];

% create histories
r_estHist = zeros(max_iter, length(t_msmt));
err_hist = zeros(max_iter, length(t_msmt) + 1);
J2_estHist = zeros(max_iter, length(t_msmt) + 1);

% initialize J2_est
J2_est = J2_estInit;

%% Iterations

[J2_estHist, r_estHist, err_hist] = iterative_solver(solv_type, r_msmt, ...
    dr_msmt, t_msmt, J2_estInit, Kp, max_iter, initCond);

format shortEng

fprintf("\nTRUE J2:          ")
disp(J2_truth)

fprintf("FINAL J2 ESTIMATE:")
disp(J2_estHist(end,end))

format short

%% Plot
if solv_type < 3
    Plot_Iterative_Model
else
    Plot_Iterative_Model_TEMP
end
