function [C, S] = stumpffFunc(z)
epsilon = 10^-10;

C = 1/factorial(2); %C 
S = 1/factorial(3); %Y

delta_C = C;
delta_S = S;

% solve for C
n = 2;
i = 1;

while abs(delta_C) > epsilon
    delta_C = (-1)^i*(z)^i/factorial(n+2*i);
    C = C + delta_C;
    i = i + 1;
end
i_C = i; % save number of terms???

% solve for S
n = 3;
i = 1;

while abs(delta_S) > epsilon
    delta_S = (-1)^i*(z)^i/factorial(n+2*i);
    S = S + delta_S;
    i = i + 1;
end
i_S = i; % save number of terms???

end