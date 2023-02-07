function U = universalFunc(alpha, chi)
global epsilon
epsilon = 10^-9;

U_0 = 1; %U0
U_1 = chi; %U1

delta_U_0 = U_0;
delta_U_1 = U_1;

% solve for U_0
n = 0;
i = 1;

while abs(delta_U_0) > epsilon
    delta_U_0 = (-1)^i*(alpha*chi^2)^i/factorial(n+2*i);
    U_0 = U_0 + delta_U_0;
    i = i + 1;
end
i_0 = i; % save number of iterations

% solve for U_1
n = 1;
i = 1;

while abs(delta_U_1) > epsilon
    delta_U_1 = (-1)^i*(alpha*chi^2)^i/factorial(n+2*i);
    U_1 = U_1 + delta_U_1;
    i = i + 1;
end
i_1 = i; % save number of iterations

% solve for U_2
U_2 = (1-U_0)/alpha;

% solve for U_3
U_3 = (chi-U_1)/alpha;

U = [U_0 U_1 U_2 U_3];

end