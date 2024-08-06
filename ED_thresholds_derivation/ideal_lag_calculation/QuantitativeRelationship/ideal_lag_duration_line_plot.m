% Clear workspace, command window and close figures
clear; clc; close all;

% Load the Excel file and get the sheet names
[~, sheetNames] = xlsfinfo('resultMatrix_new.xlsx');

% Create a cell array to store all 9 sheets
sheetArray = cell(1, 8);

% Load the 9 sheets into the array
for i = 1:8
    sheetArray{i} = xlsread('resultMatrix_new.xlsx', sheetNames{i});
end
x=sheetArray{1}
% Define the colors to use
colors = {'r', 'g', 'm', 'c', [0.5 0.5 1], 'k', [0.9 0.6 0.6], [0 0.5 0.5]};

% Create a figure and set its properties
fig = figure('Position', [100 100 800 600]);

% Plot each sheet
for i = 1:length(sheetArray)
    sheet = sheetArray{i};
    x = sheet(:, 1);
    y = sheet(:, 5) * 100;
    plot(x, y, 'Color', colors{i}, 'LineWidth', 2.5, 'DisplayName', sheetNames{i});
    hold on;
end

% Set figure properties
grid on;
xlabel('Time Lag (days)', 'FontSize', 20);
ylabel('Percentage of Landslide (%)', 'FontSize', 20);
% title('Percentage of Points Below Line 1:1', 'FontSize', 16);
xlim([2, 60]);
ylim([20, 90]);



% Add legend and set its properties
lgd = legend('show', 'Location', 'best', 'FontName', 'Arial', 'FontSize', 14, 'AutoUpdate', 'off');
lgd.Title.String = 'Stations';
lgd.Title.FontSize = 12;
lgd.Box = 'off';
lgd.ItemTokenSize = [18 18];
lgd.NumColumns = 3;
lgd.Position(1) = lgd.Position(1) + 0.05;
lgd.Position(2) = lgd.Position(2) + 0.02;

% Add vertical lines for time lags
xLines = [15, 35, 25, 11];
for i = 1:length(xLines)
    line([xLines(i) xLines(i)], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 2);
end
% Add space between axis and labels
set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 12);
yLabelPos = get(get(gca, 'YLabel'), 'Position');
yLabelPos(1) = yLabelPos(1) - 0.05;
set(get(gca, 'YLabel'), 'Position', yLabelPos);
xLabelPos = get(get(gca, 'XLabel'), 'Position');
xLabelPos(2) = xLabelPos(2) - 0.02;
set(get(gca, 'XLabel'), 'Position', xLabelPos);