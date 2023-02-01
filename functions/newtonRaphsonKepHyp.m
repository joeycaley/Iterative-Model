function [F_final, k] = newtonRaphsonKepHyp(M, F_init, e, epsilon)
% Find hyperbolic eccentric anamoly, F (rad), for a given mean anamoly, M 
% (rad), initial guess for F, F(0) (rad), eccentricity, e, and epsilon 
% (rad) for a hyperbolic orbit.

% POSSIBLY VARARGIN TO DEFINE EPSILON AND MAX # OF ITERATIONS, AND MAYBE
% FUNCTION TO SOLVE?

N = 200; %max number of iterations

F(1) = F_init;
k = 1;

Fflag = 0;

while Fflag == 0
    deltaF(k+1) = (M - (e*sinh(F(k)) - F(k)) )/(e*cosh(F(k)) - 1);
    F(k+1) = F(k) + deltaF(k+1);
    
    if abs(deltaF(k+1)) < epsilon || k > N
        Fflag = 1;
    else
        k = k + 1;
    end
end

if k > N
    fprintf("exceeded max number of iterations\n")
end

F_final = F(end);

end