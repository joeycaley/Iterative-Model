function [E, Ehis, errhis] = solvekepler(Mt, e)

%global e P;
%M = 2*pi*t/P;

E0 = Mt;
err = E0 - e*sin(E0) - Mt;
thres = 1e-9;
Ecurr = E0;
iter = 1;
MAXiter = 20;
Ehis = E0;
errhis = err;
while abs(err) > thres
    correction = -(Ecurr - e*sin(Ecurr) - Mt)/(1 - e*cos(Ecurr));
    Enew = Ecurr + correction;
    err = Enew - e*sin(Enew) - Mt;
    Ecurr = Enew;
    Ehis = [Ehis; Enew];
    errhis = [errhis; err];
    iter = iter + 1;
    if iter > MAXiter
        break;
    end
end

E = Ecurr;