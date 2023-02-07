function TBorbit = OEfromRV(mue, br, bv)

%this function calculates the classical two-body orbital parameters 
%using R and V vectors at one time instant as input

%%%vector norms
r = norm(br);
v = norm(bv);

%%%VIS-VIVA: semi-major axis
E = v^2/2 - mue/r;    %energy
a = -mue/2/E;  %SEMI-MAJOR AXIS

%%%ANGULAR MOMENTUM:
bh = cross(br, bv);   %ANGULAR MOMENTTUM VECTOR
h = norm(bh);
p = h^2/mue; %PARAMETER

%%%ECCENTRICITY VECTOR
bc = cross(bv, bh) - mue*br/r;
c = norm(bc);
e = c/mue;  %ECCENTRICITY

%%%unit vectors
ubc = bc/c;
ubh = bh/h;
uby = cross(ubh, ubc);
uby = uby/norm(uby);    %normalize to be sure
ROI = [ubc'; uby'; ubh'];

%%%Start with inclination
i = acos(ubh(3)); %INCLINATION
si = sin(i);

%%%NEXT: Longitude of Ascending node
OMEGA = atan2(ubh(1)/si, -ubh(2)/si);
%%%don't accept a negative answer
if isnan(OMEGA)
    OMEGA = pi/2;
elseif OMEGA < 0
    OMEGA = OMEGA + 2*pi;    
end

%%%ARGUMENT OF PERIAPSIS
omega = atan2(ubc(3)/si, uby(3)/si);   %ARGUMENT OF PERIAPSIS
%%%don't accept a negative answer
if isnan(omega)
    omega = pi/2;
elseif omega < 0
    omega = omega + 2*pi;
end

%%%Flight path angle: use the relationships that
%sin f = p rdot/he, where, rdot = br-dot-bv;
%cos f comes from the equation of orbit
rdot = dot(br, bv)/r;
sfpa = p*rdot/h/e;
cfpa = (p/r - 1)/e;
f = atan2(sfpa, cfpa);

%%%don't acceept a negative answer
if f < 0
    f = f + 2*pi;
end

%%%return the orbitala parameters
TBorbit = [a; e; OMEGA; i; omega; f; reshape(ROI, 9, 1)];