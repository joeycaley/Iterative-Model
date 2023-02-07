% Convert to position and velocity vectors
brv0 = RVfromOE(mue, orb_nom);
br0 = brv0(:,1);
bv0 = brv0(:,2);

% Period and mean motion
n_nom = sqrt(mue/a_nom^3);
P_nom = 2*pi/n_nom;

%% sanity checks:
% calculate peri/apo-apsis
rp_nom =  a_nom*(1 - e_nom);
ra_nom = a_nom*(1 + e_nom);

%% propagate full orbit
tlen = 1000;
this = linspace(0, P_nom, tlen);
options = odeset('RelTol', 1e-12);
[t, xhis] = ode45('keplerianmotion', this, [br0; bv0], options);
% figure(1); hold on;
% draworbit(orb_nom, 1, 2, 'k', 'b', 0)
% axis([-1 1 -1 1 -1 1]*ra_nom);