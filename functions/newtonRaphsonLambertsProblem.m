function [r,v] = newtonRaphsonLambertsProblem(r_1,r_2,t,mu,i)

epsilon = 10^-15; %stopping criteria
N = 1000; %max number of iterations

r_1_mag = norm(r_1);
r_2_mag = norm(r_2);
    
theta = acos(dot(r_1,r_2)/(r_1_mag*r_2_mag)); %ASSUME PROGRADE ORBIT, MAYBE CHANGE THIS
K_1 = mu*(1 - cos(theta));
K_2 = sqrt(mu*r_1_mag*r_2_mag/K_1)*sin(theta);
b = sqrt(mu)*t;

z(1) = 0;
k = 1;
zFlag = 0;

while zFlag == 0
    [C, S] = stumpffFunc(z(k));
    L = (1-z(k)*S)/sqrt(C);
    Y = (r_1_mag + r_2_mag) - K_2*L;
    H = (Y/C)^(3/2)*S + K_2*sqrt(Y);
    
    if abs(z(k)) > eps
        dH = (Y/C)^(3/2)*(1/(2*z(k)) * (C-3/2*S/C)  +  3/4*S^2/C) + ...
            K_2/8*(3*S/C*sqrt(Y) + K_2*sqrt(C/Y));
    else
        dH = sqrt(2)/40*Y^(3/2) + K_2/8*(sqrt(Y) + K_2*sqrt(1/(2*Y)));
    end
    
    deltaZ(k+1) = (b - H)/dH;
    z(k+1) = z(k) + deltaZ(k+1);
    
    if abs(deltaZ(k+1)) < epsilon || k > N
        zFlag = 1;
        if k > N
            fprintf("REACHED MAX ITERATIONS\n");
        end
    else
        k = k + 1;
    end
end

z_final = z(end);

[C, S] = stumpffFunc(z_final);
L = (1-z_final*S)/sqrt(C);
Y = (r_1_mag + r_2_mag) - K_2*L;
H = (Y/C)^(3/2)*S + K_2*sqrt(Y);

U_2 = Y;

a = Y/(z_final*C);
h = sqrt(K_1*r_1_mag*r_2_mag/U_2); %SOURCE OF ERROR

F = 1 - mu*r_2_mag/h^2*(1 - cos(theta));
G = r_1_mag*r_2_mag/h*sin(theta);
F_dot = mu/h * (1-cos(theta))/sin(theta) * (mu/h^2*(1 - cos(theta)) ...
    -  1/r_1_mag - 1/r_2_mag);
G_dot = 1 - mu*r_1_mag/h^2*(1 - cos(theta));

if i == 1
    r = r_1;
    v = 1/G*(r_2 - F*r_1);
else
    r = r_2;
    v = 1/G*(G_dot*r_2 - r_1);
end

end