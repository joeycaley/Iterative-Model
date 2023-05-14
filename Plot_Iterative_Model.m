% plotting settings
fig_width = 1800;
fig_height = 350;

fig_x = 0;
fig_y = 525;
delta_y = 450;

iterMax_fig = 50;

if solv_type == 1 || solv_type == 2
    J2_estHistPlot = reshape(J2_estHist(:,1:end-1)', [], 1);
    err_histPlot = reshape(err_hist(:,1:end-1)',[],1);
elseif solv_type == 3 || solv_type == 4
    J2_estHistPlot = reshape(J2_estHist, [], 1);
    err_histPlot = reshape(err_hist,[],1);
end

%% Create iteration vector
if solv_type == 1 || solv_type == 2
    iter_vec = reshape(1:num_msmt*max_iter,num_msmt,[])';
elseif solv_type == 3 || solv_type == 4
    iter_vec = reshape(1:num_msmt*max_iter,max_iter,[]);
end

[markers, markerlabels] = msmt_markers();

%% Find Threshold

[end_i, J2_avgPctChngHist] = rollAvgChng(perChngCutoff, J2_estHist, solv_type);

if isempty(end_i)
    fprintf("FAILED TO CONVERGE")
else
    fprintf("FIRST BELOW CUTOFF OF %f: iteration",perChngCutoff)
    disp(end_i)
end

%% J2 Estimate SIMPLE
% setup
figure('Position',[fig_x  50  fig_width  2.8*fig_height])
subplot(2,1,1)
hold on
plot([0 max_iter], [J2_truth J2_truth], 'r', 'linewidth', 6);

% plotting data
if solv_type == 1 || solv_type == 2
    plot(num_msmt*[0:max_iter],[J2_estInit; J2_estHist(:,end)], 'b','LineWidth',6)
elseif solv_type == 3 || solv_type == 4
    plot(1:max_iter,J2_estHist(:,end), 'b','LineWidth',6)
end
plot(0,J2_estInit,"xr", 'MarkerSize',15,'LineWidth',3);

% labeling
grid on;
xlabel('Iteration #');
ylabel('Estimated J2 Parameter');
legend(["truth" "initial guess" "mean J2 estimate"]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

% xlim([0 50])

%% Error History SIMPLE
% figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
subplot(2,1,2)
hold on
plot(num_msmt*[1:max_iter],err_hist(:,end),'b','linewidth',6)
hold off

grid on;
xlabel('Iteration #');
ylabel('Msmt Estimate Error (m)');
legend(["mean error"]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

% xlim([0 50])

%% J2 Estimate ALL
figure('Position',[fig_x  50  fig_width  2.8*fig_height])
subplot(2,1,1)
hold on
plot([0 max_iter], [J2_truth J2_truth], 'r', 'linewidth', 6);
plot(0,J2_estInit,"xr",'MarkerSize',15,'LineWidth',3);
plot(num_msmt*[0:max_iter],[J2_estInit; J2_estHist(:,end)], 'b', 'linewidth', 6)
% plot(num_msmt*[0:max_iter]-num_msmt/2,[J2_estInit; J2_estHist(:,end)], 'b', 'linewidth', 6)

for i = 1:num_msmt
    plot(iter_vec(:,i), J2_estHist(:,i), markers(i),'MarkerSize',10,'LineWidth',3);
end
hold off

grid on;
xlabel('Iteration #');
ylabel('Estimated J2 Parameter');
legend(["truth" "initial guess" "mean J2 estimate" markerlabels]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

xlim([0 100])

%% Error History ALL
% figure('Position',[fig_x  fig_y-delta_y fig_width  fig_height])
subplot(2,1,2)
hold on
plot(num_msmt*[1:max_iter],err_hist(:,end),'b','linewidth', 6)
% plot(num_msmt*[1:max_iter]-num_msmt/2,err_hist(:,end),'b','linewidth', 6)

for i = 1:num_msmt
    plot(iter_vec(:,i), err_hist(:,i), markers(i), 'MarkerSize',10,'LineWidth',3);
end
hold off

grid on;
xlabel('Iteration #');
ylabel('Msmt Estimate Error (m)');
legend(["mean error" markerlabels]);
set(gca, 'fontsize', 22, 'fontweight', 'bold');

xlim([0 100])

%% Measurement Markers
function [markers, markerlabels] = msmt_markers(num_msmt)
% Creates a vector of measurement markers for the user to reference when
% plotting.

% create markers
markers = [...
    "ob", "+g", "*m", "squarek", "*c", ...
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