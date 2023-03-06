function [msmt, rdm] = create_msmt(msmt_type, t_m, P, r, t)
% Create measurement at a given time (t_m, fraction of period) for a given 
% set of orbit data (P (sec), r (m), and t (sec)) of a given measurement 
% type (msmt_type). Assume geocentric orbit.
%
% INPUT: 
%       msmt_type: what is being measured
%           1: range, deterministic
%       t_m: time of measurement
%       P: period of orbit (sec)
%       r: radius vector of orbit over time
%       t: time duration that orbital data is given over
%      
% OUTPUT:
%       msmt: measurement of a selected type
%           1. range, deterministic (m)
%       rdm: direction of travel in orbit (+1 for getting further away and
%            -1 for getting closer to periapsis)

global mu_e

if msmt_type == 1
    msmt = interp1(t, r, t_m); %getmeas(t);
    msmt = norm(msmt);

    posInOrbit = t_m/P - floor(t_m/P);

    if posInOrbit <= .5
        rdm = +1;
    else % posInOrbit > .5
        rdm = -1;
    end
else
    error("MEASUREMENT TYPE UNDEFINED")
end


end