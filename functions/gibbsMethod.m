function [r,v] = gibbsMethod(r_1,r_2,r_3,i)
% Determine the velocity of an orbiting object, assume earth is the center

mu = 3.986004*10^14;

D = cross(r_1,r_2) + cross(r_2,r_3) + cross(r_3,r_1);
N = norm(r_1)*cross(r_2,r_3) + norm(r_2)*cross(r_3,r_1) + norm(r_3)*cross(r_1,r_2);

h = sqrt(mu*norm(N)/norm(D)^3)*D;

S = (norm(r_2) - norm(r_3))*r_1 + (norm(r_3) - norm(r_1))*r_2 + (norm(r_1) - norm(r_2))*r_3;

if i == 1
    r = r_1;
    e_r = r_1/norm(r_1);
    v = mu/(norm(D)*norm(h))*(S + cross(D,e_r));
    
elseif i == 2
    r = r_2;
    e_r = r_2/norm(r_2);
    v = mu/(norm(D)*norm(h))*(S + cross(D,e_r));
    
else
    r = r_3;
    e_r = r_2/norm(r_2);
    v = mu/(norm(D)*norm(h))*(S + cross(D,e_r));
    
end

end