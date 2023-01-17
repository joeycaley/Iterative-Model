function [a, e, omega, i, lil_omega, f_0] = rv2OE(r_I, v_I, mu)
% Given some mu (m^3/s^2), convert between initial inertial radius (m) and 
% velocity (m/s) to the orbital elements a (m), e (N/A), i (rad), omega 
% (rad), little omega (rad), and f_0 (rad)

    % find angular momentum
    h = cross(r_I, v_I);
    
    % find semi-major axis and eccentricity
    a = (2/norm(r_I) - norm(v_I)^2/mu)^-1; %m
    e = sqrt((1 - norm(h)^2/(mu*a))); %unitless
    
    % find DCM
    i_e_I = (cross(v_I,h) - mu*r_I/norm(r_I))/(mu*e);
    i_h_I = h/norm(h);
    i_y_I = cross(i_h_I,i_e_I)/norm(cross(i_h_I,i_e_I));

    R_OI = [i_e_I'; i_y_I'; i_h_I'];
    
    % determine euler angles
    i = acos(R_OI(3,3)); %inclination, degrees

    c_omega = -R_OI(3,2)/sin(i);
    s_omega = R_OI(3,1)/sin(i);
    omega = atan2(s_omega,c_omega); %longitude of ascending node, degrees

    c_lil_omega = R_OI(2,3)/sin(i);
    s_lil_omega = R_OI(1,3)/sin(i);
    lil_omega = atan2(s_lil_omega,c_lil_omega); %argument of periapsis, degrees
    
    % find true anamoly
    r_O = R_OI*r_I; %m

    c_f = r_O(1)/norm(r_O);
    s_f = r_O(2)/norm(r_O);
    f_0 = atan2(s_f,c_f); %true anamoly, degrees
end