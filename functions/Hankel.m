function A_prime = Hankel(A, n_prime)
% Reformats a given matrix into a taller matrix for Hankel DMD. Shifts
% n_prime columns down for it.

[m,n] = size(A);

if n_prime > n
    fprintf("ERROR: WIDTH IS LARGER THAN ORIGINAL MATRIX WIDTH\n");
    A_prime = [];
    return
elseif n_prime == n
    fprintf("ERROR: you're not asking for anything to change, ya schmuck\n");
    A_prime = A;
    return
end

delta = n-n_prime;

for i = 1:delta+1
    A_prime((i-1)*m+1:i*m , :) = A(:,i:n-(delta+1)+i);
end

end