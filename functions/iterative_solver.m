function [J2_estHist, r_estHist, err_hist] = iterative_solver(solv_type, ...
    r_msmt, dr_msmt, t_msmt, J2_estInit, Kp, max_iter, initCond)
%% Setup

% viable solver types
viable_solv = [1 2 3 4];

% initialize J2_est
J2_est = J2_estInit;

% constants and options for ode45
global AbsTol RelTol num_msmt

options = odeset('AbsTol',AbsTol,'RelTol',RelTol);

%% Solvers
if solv_type == 1 || solv_type == 2

    % create histories
    r_estHist = zeros(max_iter, length(r_msmt));
    err_hist = zeros(max_iter, length(r_msmt) + 1);
    J2_estHist = zeros(max_iter, length(r_msmt) + 1);

    for i = 1:max_iter
        for j = 1:num_msmt
        
            % Set initial condition depending on solver & msmt #
            if solv_type == 2 && j ~= 1
                initCondLoop = x_loop(end,:)';

                t_f = t_msmt(j) - t_msmt(j-1);

            else % 1st measurment and/or solver type 1
                initCondLoop = initCond;
                t_f = t_msmt(j);
            end
    
            [t_loop,x_loop] = ode45(@(t_loop,x_loop) TBP_UnknownHarmonics(...
                t_loop,x_loop,J2_est), [0 t_f], initCondLoop, options);
    
            % create final range
            r_est = norm(x_loop(end,1:3));
    
            % Error and correction
            err = r_est - r_msmt(j);
            J2_est = J2_est - Kp*err;
    
            % input histories
            err_hist(i,j) = err;
            r_estHist(i,j) = r_est;
            J2_estHist(i,j) = J2_est;

            % calculate mean error and J2 estimate after last measurement run
            if j == num_msmt
                err_hist(i,j+1) = mean(err_hist(i,1:j));
                J2_estHist(i,j+1) = mean(J2_estHist(i,1:j));
            end
        end
    end
    
elseif solv_type == 3

    % create histories
    r_estHist = zeros(max_iter, length(r_msmt));
    err_hist = zeros(max_iter, length(r_msmt));
    J2_estHist = zeros(max_iter, length(r_msmt));

    initCondLoop = initCond;

    for j = 1:num_msmt

        t_f = t_msmt(j);

        for i = 1:max_iter
    
            [t_loop,x_loop] = ode45(@(t_loop,x_loop) TBP_UnknownHarmonics(...
                t_loop,x_loop,J2_est), [0 t_f], initCond, options);

            % create final range
            r_est = norm(x_loop(end,1:3));
    
            % Error and correction
            err = r_est - r_msmt(j);
            J2_est = J2_est - Kp*err;
    
            % input histories
            err_hist(i,j) = err;
            r_estHist(i,j) = r_est;
            J2_estHist(i,j) = J2_est;
        end
    end

elseif solv_type == 4

    % create histories
    r_estHist = zeros(max_iter, length(r_msmt));
    err_hist = zeros(max_iter, length(r_msmt));
    J2_estHist = zeros(max_iter, length(r_msmt));

    for j = 1:num_msmt

        % set initial conditions based on msmt #
        if j ~= 1
            initCondLoop = x_loop(end,:)';
%             t_i = 0;
            t_f = t_msmt(j) - t_msmt(j-1);
        else
            initCondLoop = initCond;
            t_f = t_msmt(j);
        end

        for i = 1:max_iter
    
            [t_loop,x_loop] = ode45(@(t_loop,x_loop) TBP_UnknownHarmonics(...
                t_loop,x_loop,J2_est), [0 t_f], initCondLoop, options);

            % create final range
            r_est = norm(x_loop(end,1:3));
    
            % Error and correction
            err = r_est - r_msmt(j);
            J2_est = J2_est - Kp*err;
    
            % input histories
            err_hist(i,j) = err;
            r_estHist(i,j) = r_est;
            J2_estHist(i,j) = J2_est;
        end
    end

else
    error("ERROR SOLVER TYPE UNDEFINED")
end

end

