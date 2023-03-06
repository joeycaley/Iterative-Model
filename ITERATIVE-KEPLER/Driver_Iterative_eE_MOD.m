clear; close all; clc;
global mu_earth;

addpath('iterKepfunctions\')

% unit conversions
HR = 3600;
dtr = pi/180;
mue = 3.986004e14;
Re = 6378.14e3;
km = 1e3;
mu_earth = mue;

%% establish baseline orbit
% Orbital elements
a_nom = 9000*km; e_nom = 0.20;
i_nom = 52*dtr; OM_nom = 96*dtr; om_nom = 117*dtr; f0_nom = 30*dtr;
orb_nom = [a_nom; e_nom; i_nom; OM_nom; om_nom; f0_nom]; %[a, e, i, OM, om, f0]

orbit_setup

%% Set up the iterations USER INPUT
%measurements
t1m = 0.20*P_nom;   %og first measurement @ clock time: 20% of period
t2m = 0.40*P_nom;   %og second measurement @ clock time: 40% of period

[f1_nom, E1_nom, r1m, rd1m] = createMeasurement(mue, orb_nom, t, xhis, t1m);
[f2_nom, E2_nom, r2m, rd2m] = createMeasurement(mue, orb_nom, t, xhis, t2m);

%initiate iterations with max number of iterations
iternum = 500;  %max number of iterations

% set initial condition
e_curr = 0.5; 

iter_setup

%% begin estimation
e_est(1) = e_curr;
fac_curr = sqrt((1 - e_curr)/(1 + e_curr));
p_curr = a_nom*(1 - e_curr^2);
f1_estm = acos((p_curr/r1m - 1)/e_curr); % r = p/(1+e*cosf)
f2_estm = acos((p_curr/r2m - 1)/e_curr);

% modify estimates based on where in orbit
if rd1m < 0
    f1_estm = f1_estm + pi;
end
if rd2m < 0
    f2_estm = f2_estm + pi;
end

E1_estm = 2*atan(fac_curr*tan(f1_estm/2));
E2_estm = 2*atan(fac_curr*tan(f2_estm/2));

%%%generate error signal: kepler's solver
DM = n_nom*(t2m - t1m);
M1_estm = E1_estm - e_curr*sin(E1_estm);    %from measurement
M2_est = M1_estm + DM;
[E2_est, Ehis, kerrhis] = solvekepler(M2_est, e_curr);

err_curr = E2_est - E2_estm;

err_his(1) = err_curr;
E2_his(1) = E2_est;
E2m_his(1) = E2_estm;

ictr = ictr+1;

%% GAIN
G_p = 0.010;
G_i = 0.000;

%% Iterations
while abs(err_curr) > thres && ictr < iternum && err_flag == 0
%     e_curr = e_curr - G_p*err_curr;
    e_curr = e_curr - G_p*err_curr - G_i*sum(err_his);
    e_est(ictr) = e_curr;
    
    if e_curr >= 0 
        %update Eccentric anomaly
        p_curr = a_nom*(1 - e_curr^2); % parameter
        fac_curr = sqrt((1 - e_curr)/(1 + e_curr)); %factor for eccentric to true conversion
        
        %true and eccentric anomalies from measurement
        f1_estm = acos((p_curr/r1m - 1)/e_curr);
        f2_estm = acos((p_curr/r2m - 1)/e_curr);
        
        if rd1m < 0
            f1_estm = f1_estm + pi;
        end
        if rd2m < 0
            f2_estm = f2_estm + pi;
        end
        
        E1_estm = 2*atan(fac_curr*tan(f1_estm/2));
        E2_estm = 2*atan(fac_curr*tan(f2_estm/2));
        
        if E1_estm < 0
            E1_estm = 2*pi+E1_estm;
        end
        if E2_estm < 0
            E2_estm = 2*pi+E2_estm;
        end
        
        M1_estm = E1_estm - e_curr*sin(E1_estm);    %from measurement
        M2_est = M1_estm + DM; 
        [E2_est, Ehis, kerrhis] = solvekepler(M2_est, e_curr); %LIKELY WHERE WE'RE SEEING ERROR
        
        err_curr = E2_est - E2_estm; %loop's E2 - measured E2
        
        err_his(ictr) = err_curr;
        E2_his(ictr) = E2_est; %loop's E2, mapped with Kepler's Equation
        E2m_his(ictr) = E2_estm; %measured E2
        
        ictr = ictr + 1;
    
    else %in case of negative eccentricity (which is not possible)
        err_flag = 1;
        fprintf("ERROR NEGATIVE ECCENTRICITY\n");
    end
end

%% Plot outputs
Plot_Iterative_eE;


