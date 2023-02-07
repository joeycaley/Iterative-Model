function [f, E] = getfEnom(mue, orb, t)

a = orb(1); e = orb(2); fac = sqrt((1 - e)/(1 + e));
f0 = orb(6);
n = sqrt(mue/a^3);
E0 = 2*atan(fac*tan(f0/2));
M0 = E0 - e*sin(E0);
DM = n*t;
Mt = M0 + DM;
[E, ~, ~] = solvekepler(Mt, e);
f = 2*atan((tan(E/2))/fac);