% plotting settings
fig_width = 1800;
fig_height = 350;

fig_x = 0;
fig_y = 525;
delta_y = 450;

J2_estHistPlot = reshape(J2_estHist, [], 1);
err_histPlot = reshape(err_hist,[],1);

%% J2 Estimate
figure('Position',[fig_x  50  fig_width  2.8*fig_height])
subplot(2,1,1)
hold on
plot([0 num_msmt*max_iter], [J2_truth J2_truth], 'r', 'linewidth', 6);
plot(0,J2_estInit,"xr", 'MarkerSize',15,'LineWidth',3);
plot(1:num_msmt*max_iter, J2_estHistPlot,'b','LineWidth',6);

xticks(0:max_iter:num_msmt*max_iter)
% ylim([0 1.2e-3])

grid on;
xlabel('Iteration #');
ylabel('Estimated J2 Parameter');
legend(["truth" "initial guess" "J2 estimate"]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

ylim([1000e-6 1100e-6])
xlim([300 num_msmt*max_iter])

%% Error
% figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
subplot(2,1,2)

hold on
plot(1:num_msmt*max_iter,err_histPlot,'b','linewidth',6)
hold off

xticks(0:max_iter:num_msmt*max_iter)

grid on;
xlabel('Iteration #');
ylabel('Estimate Error (m)');
legend(["error"]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

ylim([-400 400])
xlim([300 num_msmt*max_iter])

if msmt_type == 3
    %% J2 Estimate TIGHT RANGE
    figure('Position',[fig_x  50  fig_width  2.8*fig_height])
    subplot(2,1,1)
    hold on
    plot([0 num_msmt*max_iter], [J2_truth J2_truth], 'r', 'linewidth', 6);
    plot(0,J2_estInit,"xr");
    plot(1:num_msmt*max_iter, J2_estHistPlot,'b');
    
    xticks(0:max_iter:num_msmt*max_iter)
    ylim([1e-3 1.2e-3])
    xlim([300 600])
    
    grid on;
    xlabel('Iteration #');
    ylabel('Estimated J2 Parameter');
%     title("Tight Range Estimate")
    legend(["truth" "initial guess" "J2 estimate"]);
    set(gca, 'fontsize', 22, 'fontweight', 'bold');
    
    
    %% Error
%     figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
    subplot(2,1,2)
    
    hold on
    plot(1:num_msmt*max_iter,err_histPlot,'b')
    hold off
    
    xticks(0:max_iter:num_msmt*max_iter)
    ylim([-400 400])
    xlim([300 600])
    
    grid on;
    xlabel('Iteration #');
    ylabel('Estimate Error (m)');
%     title("Tight Range Error")
    legend(["error"]);
    set(gca, 'fontsize', 14, 'fontweight', 'bold');
end
