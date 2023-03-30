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
t_msmtFrac = [.05:.1:.45]; %as a fraction of orbit period, NO NEGATIVES
msmt_type = 1;
% 1: range msmt, perfect with no noise
% 2: range msmt with noise
% 3: range msmt with noise AND a bad measurement


%-SOLVER------------------------------------------------------------------%
solv_type = 4;
% 1: prop to all msmts in sequence each loop, start prop from 0 each time
% 2: prop to all msmts in sequence each loop, start prop from prev msmt
% 3: loop over one msmt at a time, start prop from 0 each time
% 4: loop over one msmt at a time, start prop from prev msmt

%-GAINS-------------------------------------------------------------------%
% Kp = 1.0e-8; % works for sovler 1 & 2. + for ISS/LANDSAT, - for Molniya
Kp = 0.9e-9;


%-INITIAL J2 GUESS--------------------------------------------------------%
J2_estInit = 1000*10^-6;
% J2_estInit = 6.484993079129698e-04;
% J2_estInit = J2_truth;


%-MAX NUMBER OF ITERATIONS------------------------------------------------%
max_iter = 100;


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

% if max(solv_type == viable_solv)
%     for i = 1:max_iter
%         for j = 1:num_msmt
%         
%             % Set initial condition depending on solver & msmt #
%             if solv_type == 2 && j ~= 1
%                 initCondLoop = x_loop(end)';
%             else
%                 initCondLoop = initCond;
%             end
%     
%             % propogate
%             options = odeset('AbsTol',AbsTol,'RelTol',RelTol);
%     
%             [t_loop,x_loop] = ode45(@(t_loop,x_loop) TBP_UnknownHarmonics(...
%                 t_loop,x_loop,J2_est), [0 t_msmt(j)], initCond, options);
%     
%             % create final range
%             r_est = norm(x_loop(end,1:3));
%     
%             % Error and correction
%             err = r_est - r_msmt(j);
%             J2_est = J2_est - Kp*err;
%     
%             % input histories
%             err_hist(i,j) = err;
%             r_estHist(i,j) = r_est;
%             J2_estHist(i,j) = J2_est;
% 
%             % calculate mean error and J2 estimate after last measurement run
%             if j == num_msmt
%                 err_hist(i,j+1) = mean(err_hist(i,1:j));
%                 J2_estHist(i,j+1) = mean(J2_estHist(i,1:j));
%             end
%         end
%     end
% else
%     error("ERROR SOLVER TYPE UNDEFINED")
% end

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
