function [msmt, rdm] = create_msmt(t_m, OE, r, t, msmt_type)
% Create measurement at a given time (t_m, fraction of period) for a given 
% set of orbit data (OE, r (m), and t (sec)) of a given measurement type 
% (msmt_type). Assume geocentric orbit.
%
% INPUT: 
%       t_m: time of measurement as a fraction of orbital period.
%       OE: orbital elements of orbit [a, e, i, RAAN, argP, f]
%       r: radius vector of orbit over time
%       t: time duration that orbital data is given over
%       msmt_type: what is being measured
%           1: range, deterministic
%
% OUTPUT:
%       msmt: measurement of a selected type
%           1. range, deterministic (m)
%       rdm: direction of travel in orbit (+1 for getting further away and
%            -1 for getting closer to periapsis)

global mu_e

a = OE(1);

P = 2*pi*sqrt(a^3/mu_e);

if msmt_type == 1
    msmt = interp1(t, r, t_m*P); %getmeas(t);
    msmt = norm(msmt);

    posInOrbit = t - floor(t);

    if posInOrbit <= .5
        rdm = +1;
    else % posInOrbit > .5
        rdm = -1;
    end
else
    error("MEASUREMENT TYPE UNDEFINED")
end


end