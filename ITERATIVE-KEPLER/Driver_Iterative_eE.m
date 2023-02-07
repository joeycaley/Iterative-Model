clear; close all; clc;
global mu_earth;

HR =3600;
dtr = pi/180;
mue = 3.986004e14;
Re = 6378.14e3;
km = 1e3;
mu_earth = mue;

%%%establish baseline orbit
a_nom = 9000*km; e_nom = 0.20;
i_nom = 52*dtr; OM_nom = 96*dtr; om_nom = 117*dtr; f0_nom = 30*dtr;
orb_nom = [a_nom; e_nom; i_nom; OM_nom; om_nom; f0_nom]; %[a, e, i, OM, om, f0]
brv0 = RVfromOE(mue, orb_nom);
br0 = brv0(:,1);
bv0 = brv0(:,2);
n_nom = sqrt(mue/a_nom^3);
P_nom = 2*pi/n_nom;
%%%sanity checks:
rp_nom =  a_nom*(1 - e_nom);
ra_nom = a_nom*(1 + e_nom);
%%%propagate full orbit
tlen = 1000;
this = linspace(0, P_nom, tlen);
options = odeset('RelTol', 1e-12);
[t, xhis] = ode45('keplerianmotion', this, [br0; bv0], options);
figure(1); hold on;
draworbit(orb_nom, 1, 2, 'k', 'b', 0)
axis([-1 1 -1 1 -1 1]*ra_nom);

%%%Set up the iterations
%measurements
t1m = 0.20*P_nom;   %first measurement @ clock time: 20% of period
t2m = 0.40*P_nom;   %second measurement @ clock time: 40% of period
[f1_nom, E1_nom] = getfEnom(mue, orb_nom, t1m);
[f2_nom, E2_nom] = getfEnom(mue, orb_nom, t2m);

brv1m = interp1(t, xhis, t1m); %getmeas(t1);
brv2m = interp1(t, xhis, t2m);
rnois = randn(2,1)*50;
r1m = norm(brv1m(1:3)) + rnois(1);
r2m = norm(brv2m(1:3)) + rnois(2);
%initiate iterations
iternum = 500;  %max number of iterations
e_est = zeros(iternum, 1);
err_his = zeros(iternum, 1);
E2_his = zeros(iternum, 1);
e_curr = 0.5; 
e_est(1) = e_curr;
fac_curr = sqrt((1 - e_curr)/(1 + e_curr));
p_curr = a_nom*(1 - e_curr^2);
f1_estm = acos((p_curr/r1m - 1)/e_curr);
f2_estm = acos((p_curr/r2m - 1)/e_curr);
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
%%%kick-start iterations
thres = 1e-3;
ictr = 2;
%%%GAIN
G = 0.015;
while abs(err_curr) > thres && ictr < iternum
    e_curr = e_curr - G*err_curr;
    e_est(ictr) = e_curr;
    %%%update Eccentric anomaly
    p_curr = a_nom*(1 - e_curr^2);
    fac_curr = sqrt((1 - e_curr)/(1 + e_curr));
    %%%true and eccentric anomalies from measurement
    f1_estm = acos((p_curr/r1m - 1)/e_curr);
    f2_estm = acos((p_curr/r2m - 1)/e_curr);
    E1_estm = 2*atan(fac_curr*tan(f1_estm/2));
    E2_estm = 2*atan(fac_curr*tan(f2_estm/2));
    M1_estm = E1_estm - e_curr*sin(E1_estm);    %from measurement
    M2_est = M1_estm + DM;
    [E2_est, Ehis, kerrhis] = solvekepler(M2_est, e_curr);
    err_curr = E2_est - E2_estm;
    err_his(ictr) = err_curr;
    E2_his(ictr) = E2_est;
    ictr = ictr + 1;
end

figure(2)
plot(1:ictr-1, e_est(1:ictr-1), 'b', 'linewidth', 2);
hold on
plot(1:ictr-1, e_nom*ones(ictr-1,1), 'r:', 'linewidth', 2);
grid on;
xlabel('Iteration #');
ylabel('Estimated Eccentricity');
legend('Estimated', 'Truth');
set(gca, 'fontsize', 14, 'fontweight', 'bold');

figure(3)
plot(1:ictr-1, E2_his(1:ictr-1), 'b', 'linewidth', 2);
hold on
plot(1:ictr-1, E2_nom*ones(ictr-1,1), 'r:', 'linewidth', 2);
grid on;
xlabel('Iteration #');
ylabel('Estimated Eccentric Anomaly @ t_2 (rad)');
legend('Estimated', 'Truth', 'location', 'se');
set(gca, 'fontsize', 14, 'fontweight', 'bold');

figure(4)
plot(1:ictr-1, err_his(1:ictr-1), 'b', 'linewidth', 2);
grid on;
xlabel('Iteration #');
ylabel('Error Signal Magnitude');
set(gca, 'fontsize', 14, 'fontweight', 'bold');


