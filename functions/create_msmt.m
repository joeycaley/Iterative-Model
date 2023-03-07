function [msmt, rdm] = create_msmt(msmt_type, t_m, P, r, t)
% Create measurement at a given time (t_m, fraction of period) for a given 
% set of orbit data (P (sec), r (m), and t (sec)) of a given measurement 
% type (msmt_type). Assume geocentric orbit.
%
% INPUT: 
%       msmt_type: what is being measured/outputted
%           1: range, deterministic
%           2: range, with noise
%       t_m: time of measurement
%       P: period of orbit (sec)
%       r: radius vector of orbit over time
%       t: time duration that orbital data is given over
%      
% OUTPUT:
%       msmt: measurement of the selected type
%       rdm: direction of travel in orbit (+1 for getting further away and
%            -1 for getting closer to periapsis)

global mu_e

noise = 100; %set noise parameter for noisy msmt, in meters

if msmt_type == 1
    msmt = interp1(t, r, t_m); %getmeas(t);
    msmt = norm(msmt);

    posInOrbit = t_m/P - floor(t_m/P);

    if posInOrbit <= .5
        rdm = +1;
    else % posInOrbit > .5
        rdm = -1;
    end
elseif msmt_type == 2
    msmt = interp1(t, r, t_m); %getmeas(t);
    msmt = norm(msmt) + randn*noise;

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