% Authors Danish Monga (primary developer) Dr. Poulomi Ganguli, Indian Institute of Technology Kharagpur (collaborator)
clc;
clear all;
close all;

% Add paths
addpath 'I:\data\RegEM-master\RegEM-master\';
addpath 'I:\data\imd_data_gridded\';

% Define file paths
Station_Infopath = 'I:\data\bhukosh\landslides_catalog\';
Grd_PrPath = 'I:\data\imd_data_gridded\gridded.xls\';
filled_PrPath = 'I:\data\imd_data_gridded\filled_missing\';
Unfilled_PrPath = 'I:\data\imd_data_gridded\Unfilled_station\';

% Load station information
Station_list = dir(sprintf('%s%s', fullfile(filled_PrPath), '*.txt'));
StationIndex = find(~[Station_list.isdir]);
[Stations, station_name] = xlsread(sprintf('%s%s', fullfile(Station_Infopath), 'Station_location_.xlsx'));

years = 1980:2019;
num_years = length(years);
num_stations = length(StationIndex);

OS_Total = cell(num_stations, num_years + 1); % Preallocate the result matrix

for idx = 3:num_stations
    Station_fullname = station_name{idx + 1, 1}; % Get the full station name
    Station = Station_list(StationIndex(idx)).name; % Get the station file name
    
    disp(Station_fullname); % Display the station name
    WMO_ID = Stations(idx, 1); % Get the WMO ID for the station
    
    [~, NAME_STN, ~] = fileparts(Station); % Extract the base name of the station file
    NAME_STN1 = strsplit(NAME_STN, '_'); % Split the name based on underscore
    NAME_STN2 = NAME_STN1{1}; % Get the first part of the split name
    STN = str2double(NAME_STN2); % Convert to double
    disp(STN); % Display the station number
    
    Loc = find(Stations(:, 1) == STN); % Find the location index of the station
    Lat = Stations(Loc, 2); % Get the latitude
    Lon = Stations(Loc, 3); % Get the longitude
    
    % Read the near grid data
    Near_grid = xlsread(sprintf('%s%s', fullfile(Station_Infopath), 'dist_from_grid.xlsx'), sprintf('%s%s', [Station_fullname, '_', num2str(WMO_ID)])); 

    % Load the original data
    Org_DATA = load(sprintf('%s%s%s', fullfile(Unfilled_PrPath), NAME_STN2, '_Prcp_unfilled.txt')); 

    % Process the date and remove February 29th
    X = datetime(Org_DATA(:, 1:3));
    Y = table(X, Org_DATA(:, end));
    z = (Org_DATA(:, 2) == 2 & Org_DATA(:, 3) == 29);
    Org_DATA(z, :) = [];
    skip_station = false; % Initialize the flag to skip the station

    for year_idx = 1:num_years  % Loop through each year
        current_year = years(year_idx);  % Get the current year
        disp(current_year);  % Display the current year
        
        Prcp_Org = Org_DATA((Org_DATA(:, 1) == current_year), :);
        
    % Check if Prcp_Org is empty or if all precipitation data is NaN or if more than 75% of the data is missing
 
 % Check if Prcp_Org is empty or if all precipitation data is NaN or if more than 75% of the data is missing
        if isempty(Prcp_Org) || all(isnan(Prcp_Org(:, end))) || (sum(isnan(Prcp_Org(:, end))) / length(Prcp_Org(:, end)) > 0.75)
                OS_Total{idx, year_idx + 1} = 0;
        end
        
        Prcp_atsite = Prcp_Org;
        Logical_Array = isnan(Prcp_atsite);
        Target_Row = Logical_Array(:, end);
        row_id = find(Target_Row == 0);
        
        if isempty(row_id)
            OS_Total{idx, year_idx + 1} = 0;
            ;  % Skip to the next iteration
        end
        
        % Seasonal data extraction
        winter_atsite = Prcp_atsite((Prcp_atsite(:, 2) >= 1 & Prcp_atsite(:, 2) <= 3), :);
        summer_atsite = Prcp_atsite((Prcp_atsite(:, 2) >= 4 & Prcp_atsite(:, 2) <= 6), :);
        monsoon_atsite = Prcp_atsite((Prcp_atsite(:, 2) >= 7 & Prcp_atsite(:, 2) <= 9), :);
        fall_atsite = Prcp_atsite((Prcp_atsite(:, 2) >= 10 & Prcp_atsite(:, 2) <= 12), :);
       
        % Gridded precipitation data
        Grd_PrAll = [];
        for jdx = 1:size(Near_grid, 1)
            Lon = Near_grid(jdx, 2);
            Lat = Near_grid(jdx, 3);
            
            Gridded_Precip = load(sprintf('%s%s', fullfile(Grd_PrPath), ['dly_precip_', num2str(Lon, '%2.2f'), '_&_', num2str(Lat, '%2.2f'), '.txt'])); 
            Grd_Timestmp = Gridded_Precip(:, 1:3);
            Grd_PrAll(:, jdx) = Gridded_Precip(:, end);
        end
        
        Prcp_gridded = cat(2, Grd_Timestmp, Grd_PrAll);
        P = datetime(Prcp_gridded(:, 1:3));
        Q = table(P, Prcp_gridded(:, 4:end));
        R = (Prcp_gridded(:, 2) == 2 & Prcp_gridded(:, 3) == 29);
        Prcp_gridded(R, :) = [];
        
        % Seasonal gridded data extraction
        winter_gridded = Prcp_gridded((Prcp_gridded(:, 2) >= 1 & Prcp_gridded(:, 2) <= 3), :);
        summer_gridded = Prcp_gridded((Prcp_gridded(:, 2) >= 4 & Prcp_gridded(:, 2) <= 6), :);
        monsoon_gridded = Prcp_gridded((Prcp_gridded(:, 2) >= 7 & Prcp_gridded(:, 2) <= 9), :);
        fall_gridded = Prcp_gridded((Prcp_gridded(:, 2) >= 10 & Prcp_gridded(:, 2) <= 12), :);
% Define the seasons
seasons = {'winter', 'summer', 'monsoon', 'fall'};

% Calculate the number of days in each season
num_days_winter = size(winter_atsite, 1);
num_days_summer = size(summer_atsite, 1);
num_days_monsoon = size(monsoon_atsite, 1);
num_days_fall = size(fall_atsite, 1);

% Calculate 30% of the number of days in each season
min_nans_winter = ceil(0.30 * num_days_winter);
min_nans_summer = ceil(0.30 * num_days_summer);
min_nans_monsoon = ceil(0.30 * num_days_monsoon);
min_nans_fall = ceil(0.30 * num_days_fall);

% Winter
nan_count_winter = sum(isnan(winter_atsite(:, 4)));
if nan_count_winter < min_nans_winter
    additional_nans = min_nans_winter - nan_count_winter;
    indices = find(~isnan(winter_atsite(:, 4)));  % Find non-NaN indices
    if length(indices) < additional_nans
        warning('Not enough non-NaN values to introduce the required number of NaNs in winter data.');
    else
        nan_indices = randsample(indices, additional_nans);
        winter_atsite(nan_indices, 4) = NaN;
    end
end

% Summer
nan_count_summer = sum(isnan(summer_atsite(:, 4)));
if nan_count_summer < min_nans_summer
    additional_nans = min_nans_summer - nan_count_summer;
    indices = find(~isnan(summer_atsite(:, 4)));  % Find non-NaN indices
    if length(indices) < additional_nans
        warning('Not enough non-NaN values to introduce the required number of NaNs in summer data.');
    else
        nan_indices = randsample(indices, additional_nans);
        summer_atsite(nan_indices, 4) = NaN;
    end
end

% Monsoon
nan_count_monsoon = sum(isnan(monsoon_atsite(:, 4)));
if nan_count_monsoon < min_nans_monsoon
    additional_nans = min_nans_monsoon - nan_count_monsoon;
    indices = find(~isnan(monsoon_atsite(:, 4)));  % Find non-NaN indices
    if length(indices) < additional_nans
        warning('Not enough non-NaN values to introduce the required number of NaNs in monsoon data.');
    else
        nan_indices = randsample(indices, additional_nans);
        monsoon_atsite(nan_indices, 4) = NaN;
    end
end

% Fall
nan_count_fall = sum(isnan(fall_atsite(:, 4)));
if nan_count_fall < min_nans_fall
    additional_nans = min_nans_fall - nan_count_fall;
    indices = find(~isnan(fall_atsite(:, 4)));  % Find non-NaN indices
    if length(indices) < additional_nans
        warning('Not enough non-NaN values to introduce the required number of NaNs in fall data.');
    else
        nan_indices = randsample(indices, additional_nans);
        fall_atsite(nan_indices, 4) = NaN;
    end
end






        % Find common dates between at-site and gridded data for each season
        [~, idx_winter, idx_winter_gridded] = intersect(winter_atsite(:, 1:3), winter_gridded(:, 1:3), 'rows');
        winter_MAT = [winter_atsite(idx_winter, end), winter_gridded(idx_winter_gridded, 4:end)];
        
        [~, idx_summer, idx_summer_gridded] = intersect(summer_atsite(:, 1:3), summer_gridded(:, 1:3), 'rows');
        summer_MAT = [summer_atsite(idx_summer, end), summer_gridded(idx_summer_gridded, 4:end)];
        
        [~, idx_monsoon, idx_monsoon_gridded] = intersect(monsoon_atsite(:, 1:3), monsoon_gridded(:, 1:3), 'rows');
        monsoon_MAT = [monsoon_atsite(idx_monsoon, end), monsoon_gridded(idx_monsoon_gridded, 4:end)];
        
        [~, idx_fall, idx_fall_gridded] = intersect(fall_atsite(:, 1:3), fall_gridded(:, 1:3), 'rows');
        fall_MAT = [fall_atsite(idx_fall, end), fall_gridded(idx_fall_gridded, 4:end)];
        
        % Ensure data integrity before passing to regem
        if isempty(winter_MAT) || isempty(summer_MAT) || isempty(monsoon_MAT) || isempty(fall_MAT)
            OS_Total{idx, year_idx + 1} = 0;
            ;  % Skip to the next iteration
        end
    



       % Filling gaps - defining options
field1 = 'regress'; value1 = 'mridge'; field2 = 'maxit'; value2 = 100; %value1='ttls', 'mridge'
OPTIONS = struct(field1, value1, field2, value2);

% Ensure winter_MAT is correctly formatted before calling regem
if all(isnan(winter_MAT(:)))
    % Create a dummy matrix with all zeros to pass to regem
    dummy_data = [zeros(size(winter_atsite, 1), 3), zeros(size(winter_atsite, 1), size(winter_MAT, 2) - 1)];
    [Winter_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(dummy_data, OPTIONS);
    Winter_Filled(:) = NaN; % Set all imputed values to NaN
else
    try
        [Winter_Filled, Mean_winter, Cov_winter, Xerr_winter, ~, ~, ~, ~, ~] = regem(winter_MAT, OPTIONS);
    catch ME
        warning('RegEM failed: %s', ME.message);
        Winter_Filled = NaN(size(winter_atsite, 1), 1);
    end
end

% Ensure Winter_Filled is not empty and has valid imputed values
if isempty(Winter_Filled) || all(isnan(Winter_Filled(:, 1)))
    warning('Imputation failed for winter data. No valid values were imputed.');
    Winter_Filled = NaN(size(winter_atsite, 1), 1);
else
    Winter_Filled(Winter_Filled(:, 1) < 0.1) = 0; % flag
    % A mode operation is performed to check whether there is propensity
    % of same values after imputation - if such incidences are detected
    % omit those values
    [M_winter, F_winter] = mode(nonzeros(Winter_Filled(:, 1)));
    if F_winter >= 10
        Winter_Filled(Winter_Filled(:, 1) == M_winter) = 0;
    end
end

Imput_winter_prcp = [winter_atsite(:, 1:3) Winter_Filled(:, 1)];

% DebugginI: Display the results of imputation
disp('Imputed winter precipitation:');
disp(Imput_winter_prcp);

% Repeat the same for other seasons
if all(isnan(summer_MAT(:)))
    dummy_data = [zeros(size(summer_atsite, 1), 3), zeros(size(summer_atsite, 1), size(summer_MAT, 2) - 1)];
    [Summer_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(dummy_data, OPTIONS);
    Summer_Filled(:) = NaN;
else
    [Summer_Filled, Mean_summer, Cov_summer, Xerr_summer, ~, ~, ~, ~, ~] = regem(summer_MAT, OPTIONS);
end
Summer_Filled(Summer_Filled(:, 1) < 0.1) = 0;
[M_summer, F_summer] = mode(nonzeros(Summer_Filled(:, 1)));
if F_summer >= 10
    Summer_Filled(Summer_Filled(:, 1) == M_summer) = 0;
end
Imput_summer_prcp = [summer_atsite(:, 1:3) Summer_Filled(:, 1)];

if all(isnan(monsoon_MAT(:)))
    dummy_data = [zeros(size(monsoon_atsite, 1), 3), zeros(size(monsoon_atsite, 1), size(monsoon_MAT, 2) - 1)];
    [Monsoon_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(dummy_data, OPTIONS);
    Monsoon_Filled(:) = NaN;
else
    [Monsoon_Filled, Mean_monsoon, Cov_monsoon, Xerr_monsoon, ~, ~, ~, ~, ~] = regem(monsoon_MAT, OPTIONS);
end
Monsoon_Filled(Monsoon_Filled(:, 1) < 0.1) = 0;
[M_monsoon, F_monsoon] = mode(nonzeros(Monsoon_Filled(:, 1)));
if F_monsoon >= 10
    Monsoon_Filled(Monsoon_Filled(:, 1) == M_monsoon) = 0;
end
Imput_monsoon_prcp = [monsoon_atsite(:, 1:3) Monsoon_Filled(:, 1)];

if all(isnan(fall_MAT(:)))
    dummy_data = [zeros(size(fall_atsite, 1), 3), zeros(size(fall_atsite, 1), size(fall_MAT, 2) - 1)];
    [Fall_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(dummy_data, OPTIONS);
    Fall_Filled(:) = NaN;
else
    [Fall_Filled, Mean_fall, Cov_fall, Xerr_fall, ~, ~, ~, ~, ~] = regem(fall_MAT, OPTIONS);
end
Fall_Filled(Fall_Filled(:, 1) < 0.1) = 0;
[M_fall, F_fall] = mode(nonzeros(Fall_Filled(:, 1)));
if F_fall >= 10
    Fall_Filled(Fall_Filled(:, 1) == M_fall) = 0;
end
Imput_fall_prcp = [fall_atsite(:, 1:3) Fall_Filled(:, 1)];
 


        
        % Now replace NaN in original data with imputed dataset
        winter_atsite_filled = winter_atsite;
        summer_atsite_filled = summer_atsite;
        monsoon_atsite_filled = monsoon_atsite;
        fall_atsite_filled = fall_atsite;
        
        winter_atsite_filled(isnan(winter_atsite_filled)) = Imput_winter_prcp(isnan(winter_atsite_filled));
        summer_atsite_filled(isnan(summer_atsite_filled)) = Imput_summer_prcp(isnan(summer_atsite_filled));
        monsoon_atsite_filled(isnan(monsoon_atsite_filled)) = Imput_monsoon_prcp(isnan(monsoon_atsite_filled));
        fall_atsite_filled(isnan(fall_atsite_filled)) = Imput_fall_prcp(isnan(fall_atsite_filled));
        
        T_winter = table(datetime(winter_atsite_filled(:, 1:3)), winter_atsite_filled(:, end));
        T_summer = table(datetime(summer_atsite_filled(:, 1:3)), summer_atsite_filled(:, end));
        T_monsoon = table(datetime(monsoon_atsite_filled(:, 1:3)), monsoon_atsite_filled(:, end));
        T_fall = table(datetime(fall_atsite_filled(:, 1:3)), fall_atsite_filled(:, end));
        
        T_total = [T_winter; T_summer; T_monsoon; T_fall];
        Pr_sort = sortrows(T_total, 'Var1');
        
        % Transform back the time series form
        Precip_final = [datevec(table2array(Pr_sort(:, 1))), table2array(Pr_sort(:, end))]; 
        Precip_final(:, 4:6) = [];
        dt = Pr_sort(:, 1);
        Precip = Pr_sort(:, 2);
        
        dt_Org = datetime([Prcp_Org(:, 1:3), repmat([0 0 0], length(Prcp_Org), 1)]);
        % Define 'len' properly before using it
        start_yr = current_year;
        end_yr = current_year;
        len = end_yr - start_yr + 1;  % Calculate the length of the evaluation period
            % Ensure the length does not exceed the available data
        len_current_year = size(Prcp_Org, 1);
        
        % Compare Mean Annual Rainfall
        [dateAndyear, ~, index1] = unique(Prcp_Org(1:len_current_year, 1), 'rows');
        YrSum_atsite = [dateAndyear, accumarray(index1, Prcp_Org(1:len_current_year, end), [], @nansum)];  
        AAR_atsite = sqrt(nanmean(YrSum_atsite(:, 2)));
        
        [dateAndyear, ~, index2] = unique(Precip_final(1:len_current_year, 1), 'rows');
        YrSum_imput = [dateAndyear, accumarray(index2, Precip_final(1:len_current_year, end), [], @nansum)];  
        AAR_imput = sqrt(mean(YrSum_imput(:, 2)));
        % Remove NaN values before calculating standard deviation
        valid_values = Prcp_Org(:, 4);
        valid_values = valid_values(~isnan(valid_values) & valid_values ~= 0);
        
        % Calculate the standard deviation and handle NaN or zero case
        std_atsite = std(valid_values);
        
        % Check if std_atsite is valid for division
        if isempty(valid_values)
            disp('No valid data points available for standard deviation calculation.');
            Del_AAR = NaN; % Handle as per your requirements
        elseif std_atsite == 0
            disp('Standard deviation of valid data points is zero.');
            % Handle zero standard deviation case, set Del_AAR to NaN or another value
            Del_AAR = NaN; % or set to a predefined value, e.g., 0 or another indicator
        else
            Del_AAR = (AAR_atsite - AAR_imput) / std_atsite;
        end
  
               
L = (end_yr - start_yr) + 1;
Available_yrs = start_yr:1:end_yr;

Quantile_10yr_Atsite = zeros(L, 1); % Preallocate with zeros
Quantile_10yr_Imput = zeros(L, 1); % Preallocate with zeros

for ldx = 1:L
    yr = Available_yrs(ldx);
    disp(yr);
    
    % Process observed data
    PrcpAtsite = Prcp_Org((Prcp_Org(:, 1) == yr), :); 
    Prcp_Org2 = PrcpAtsite(~isnan(PrcpAtsite(:, end)), :);
    
    if isempty(Prcp_Org2)
        Quantile_10yr_Atsite(ldx, :) = 0;
    else
        le = size(Prcp_Org2(:, end), 1);
        P = 0.90;
        R1 = fix(P * (le + 1));
        Rs_Atsite1 = sortrows(Prcp_Org2, 4);
        Rs_peakRain_Atsite = Rs_Atsite1(:, end);
        Quantile_10yr_Atsite(ldx, :) = nanmean(Rs_peakRain_Atsite(R1:min(R1 + 1, le), :));
    end
    
    % Process imputed data
    PrcpImput = Precip_final((Precip_final(:, 1) == yr), :);
    [~, IA, IB] = intersect(Prcp_Org2(:, 1:3), PrcpImput(:, 1:3), 'rows');
    PrcpImput_common = PrcpImput(IB, :);
    
    if isempty(PrcpImput_common)
        Quantile_10yr_Imput(ldx, :) = 0;
    else
        Rs_Imput = sortrows(PrcpImput_common, 4);
        Rs_peakRain_Imput = Rs_Imput(:, end);
        Quantile_10yr_Imput(ldx, :) = nanmean(Rs_peakRain_Imput(R1:min(R1 + 1, size(Rs_peakRain_Imput, 1)), :));
    end
end

% Calculate Del_Quantile_10yr without normalizing by std(Quantile_10yr_Atsite)
if isempty(Quantile_10yr_Atsite) || isempty(Quantile_10yr_Imput)
    Del_Quantile_10yr = NaN;
else
    Del_Quantile_10yr = median((sqrt(Quantile_10yr_Atsite) - sqrt(Quantile_10yr_Imput)));
end

% Display the results for debugging purposes
disp(['Quantile_10yr_Atsite = ', num2str(Quantile_10yr_Atsite)]);
disp(['Quantile_10yr_Imput = ', num2str(Quantile_10yr_Imput)]);
disp(['Del_Quantile_10yr = ', num2str(Del_Quantile_10yr)]);

                


% Initialize variables to store the results
Mean_onset_org_all = [];
Mean_onset_imput_all = [];

for year = start_yr:end_yr 
    disp(['Processing year: ', num2str(year)]);
    
    % Apply filter criteria for the water year in Prcp_Org
    iswint = isbetween(datetime(Prcp_Org(:, 1:3)), datetime(year, 06, 01), datetime(year + 1, 05, 31));
    Rain_Wateryr_Org = Prcp_Org(iswint, :);
    Rain_Events_Org = Rain_Wateryr_Org(Rain_Wateryr_Org(:, end) ~= 0, :); % Exclude zeros
    Wateryr_Org = Rain_Events_Org(~isnan(Rain_Events_Org(:, end)), :); % Exclude NaNs
    
    % DebugginI: Display the contents of Wateryr_Org
    disp('Wateryr_OrI:');
    disp(Wateryr_Org);

    if isempty(Wateryr_Org)
        warning(['No valid data for the water year ', num2str(year), '.']);
    else
        % Apply filter criteria for the water year in Precip_final
        iswint_imput = isbetween(datetime(Precip_final(:, 1:3)), datetime(year, 06, 01), datetime(year + 1, 05, 31));
        Rain_Wateryr_Imput = Precip_final(iswint_imput, :);
        
        % DebugginI: Display the filtered data for the imputed year
        disp('Filtered Rain_Wateryr_Imput:');
        disp(Rain_Wateryr_Imput);

        % Further filter for non-zero and non-NaN values
        Wateryr_Imput = Rain_Wateryr_Imput((Rain_Wateryr_Imput(:, end) ~= 0) & ~isnan(Rain_Wateryr_Imput(:, end)), :);
        disp('Final Wateryr_Imput:');
        disp(Wateryr_Imput);

        if isempty(Wateryr_Imput)
            warning(['No valid imputed data for the water year ', num2str(year), '.']);
        else
            % Calculate mean onset
            Mean_onset_org = Onset(Wateryr_Org(:, 1:3), Wateryr_Org(:, end));
            Mean_onset_imput = Onset(Wateryr_Imput(:, 1:3), Wateryr_Imput(:, end));

            % Store results
            Mean_onset_org_all = [Mean_onset_org_all; Mean_onset_org];
            Mean_onset_imput_all = [Mean_onset_imput_all; Mean_onset_imput];
        end
    end
end

% Check if there are valid results
if ~isempty(Mean_onset_org_all) && ~isempty(Mean_onset_imput_all)
    Diff_CT = Mean_onset_org_all - Mean_onset_imput_all;
    
    % Handle the case where we have data for only one year
    if size(Mean_onset_org_all, 1) == 1
        Del_CT = Diff_CT; % Direct difference if only one year of data
    else
        std_onset_org = std(Mean_onset_org_all);
        
        % Check if std_onset_org is valid for division
        if std_onset_org == 0 || isnan(std_onset_org)
            Del_CT = NaN; % or handle as required
        else
            Del_CT = median(Diff_CT ./ std_onset_org);
        end
    end
    
    % Display the results for debugging purposes
    disp(['Mean_onset_org_all = ', num2str(Mean_onset_org_all)]);
    disp(['Mean_onset_imput_all = ', num2str(Mean_onset_imput_all)]);
    disp(['Diff_CT = ', num2str(Diff_CT)]);
    disp(['Del_CT = ', num2str(Del_CT)]);
else
    warning('No valid onset data found for any of the years.');
    Del_CT = NaN;
end











      
% Ensure the length does not exceed the available data
len_current_year_org = size(Prcp_Org, 1);
len_current_year_imput = size(Precip_final, 1);

% Determine the minimum length available in both datasets
max_length = min([365 * len, len_current_year_org, len_current_year_imput]);

% Ensure the row_id(1) does not exceed the available data
% Ensure the row_id(1) does not exceed the available data
if isempty(row_id)
    rdly = 0;
    rdly_5d = 0;
else
    % Calculate the actual available length starting from row_id(1)
    available_length_org = len_current_year_org - row_id(1) + 1;
    available_length_imput = len_current_year_imput - row_id(1) + 1;
    actual_length = min([max_length, available_length_org, available_length_imput]);

    % Ensure the actual length is sufficient for the calculations
    if actual_length <= 0
        error('Insufficient data available for the specified period.');
    end

    % DebugginI: Display lengths and indices
    disp(['Max length: ', num2str(max_length)]);
    disp(['Actual length: ', num2str(actual_length)]);
    disp(['Row ID: ', num2str(row_id(1))]);

    % Extract data for the valid period
    Prcp_Org_valid = Prcp_Org(row_id(1):row_id(1) + actual_length - 1, 4);
    Precip_final_valid = Precip_final(row_id(1):row_id(1) + actual_length - 1, 4);

    % DebugginI: Display data subsets
    disp('Prcp_Org_valid:');
    disp(Prcp_Org_valid);
    disp('Precip_final_valid:');
    disp(Precip_final_valid);

    % Correlation calculation for daily data
    rdly = corr(Prcp_Org_valid, Precip_final_valid, 'type', 'Spearman', 'rows', 'complete');

    % Moving sum calculation for 5-day periods
    scale = days(5);
    ndly_obs = movsum(Prcp_Org_valid, scale, 'samplePoints', datetime(Prcp_Org(row_id(1):row_id(1) + actual_length - 1, 1:3)), 'Endpoints', 'shrink');
    ndly_imput = movsum(Precip_final_valid, scale, 'samplePoints', datetime(Precip_final(row_id(1):row_id(1) + actual_length - 1, 1:3)), 'Endpoints', 'shrink');

    % Correlation calculation for 5-day sums
    rdly_5d = corr(ndly_obs, ndly_imput, 'type', 'Spearman', 'rows', 'complete');

    % Display the results for debugging purposes
    disp(['rdly = ', num2str(rdly)]);
    disp(['rdly_5d = ', num2str(rdly_5d)]);
end


        OS_sig = 1 - median([abs(Del_AAR), abs(Del_Quantile_10yr), abs(Del_CT)]);
        OS_var = median([rdly, rdly_5d]);
        
        OS_overall = median([OS_sig, OS_var]);
        
        OS_Total{idx, year_idx + 1} = OS_overall; % Store overall score
    end
    OS_Total{idx, 1} = Station_fullname; % Store station name
end
% Convert the cell array to a table and write to an Excel file
OS_Table = cell2table(OS_Total, 'VariableNames', ['Station_Name', arrayfun(@num2str, years, 'UniformOutput', false)]);
filename = 'Overall_Scores.xlsx';
writetable(OS_Table, filename);
