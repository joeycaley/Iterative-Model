% plotting settings
fig_width = 1800;
fig_height = 350;

fig_x = 0;
fig_y = 525;
delta_y = 450;

iterMax_fig = 50;



%% Create iteration vector
for i = 1:num_msmt
    iter_vec(:,i) = [1 + (i-1)/num_msmt: 1 : max_iter + (i-1)/num_msmt]';
end

[markers, markerlabels] = msmt_markers();

%% J2 Estimate SIMPLE
figure('Position',[fig_x  50  fig_width  2.8*fig_height])
subplot(2,1,1)
hold on
plot([0 max_iter], [J2_truth J2_truth], 'r', 'linewidth', 6);
plot(0,J2_estInit,"xr", 'MarkerSize',15,'LineWidth',3);
plot(1:max_iter,J2_estHist(:,end), 'b','LineWidth',6)

grid on;
xlabel('Iteration #');
ylabel('Estimated J2 Parameter');
legend(["truth" "initial guess" "mean J2 estimate"]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

xlim([0 50])

%% Error History SIMPLE
% figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
subplot(2,1,2)
hold on
plot(1:max_iter,err_hist(:,end),'linewidth',6)
hold off

grid on;
xlabel('Iteration #');
ylabel('Msmt Estimate Error (m)');
legend(["mean error"]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

xlim([0 50])

%% J2 Estimate ALL
figure('Position',[fig_x  50  fig_width  2.8*fig_height])
subplot(2,1,1)
hold on
plot([0 max_iter], [J2_truth J2_truth], 'r', 'linewidth', 6);
plot(0,J2_estInit,"xr",'MarkerSize',15,'LineWidth',3);
plot(1:max_iter,J2_estHist(:,end), 'b', 'linewidth', 6)

for i = 1:num_msmt
    plot(iter_vec(:,i), J2_estHist(:,i), markers(i),'MarkerSize',10,'LineWidth',3);
end
hold off

grid on;
xlabel('Iteration #');
ylabel('Estimated J2 Parameter');
legend(["truth" "initial guess" "mean J2 estimate" markerlabels]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

xlim([0 50])

%% Error History ALL
% figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
subplot(2,1,2)
hold on
plot(1:max_iter,err_hist(:,end),'linewidth', 6)
for i = 1:num_msmt
    plot(iter_vec(:,i), err_hist(:,i), markers(i), 'MarkerSize',10,'LineWidth',3);
end
hold off

grid on;
xlabel('Iteration #');
ylabel('Msmt Estimate Error (m)');
legend(["mean error" markerlabels]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

xlim([0 50])

%% Measurement Markers
function [markers, markerlabels] = msmt_markers(num_msmt)
% Creates a vector of measurement markers for the user to reference when
% plotting.

% create markers
markers = [...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec", ...
    "ob", "+g", "*m", ".k", "squarec"];

% create labels
for i = 1:7
    markerlabels(i) = "Msmt " + i;
end
markerlabels(8) = "And so on and so forth";

end