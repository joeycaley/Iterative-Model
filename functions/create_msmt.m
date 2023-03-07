function [msmt, rdm] = create_msmt(msmt_type, posInOrbit, r)
% Create measurement at a given time (t_m, fraction of period) for a given 
% set of orbit data (P (sec), r (m), and t (sec)) of a given measurement 
% type (msmt_type). Assume geocentric orbit.
%
% INPUT: 
%       msmt_type: what is being measured/outputted
%           1: range, deterministic
%           2: range, with noise
%       t_m: time of measurement as a fraction of period
%       r: radius vector of orbit over time
%      
% OUTPUT:
%       msmt: measurement of the selected type
%       rdm: direction of travel in orbit (+1 for getting further away and
%            -1 for getting closer to periapsis)

global mu_e

noise = 100; %set noise parameter for noisy msmt, in meters

if msmt_type == 1
    msmt = sqrt(r(:,1).^2 + r(:,2).^2 + r(:,3).^2);

    posInOrbit = posInOrbit - floor(posInOrbit);

    for i = 1:length(posInOrbit)
        if posInOrbit(i) < .5
            rdm(i) = +1;
        else % posInOrbit(i) >= .5
            rdm(i) = -1;
        end
    end

elseif msmt_type == 2
    msmt = sqrt(r(:,1).^2 + r(:,2).^2 + r(:,3).^2);
    msmt = msmt + randn(length(posInOrbit),1)*noise;

    posInOrbit = posInOrbit - floor(posInOrbit);

    for i = 1:length(posInOrbit)
        if posInOrbit(i) < .5
            rdm(i) = +1;
        else % posInOrbit(i) >= .5
            rdm(i) = -1;
        end
    end
else
    error("MEASUREMENT TYPE UNDEFINED")
end


end