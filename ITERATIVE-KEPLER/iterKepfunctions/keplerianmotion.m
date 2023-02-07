function dots = keplerianmotion(~,x)
global mu_earth;


br = x(1:3);
bv = x(4:6);
r = norm(br);

dbr = bv;
dbv = -mu_earth*br/r^3;

dots = [dbr; dbv];


%position components
% rx = x(1);
% ry = x(2);
% rz = x(3);
% r = norm([rx, ry, rz]');

%velocity components
% vx = x(4);
% vy = x(5);
% vz = x(6);

%position derivatives
% rxdot = vx;
% rydot = vy;
% rzdot = vz;

%velocity derivatives
% vxdot = -mu_earth*rx/r^3;
% vydot = -mu_earth*ry/r^3;
% vzdot = -mu_earth*rz/r^3;
% 
% dots = [rxdot; rydot; rzdot; vxdot; vydot; vzdot];


%%% Alternatively
% br = x(1:3);
% r = norm(br);
% bv = x(4:6);
% dots = [br; -mu_earth*br/r^3];
