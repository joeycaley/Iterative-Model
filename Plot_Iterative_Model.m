% plotting settings
fig_width = 600;
fig_height = 350;

fig_x = 0;
fig_y = 525;
delta_y = 450;

iterMax_fig = 50;

%% Resize data
iter_vec = [0; [1: 1/num_msmt : max_iter + (1 - 1/num_msmt)]'];
J2_estHistPlot = [J2_estInit; reshape(J2_estHist',[],1)];
err_histPlot = [J2_estInit - J2; reshape(err_hist',[],1)];

%% J2 Estimate
figure('Position',[fig_x  fig_y  fig_width  fig_height])
plot(iter_vec, J2_estHistPlot, 'b', 'linewidth', 2);
hold on
plot([0 max_iter], [J2 J2], 'r', 'linewidth', 2);
grid on;
xlabel('Iteration #');
ylabel('Estimated J2 Parameter');
legend('Estimated', 'Truth');
set(gca, 'fontsize', 14, 'fontweight', 'bold');
% xlim([0 iterMax_fig])

%% Error History
figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
plot(iter_vec, err_histPlot,'b', 'linewidth', 2);
grid on;
xlabel('Iteration #');
ylabel('Msmt Estimate Error (m)');
% legend('Estimated', 'Truth', 'location', 'se');
% set(gca, 'fontsize', 14, 'fontweight', 'bold');
% xlim([0 iterMax_fig])