function [OE, x_his, initCond] = createOrbit(TLE,t)
% Create an orbit with TBP harmonic dynamics for a given two line element 
% set text tile (TLE, written in the form of the file name) for some 
% duration (t, seconds).
%
% Return: the orbit's orbital elements (OE in the form a, e, i, RAAN, argP,

global AbsTol RelTol

OE = OEfromTLE(TLE);

[r_0, v_0] = OE2rv(OE);

initCond = [r_0; v_0];

options = odeset('AbsTol',AbsTol,'RelTol',RelTol);
[~, x_his] = ode45('TBP_Harmonics', t, initCond, options);

end