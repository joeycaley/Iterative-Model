function [dots] = TBP_UnknownHarmonics(~,initial_conditions,J_2)

% Grabbing the initial conditions 
r1 = initial_conditions(1);
r2 = initial_conditions(2);
r3 = initial_conditions(3);
v1 = initial_conditions(4);
v2 = initial_conditions(5);
v3 = initial_conditions(6);

r = norm([r1 r2 r3]);

% More defined parameters
mu = 3.986004*10^14; %Assume Earth centric
r_eq = 6378.137*10^3;
denominator = (r1^2 + r2^2 + r3^2)^(3/2);
J_2 = 1082.63*10^-6;

a_J2 = -3/2*J_2*(mu/r^2)*(r_eq/r)^2 * [...
    (1 - 5*(r3/r)^2) * r1/r; ...
    (1 - 5*(r3/r)^2) * r2/r; ...
    (3 - 5*(r3/r)^2) * r3/r  ...
    ];

% Calculating the derivatives
r1_dot = v1;
r2_dot = v2;
r3_dot = v3;
v1_dot = -mu / denominator * r1 + a_J2(1);
v2_dot = -mu / denominator * r2 + a_J2(2);
v3_dot = -mu / denominator * r3 + a_J2(3);

dots = [r1_dot r2_dot r3_dot v1_dot v2_dot v3_dot]';
end
