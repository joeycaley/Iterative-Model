function [end_i, avgPctChngHist] = rollAvgChng(cutoff, estHist, solv_type)

global num_msmt;

windowSize = 5;

if solv_type == 1 || solv_type == 2

    % differences
    percentChng = calcPercentChng(estHist(:,end));

    % use final averages
    avgPctChngHist = movmean(percentChng,[windowSize-1 0]);
    avgPctChngHist = avgPctChngHist(windowSize:end);

    % find first i < cutoff
    end_i = ((windowSize) + find(avgPctChngHist < cutoff,1))*num_msmt;
    
elseif solv_type == 3 || solv_type == 4

    % use each measurement's data

    for i = 1:num_msmt
        % differences
        percentChng = calcPercentChng(estHist(:,i));
    
        % use final averages
        avgPctChngHist(:,i) = movmean(percentChng,[windowSize-1 0]);
        avgPctChngHist = avgPctChngHist(windowSize:end);
    
        % find first i < cutoff
        find(avgPctChngHist < cutoff,1);
    end

end

end

function percentChng = calcPercentChng(data)

percentChng = abs( (data(2:end) - data(1:end-1)) ./ data(1:end-1));

end