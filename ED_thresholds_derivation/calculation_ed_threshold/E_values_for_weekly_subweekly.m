clc; clear all; close all;
cor_path='I:\data\STAND_ALONE_LAG_EVENTS\ideal_lag\ideal_lag new\';

Station_list = dir(sprintf('%s%s',fullfile(cor_path),'*.xlsx'));
StationIndex = find(~[Station_list.isdir]);
 for idx = 5:9;

Station = Station_list(StationIndex(idx)).name;
disp(Station);
STN = strsplit(Station,'_');

[PATHSTR,NAME_STN,EXT] = fileparts(Station);
% Define the matrix with 1 column (intensity) and the triggering events with a duration of 1
data = xlsread(fullfile(cor_path, [NAME_STN, '.xlsx']),'ap');
Trigging_data =xlsread(fullfile(cor_path, [NAME_STN, '.xlsx']),'trigging');
data_combined=[data ; Trigging_data];
% Eliminate the rows with zero values in both columns
data(all(data(:,1)==0, 2), :) = [];
Trigging_data(all(Trigging_data(:,1)==0, 2), :) = [];
data_combined(all(data_combined(:,1)==0, 2), :) = [];

% % Calculate the intensity
% data(:, 1) = data(:, 1) ./ data(:, 2);
% Trigging_data(:, 1) = Trigging_data(:, 1) ./ Trigging_data(:, 2);
% data_combined(:, 1) = data_combined(:, 1) ./ data_combined(:, 2);

% Plot the triggering events with a different color marker
x = data(:, 2);
y = data(:, 1);
x_ = Trigging_data(:, 2);
y_ = Trigging_data(:, 1);
x_c= data_combined(:, 2);
y_c= data_combined(:, 1);

n = 1;
tau = 0.2;
[b,h] = ncquantreg(x_c,y_c,n,tau);
    

% Add quantile regression equation to plot
a = b(1);
b_val = b(2);
eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);

% Check if the duration values 3, 7, and 10 are present in the data_combined matrix
durations = [3, 7, 10];
present_durations = intersect(data_combined(:,2), durations);

unique_durations = unique(data_combined(:,2)); % get unique durations
E_values = zeros(length(unique_durations), 1); % initialize E_values matrix
for i = 1:length(unique_durations)
    duration = unique_durations(i);
    E_values(i) = a + b_val*duration; % calculate E using the equation
end
E_values=[E_values unique_durations]
% Store E values for durations 3, 7, and 10 in a separate vector E_duration
durations = [3 7 10];
E_duration = zeros(1, length(durations));
for i = 1:length(durations)
    duration = durations(i);
    if any(unique_durations == duration)
        E_duration(i) = E_values(unique_durations == duration);
    else
        % interpolate E value for missing duration
        E_duration(i) = interp1(unique_durations, E_values(:,1), duration, 'linear', 'extrap');
    end
end
E_d(idx,:)=E_duration
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str...
        E_duration E_values unique_durations 
 end



