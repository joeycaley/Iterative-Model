%% create history of parameters
e_est = zeros(iternum, 1);
err_his = zeros(iternum, 1);
E2_his = zeros(iternum, 1);
E2m_his = zeros(iternum, 1);

%% iteration parameters
thres = 1e-3;
err_flag = 0;
ictr = 1;