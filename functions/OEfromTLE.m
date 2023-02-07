function OE = OEfromTLE(fname)
mu = 3.986004e14; %  Standard gravitational parameter for the earth
d2r = pi/180;


% Open the TLE file and read TLE elements
fid = fopen(fname);

% read first line
tline = fgetl(fid);
epochY = str2double(tline(19:20));                          % Epoch year
epochD = str2double(tline(21:32));                            % Epoch day
epochH = str2double(tline(24:32));                      % Epoch hour

% Close the TLE file
fclose(fname)

% read second line
tline = fgetl(fid);
inc = str2double(tline(9:16))*d2r;                           % Orbit Inclination (rad)
RAAN = str2double(tline(18:25))*d2r;                         % Right Ascension of Ascending Node (rad)
e = str2double(strcat('0.',tline(27:33)));                   % Eccentricity
argP = str2double(tline(35:42))*d2r;                         % Argument of Perigee (rad)
M = str2double(tline(44:51))*d2r;                            % Mean Anomaly (rad)
a = ( mu / (str2double(tline(53:63))*2*pi/86400)^2 )^(1/3);    % semi major axis
n = str2double(tline(64:68));                                % Revolution Number at Epoch

err = 1e-10;            %Calculation Error
E0 = M; t = 1;
itt = 0;
while(t)
    E =  M + e*sin(E0);
    if ( abs(E - E0) < err)
        t = 0;
    end
    E0 = E;
    itt = itt+1;
end

E2f_coeff = sqrt((1+e)/(1-e));

f = 2*atan(E2f_coeff*tan(E/2));

% Six orbital elements
OE = [a e inc argP RAAN f];
fprintf('\n a [km] \t\t e \t\t\t\t inc[rad] \t\t w[rad] \t\t RAAN[rad] \t\t f[rad] \n ')
fprintf('%4.2f \t\t %4.4f \t\t %4.4f \t\t %4.4f \t\t  %4.4f \t\t %4.4f\n', [OE(1)/1000 OE(2:end)]);
end