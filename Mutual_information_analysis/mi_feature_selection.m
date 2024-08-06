% Danish Monga (primary developer) Dr. Poulomi Ganguli, Indian Institute of Technology Kharagpur (collaborator)

clc; clear all; close all;

% Add the path to the mutual information function
addpath('I:\data\geodetector\mi');

% Read the Excel file
file_path = 'I:/data/geodetector/geodetector.xlsx';
data = readtable(file_path);

% Assume the second column is the response variable and the rest (excluding the first and twelfth) are predictors
response_variable = data{:, 2}; % Extract the response variable
predictors = data(:, [4:10 12:end]); % Exclude the twelfth column
predictor_names = predictors.Properties.VariableNames;

% Convert the predictor table to an array
predictors_array = table2array(predictors);

% Calculate mutual information for each predictor
mi_values = zeros(1, width(predictors));
for i = 1:width(predictors)
    mi_values(i) = MutualInfo_danish(response_variable, predictors_array(:, i));
end

% Creating a professional-looking bar plot
figure;
bar_handle = bar(mi_values, 'FaceColor', [0 0.4470 0.7410]);  % Custom color
set(gca, 'XTick', 1:length(predictor_names), 'XTickLabel', predictor_names, 'XTickLabelRotation', 45, 'FontSize', 12);
ylabel('Mutual Information', 'FontSize', 12);
xlabel('Predictors', 'FontSize', 12);
title('Mutual Information of Predictors with Response Variable', 'FontSize', 14, 'FontWeight', 'bold');
grid on;  % Add a grid for easier reading
box on;  % Enclose the plot in a box
set(gcf, 'Color', 'w');  % Set background color to white
ylim([0,0.9])
% Add MI values on top of the bars
xtips1 = bar_handle.XEndPoints;
ytips1 = bar_handle.YEndPoints;
labels1 = string(round(mi_values, 2));
text(xtips1, ytips1, labels1, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
