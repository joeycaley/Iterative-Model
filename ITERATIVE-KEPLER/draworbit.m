function draworbit(orbitin, fhi, fho, ci, co, opt)

%%%explanation of inputs: 
%fhi: figure handle (inertial orbit)
%fho: figure handle (orbit: orbital plane)
%ci: color for inertial orbit
%co: color for orbit in orbital plabe
%opt: option to opt out of drawing orbit in orbital plane. Inertial orbit
%is mandatory.

global mum;
km = 1;

a = orbitin(1);
e = orbitin(2);
Om = orbitin(3);
i = orbitin(4);
om = orbitin(5);
f0 = orbitin(6);
ROI = FRE(3, om)*FRE(1, i)*FRE(3, Om);
RIO = ROI';
p = a*(1 - e^2);
%%%angular momentum and eccentricity vectors
uh_I = ROI(3,:);
uc_I = ROI(1,:);
h = sqrt(mum*p);
c = mum*e;

%%%equation of orbit
LF = 500;
f = linspace(0, 2*pi, LF)';
dtr = pi/180;
rf = p./(1 + e*cos(f));


%%%draw the orbit in orbital frame
brO = [rf.*cos(f),  rf.*sin(f), zeros(LF, 1)];
if opt  %option to draw in plane
    figure(fho)
    plot(brO(:,1)/km, brO(:,2)/km, co, 'linewidth', 2);
end
set(gca, 'fontsize', 14);
xlabel('x (km)');
ylabel('y (km)');
title('View of the Orbit in the Orbital Plane');
grid on;
%hold on

%%%draw the orbit in inertial frame
brI = zeros(LF, 3);
for i = 1:LF
    brI(i,:) = (RIO*brO(i,:)')';
end
figure(fhi)
plot3(brI(:,1)/km, brI(:,2)/km, brI(:,3)/km, ci, 'linewidth', 2);
set(gca, 'fontsize', 14);
xlabel('x (km)');
ylabel('y (km)');
zlabel('z (km)');
title('Inertial View of the Orbit');
grid on;







