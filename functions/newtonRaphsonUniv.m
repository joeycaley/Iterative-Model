function chi_final = newtonRaphsonUniv(deltaT, r_0, sigma_0, alpha, mu)
% Find chi at some time (deltaT) for a given inital radius magnitude, r_0 
% (m), initial sigma, sigma_0 (??), alpha, and gravitational constant, mu
% (m^3/s)

% POSSIBLY VARARGIN TO DEFINE EPSILON AND MAX # OF ITERATIONS, AND MAYBE
% FUNCTION TO SOLVE?

epsilon = 10^-15; %stopping criteria
N = 1000; %max number of iterations

chi(1) = sqrt(mu)/r_0*deltaT;
k = 1;
chiFlag = 0;

while chiFlag == 0
    U = universalFunc(alpha, chi(k));
    deltaChi(k+1) = ...
        (sqrt(mu)*deltaT - (r_0*U(2) + sigma_0*U(3) + U(4))) /...
        (r_0*U(1) + sigma_0*U(2) + U(3));
    chi(k+1) = chi(k) + deltaChi(k+1);
    
    if abs(deltaChi(k+1)) < epsilon || k > N
        chiFlag = 1;
    else
        k = k + 1;
    end
end

if k > N
    fprintf("exceeded max number of iterations\n")
end

chi_final = chi(end);

end