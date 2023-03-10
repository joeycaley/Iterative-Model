function RV = RVfromOE(mu, orbit)

%this function calculates the classical two-body orbital parameters 
%using R and V vectors at one instant as input

a = orbit(1);
e = orbit(2);
i = orbit(3);
Om = orbit(4);
om = orbit(5);
phi = orbit(6);
cphi = cos(phi); sphi = sin(phi);
R313 = FRE(3, om)*FRE(1, i)*FRE(3, Om);  %this is ROI
R313T = R313';      %this is RIO

E = -mu/2/a;
p = a*(1 - e^2);
h = sqrt(mu*p);
r = p/(1 + e*cphi);
v = sqrt(2*(E + mu/r));
phid = h/r^2;
rd = e*sphi*sqrt(mu/p);


phat = R313T(:,1);
qhat = R313T(:,2);
hhat = R313T(:,3);

rbar = r*(phat*cphi + qhat*sphi);
vbar = (rd*cphi - r*phid*sphi)*phat + (rd*sphi + r*phid*cphi)*qhat;

RV = [rbar vbar];