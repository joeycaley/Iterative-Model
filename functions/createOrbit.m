function [OE, x_his] = createOrbit(TLE,t)

OE = OEfromTLE("25544 ISS (ZARYA).txt");
[r_0, v_0] = OE2rv(OE);

initCond = [r_0; v_0];

options = odeset('AbsTol',1e-9,'RelTol',1e-6);
[~, x_his] = ode45('TBP_Harmonics', t, initCond, options);

end