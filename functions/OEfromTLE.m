function orbit = OEfromTLE(fname)
mu = 398600; %  Standard gravitational parameter for the earth

% Open the TLE file and read TLE elements
fid = fopen(fname);

% read first line
tline = fgetl(fid);
epochY = str2double(tline(19:20));                          % Epoch year
epochD = str2double(tline(21:32));                            % Epoch day
epochH = str2double(tline(24:32));                      % Epoch hour

% read second line
tline = fgetl(fid);
inc = str2double(tline(9:16));                                 % Orbit Inclination (degrees)
RAAN = str2double(tline(18:25));                               % Right Ascension of Ascending Node (degrees)
e = str2double(strcat('0.',tline(27:33)));                   % Eccentricity
w = str2double(tline(35:42));                                  % Argument of Perigee (degrees)
M = str2double(tline(44:51));                                  % Mean Anomaly (degrees)
a = ( mu/(str2double(tline(53:63))*2*pi/86400)^2 )^(1/3);    % semi major axis
n = str2double(tline(64:68));                                % Revolution Number at Epoch

err = 1e-10;            %Calculation Error
E0 = M; t =1;
itt = 0;
while(t)
    E =  M + e*sin(E0);
    if ( abs(E - E0) < err)
        t = 0;
    end
    E0 = E;
    itt = itt+1;
end
% Six orbital elements
orbit = [a e inc RAAN w E];
fprintf('\n a [km] \t\t e \t\t\t\t inc[deg] \t\t RAAN[deg] \t\t  w[deg] \t\t E[deg] \n ')
fprintf('%4.2f \t\t %4.4f \t\t %4.4f \t\t %4.4f \t\t  %4.4f \t\t %4.4f', orbit);
end