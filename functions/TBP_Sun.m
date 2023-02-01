function [dots] = TBP_Sun(~,initial_conditions)

% Grabbing the initial conditions 
r1 = initial_conditions(1);
r2 = initial_conditions(2);
r3 = initial_conditions(3);
v1 = initial_conditions(4);
v2 = initial_conditions(5);
v3 = initial_conditions(6);

% More defined parameters
mu = 1.32712440042*10^20;
denominator = (r1^2 + r2^2 + r3^2)^(3/2);

% Calculating the derivatives
r1_dot = v1;
r2_dot = v2;
r3_dot = v3;
v1_dot = -mu / denominator * r1;
v2_dot = -mu / denominator * r2;
v3_dot = -mu / denominator * r3;

dots = [r1_dot r2_dot r3_dot v1_dot v2_dot v3_dot]';
end
