function [r_I, v_I] = TLE2rv(i, RAAN, e, argP, M, n)
% Convert orbital data from a two-line element set [inclination (radians), 
% right ascension of ascending node (radians), eccentricity (unitless),
% argument of perigee (radians), mean anamoly (radians), mean motion
% (radians/s)] to radius (m) and velocity (m/s) vectors in the Earth
% centered inertial frame

mu = 3.986004*10^14;

% semi-major axis
a = (mu/n^2)^(1/3); %meters

% parameter
p = a*(1-e^2); %meters

% energy
energy = -mu/(2*a); %m^2/s^2

% period
P = 2*pi/n; %seconds

% magnitude of angular momentum vector
h_mag = sqrt(mu*p); %m^2/s

% eccentric Anamoly
E = newtonRapsonKepler(M,e); %radians

% true Anamoly                                      SOURCE OF ERRORRRRRRRRR
f = 2*atan(sqrt((1+e)/(1-e))*tan(E/2)); %radians

% magnitude of r and v
r_mag = p/(1 + e*cos(f)); %meters     POTENTIAL TO IMPROVEEEEEEEEEEEEEEEEEEE
v_mag = sqrt(2*(energy + mu/r_mag));

% determination of r and v in orbital frame
r_O = [r_mag*cos(f); r_mag*sin(f); 0];

f_dot = h_mag/r_mag^2;
r_dot = h_mag*e/p*sin(f);

v_O = [r_dot*cos(f) - r_mag*f_dot*sin(f); r_dot*sin(f)+r_mag*f_dot*cos(f);0];

% create the DCM using 3-1-3 euler angles 
cw = cos(argP);
co = cos(RAAN);
ci = cos(i);
sw = sin(argP);
so = sin(RAAN);
si = sin(i);

R_OI = [cw*co-sw*ci*so   , cw*so+sw*ci*co , sw*si; ...
        -(sw*co+cw*ci*so), -sw*so+cw*ci*co, cw*si; ...
        si*so            , -si*co         , ci];
R_IO = R_OI';

% transform r and v from orbital to inertial frame
r_I = R_IO*r_O;
v_I = R_IO*v_O;

end