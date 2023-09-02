function [OE, x_out, t_out, initCond] = createOrbit(TLE,t)
% Create an orbit with TBP harmonic dynamics for a given two line element 
% set text tile (TLE, written in the form of the file name) at some 
% measurement times (t, seconds). Also visually show the orbit
%
% INPUT:
%       TLE: two line element set, written in the form of the file name
%       t: time of the measurements, written as a function of the orbit's
%       period
%
% OUTPUT:
%       OE: Orbital elements of the orbit, in the form [a (m), e, i (rad), 
%       RAAN (rad), w/arg of Peri (rad), f (rad)]
%       x_out: Positions (m) and velocity (m/s) of orbit at each
%       measurement time written in the form [x, y, z, x_dot, y_dot, z_dot]
%       t_out: Time of each measurement in seconds
%       initCond: Return inital position (m) and velocity (m/s) of orbit in
%       the form [x_0, y_0, z_0; x_dot_0, y_dot_0, z_dot_0]

global AbsTol RelTol mu_e

OE = OEfromTLE(TLE);

[r_0, v_0] = OE2rv(OE);

initCond = [r_0; v_0];

% convert to measurement times to seconds
a = OE(1);
P = 2*pi*sqrt(a^3/mu_e);
t = t*P;

% create output
options = odeset('AbsTol',AbsTol,'RelTol',RelTol);
[t_out, x_out] = ode45('TBP_Harmonics', [0 t], initCond, options);

t_out = t_out(2:end);
x_out = x_out(2:end,:);

% show visually the orbit for 10 periods
t_plot = 0:1:10*P;

% create output to plot
[~, x_plot] = ode45('TBP_Harmonics', t_plot, initCond, options);

% plot
% figure()
% grid on
% hold on
% plot3(x_plot(:,1),x_plot(:,2),x_plot(:,3),'r')
% plot3(0,0,0,'.b','MarkerSize',40)
% hold off

end