clc; clear all; close all;

% Create sample data and normalize
cumulativeRain3 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\3_lag\new\'),['42299_3_crozier','.txt']));
cumulativeRain3 = (cumulativeRain3(:,4) - min(cumulativeRain3(:,4))) / (max(cumulativeRain3(:,4)) - min(cumulativeRain3(:,4)));

cumulativeRain5 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\5_day\new\'),['42299_5_crozier','.txt']));
cumulativeRain5 = (cumulativeRain5(:,4) - min(cumulativeRain5(:,4))) / (max(cumulativeRain5(:,4)) - min(cumulativeRain5(:,4)));

cumulativeRain7 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\7_day\new\'),['42299_7_crozier','.txt']));
cumulativeRain7 = (cumulativeRain7(:,4) - min(cumulativeRain7(:,4))) / (max(cumulativeRain7(:,4)) - min(cumulativeRain7(:,4)));

cumulativeRain11 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\11_day\new\'),['42299_11_crozier','.txt']));
cumulativeRain11 = (cumulativeRain11(:,4) - min(cumulativeRain11(:,4))) / (max(cumulativeRain11(:,4)) - min(cumulativeRain11(:,4)));

cumulativeRain15 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\15_day\new\'),['42299_15_crozier','.txt']));
cumulativeRain15 = (cumulativeRain15(:,4) - min(cumulativeRain15(:,4))) / (max(cumulativeRain15(:,4)) - min(cumulativeRain15(:,4)));

cumulativeRain21 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\21_day\new\'),['42299_21_crozier','.txt']));
cumulativeRain21 = (cumulativeRain21(:,4) - min(cumulativeRain21(:,4))) / (max(cumulativeRain21(:,4)) - min(cumulativeRain21(:,4)));

cumulativeRain25 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\25_day\new\'),['42299_25crozier','.txt']));
cumulativeRain25 = (cumulativeRain25(:,4) - min(cumulativeRain25(:,4))) / (max(cumulativeRain25(:,4)) - min(cumulativeRain25(:,4)));

cumulativeRain30 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\30_day\new\'),['42299_30_crozier','.txt']));
cumulativeRain30 = (cumulativeRain30(:,4) - min(cumulativeRain30(:,4))) / (max(cumulativeRain30(:,4)) - min(cumulativeRain30(:,4)));

cumulativeRain35 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\35_day\new\'),['42299_35_crozier','.txt']));
cumulativeRain35 = (cumulativeRain35(:,4) - min(cumulativeRain35(:,4))) / (max(cumulativeRain35(:,4)) - min(cumulativeRain35(:,4)));

cumulativeRain40 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\40_day\new\'),['42299_40_crozier','.txt']));
cumulativeRain40 = (cumulativeRain40(:,4) - min(cumulativeRain40(:,4))) / (max(cumulativeRain40(:,4)) - min(cumulativeRain40(:,4)));

cumulativeRain45 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\45_day\new\'),['42299_45_crozier','.txt']));
cumulativeRain45 = (cumulativeRain45(:,4) - min(cumulativeRain45(:,4))) / (max(cumulativeRain45(:,4)) - min(cumulativeRain45(:,4)));

cumulativeRain50 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\50_day\new\'),['42299_50_crozier','.txt']));
cumulativeRain50 = (cumulativeRain50(:,4) - min(cumulativeRain50(:,4))) / (max(cumulativeRain50(:,4)) - min(cumulativeRain50(:,4)));

cumulativeRain55 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\55_day\new\'),['42299_55_crozier','.txt']));
cumulativeRain55 = (cumulativeRain55(:,4) - min(cumulativeRain55(:,4))) / (max(cumulativeRain55(:,4)) - min(cumulativeRain55(:,4)));

cumulativeRain60 = load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\60_day\new\'),['42299_60_crozier','.txt']));
cumulativeRain60 = (cumulativeRain60(:,4) - min(cumulativeRain60(:,4))) / (max(cumulativeRain60(:,4)) - min(cumulativeRain60(:,4)));

dailyRain=load(sprintf('%s%s',fullfile('G:\data\STAND_ALONE_LAG_EVENTS\trigging_events\'),['42299trigging','.txt']));
dailyRain = (dailyRain(:,4) - min(dailyRain(:,4))) / (max(dailyRain(:,4)) - min(dailyRain(:,4)));

% Prepare figure
figure();
titles = {'3 days lag', '5 days lag', '7 days lag', '11 days lag', '15 days lag', ...
          '21 days lag', '25 days lag', '30 days lag', '35 days lag', '40 days lag', ...
          '45 days lag', '50 days lag', '55 days lag', '60 days lag'};
cumulativeRains = {cumulativeRain3, cumulativeRain5, cumulativeRain7, cumulativeRain11, cumulativeRain15, ...
                   cumulativeRain21, cumulativeRain25, cumulativeRain30, cumulativeRain35, cumulativeRain40, ...
                   cumulativeRain45, cumulativeRain50, cumulativeRain55, cumulativeRain60};

resultMatrix = zeros(length(titles), 5);  % Initialize result matrix

for i = 1:length(titles)
    subplot(3, 5, i);
    scatter(cumulativeRains{i}, dailyRain);
    title(titles{i});
    axis equal;
    xlim([0, 1]);
    ylim([0, 1]);
    hold on;
    plot([0, 1], [0, 1], 'k--');
    hold off;
    
    % Calculate probability of scatter points above and below 1:1 line
    aboveLineProb = sum(dailyRain > cumulativeRains{i}) / length(dailyRain);
    belowLineProb = sum(dailyRain <= cumulativeRains{i}) / length(dailyRain);
    
    % Compute the sum of values above and below the 1:1 line
    sumAbove = sum(dailyRain > cumulativeRains{i});
    sumBelow = sum(dailyRain <= cumulativeRains{i});
    
    % Compute the probabilities of values above and below the 1:1 line
    probAbove = sumAbove / length(dailyRain);
    probBelow = sumBelow / length(dailyRain);
    
    % Update result matrix
    resultMatrix(i,:) = [sumAbove, sumBelow, probAbove, probBelow, length(dailyRain)];
    
    % Display probability information on scatter plot
    text(0.05, 0.9, sprintf('Above 1:1 line: %.2f\nBelow 1:1 line: %.2f', aboveLineProb, belowLineProb));
end
% Display result matrix
disp('Result matrix:');
disp(resultMatrix);
