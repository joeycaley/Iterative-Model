% if err_flag == 0

    % plotting settings
    fig_width = 1500;
    fig_height = 800;

    fig_x = 0;
    fig_y = 100;
    delta_y = 450;

    iterMax_fig = 500;

    % Estimate eccentricity
    figure('Position',[fig_x  fig_y  fig_width  fig_height])
    subplot(2,2,1)
    plot(1:ictr-1, e_est(1:ictr-1), 'b', 'linewidth', 2);
    hold on
    plot(1:ictr-1, e_nom*ones(ictr-1,1), 'r:', 'linewidth', 2);
    grid on;
    xlabel('Iteration #');
    ylabel('Estimated e');
    legend('Estimated', 'Truth');
    set(gca, 'fontsize', 14, 'fontweight', 'bold');
    xlim([0 iterMax_fig])

    % Estimated eccentric anamoly @ t_2 from keplerian motion
%     figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
    subplot(2,2,4)
    plot(1:ictr-1, E2_his(1:ictr-1), 'b', 'linewidth', 2);
    hold on
    plot(1:ictr-1, E2_nom*ones(ictr-1,1), 'r:', 'linewidth', 2);
    grid on;
    xlabel('Iteration #');
    ylabel('Est E (rad) @ t_2 (Kepler Motion)');
    legend('Estimated', 'Truth', 'location', 'se');
    set(gca, 'fontsize', 14, 'fontweight', 'bold');
    xlim([0 iterMax_fig])
    
    % Estimated eccentric anamoly @ t_2 converted from measurement
%     figure('Position',[fig_x+fig_width  fig_y-delta_y  fig_width  fig_height])
    subplot(2,2,3)
    plot(1:ictr-1, E2m_his(1:ictr-1), 'b', 'linewidth', 2);
    hold on
    plot(1:ictr-1, E2_nom*ones(ictr-1,1), 'r:', 'linewidth', 2);
    grid on;
    xlabel('Iteration #');
    ylabel('Est E (rad) @ t_2 (Msmt)');
    legend('Estimated', 'Truth', 'location', 'se');
    set(gca, 'fontsize', 14, 'fontweight', 'bold');
    xlim([0 iterMax_fig])

    % Eccentricity error signal, which is then multiplied by gain
%     figure('Position',[fig_x+fig_width  fig_y  fig_width  fig_height])
    subplot(2,2,2)
    plot(1:ictr-1, err_his(1:ictr-1), 'b', 'linewidth', 2);
    grid on;
    xlabel('Iteration #');
    ylabel('E Error Signal Magnitude');
    set(gca, 'fontsize', 14, 'fontweight', 'bold');
    xlim([0 iterMax_fig])
% end