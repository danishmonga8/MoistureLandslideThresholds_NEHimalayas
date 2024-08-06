% Script for Processing and Imputing Rainfall Data
% Developed by Dr. P. Ganguli (June 2021)

% Clear the workspace, command window, and close all figures
clc; clear all; close all;

% Add paths to necessary directories
addpath('D:\data\RegEM-master\RegEM-master\');
Grd_PrPath = 'D:\data\imd_data_gridded\gridded.xls\';
Station_Infopath = 'D:\data\bhukosh\landslides_catalog\';
Rain_Data_path = 'D:\data\raw_data_imd\raw_rain\';
OUTPATH = 'D:\data\imd_data_gridded\';

% Load station information
[Stations, station_name] = xlsread(fullfile(Station_Infopath, 'Station_location_.xlsx'));

% Loop through each station (currently only the first station is used)
for idx = 1 % Iterate over stations if needed
    Station_fullname = station_name{idx+1,1};
    disp(Station_fullname);
    WMO_ID = Stations(idx,1);
     
    % Load nearest grid data
    Near_grid = xlsread(fullfile(Station_Infopath, 'dist_from_grid.xlsx'), sprintf('%s_%d', Station_fullname, WMO_ID)); 
    DATA = load(fullfile(Rain_Data_path, sprintf('%05d.txt', WMO_ID)));
    
    % Extract rainfall data
    Prcp = DATA(:, 2:5); % Select relevant columns (year, month, day, rainfall)
    
    % Generate time series
    t1 = datetime(1980, 01, 01);
    t2 = datetime(2019, 12, 31);
    Time_dim = t1:caldays(1):t2;
    Time = Time_dim';
    dt_Prcp = table(datetime(Prcp(:, 1:3)), Prcp(:, end));    
    
    % Create full time table
    TA = table(Time, 'VariableNames', {'Time'});
    dt_Prcp.Properties.VariableNames = {'Time', 'RF'};
    TC = outerjoin(TA, dt_Prcp, 'MergeKeys', true);
    Precip_TS = [datevec(table2array(TC(:, 1))), table2array(TC(:, end))];
    Precip_TS(:, 4:6) = [];
    
    % Extract time series within the target period
    Prcp_atsite = Precip_TS(Precip_TS(:, 1) >= 1980 & Precip_TS(:, 1) <= 2019, :);
    
    % Seasonal stratification
    winter_atsite = Prcp_atsite(Prcp_atsite(:, 2) >= 1 & Prcp_atsite(:, 2) <= 3, :);
    summer_atsite = Prcp_atsite(Prcp_atsite(:, 2) >= 4 & Prcp_atsite(:, 2) <= 5, :);
    monsoon_atsite = Prcp_atsite(Prcp_atsite(:, 2) >= 6 & Prcp_atsite(:, 2) <= 9, :);
    fall_atsite = Prcp_atsite(Prcp_atsite(:, 2) >= 10 & Prcp_atsite(:, 2) <= 12, :);
    
    % Load and process gridded data for the nearest grid points
    Grd_PrAll = [];
    for jdx = 1:size(Near_grid, 1)
        Lon = Near_grid(jdx, 2);
        Lat = Near_grid(jdx, 3);
        Gridded_Precip = load(fullfile(Grd_PrPath, sprintf('dly_precip_%2.2f_&_ %2.2f.txt', Lon, Lat))); 
        Grd_Timestmp = Gridded_Precip(:, 1:3);
        Grd_PrAll(:, jdx) = Gridded_Precip(:, end);
    end
    Prcp_gridded = [Grd_Timestmp, Grd_PrAll];
    
    % Seasonal stratification for gridded data
    winter_gridded = Prcp_gridded(Prcp_gridded(:, 2) >= 1 & Prcp_gridded(:, 2) <= 3, :);
    summer_gridded = Prcp_gridded(Prcp_gridded(:, 2) >= 4 & Prcp_gridded(:, 2) <= 5, :);
    monsoon_gridded = Prcp_gridded(Prcp_gridded(:, 2) >= 6 & Prcp_gridded(:, 2) <= 9, :);
    fall_gridded = Prcp_gridded(Prcp_gridded(:, 2) >= 10 & Prcp_gridded(:, 2) <= 12, :);
    
    % Combine at-site and gridded rainfall data
    winter_MAT = [winter_atsite(:, end), winter_gridded(:, 4:end)];
    summer_MAT = [summer_atsite(:, end), summer_gridded(:, 4:end)];
    monsoon_MAT = [monsoon_atsite(:, end), monsoon_gridded(:, 4:end)];
    fall_MAT = [fall_atsite(:, end), fall_gridded(:, 4:end)];
    
    % Define options for regression method
    OPTIONS = struct('regress', 'mridge', 'maxit', 100);
    
    % Fill gaps for each season and handle flagged data
    [Winter_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(winter_MAT, OPTIONS); 
    Winter_Filled(Winter_Filled(:, 1) < 0.1) = 0; 
    [M_winter, F_winter] = mode(nonzeros(Winter_Filled(:, 1))); 
    if F_winter >= 10
        Winter_Filled(Winter_Filled(:, 1) == M_winter) = 0;
    end
    Imput_winter_prcp = [winter_atsite(:, 1:3), Winter_Filled(:, 1)];
    
    % Repeat the process for other seasons
    [Summer_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(summer_MAT, OPTIONS);
    Summer_Filled(Summer_Filled(:, 1) < 0.1) = 0;
    [M_summer, F_summer] = mode(nonzeros(Summer_Filled(:, 1)));
    if F_summer >= 10
        Summer_Filled(Summer_Filled(:, 1) == M_summer) = 0;
    end
    Imput_summer_prcp = [summer_atsite(:, 1:3), Summer_Filled(:, 1)];
    
    [Monsoon_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(monsoon_MAT, OPTIONS); 
    Monsoon_Filled(Monsoon_Filled(:, 1) < 0.1) = 0;
    [M_monsoon, F_monsoon] = mode(nonzeros(Monsoon_Filled(:, 1)));
    if F_monsoon >= 10
        Monsoon_Filled(Monsoon_Filled(:, 1) == M_monsoon) = 0;
    end
    Imput_monsoon_prcp = [monsoon_atsite(:, 1:3), Monsoon_Filled(:, 1)];
    
    [Fall_Filled, ~, ~, ~, ~, ~, ~, ~, ~] = regem(fall_MAT, OPTIONS);
    Fall_Filled(Fall_Filled(:, 1) < 0.1) = 0;
    [M_fall, F_fall] = mode(nonzeros(Fall_Filled(:, 1)));
    if F_fall >= 10
        Fall_Filled(Fall_Filled(:, 1) == M_fall) = 0;
    end
    Imput_fall_prcp = [fall_atsite(:, 1:3), Fall_Filled(:, 1)];
    
    % Replace NaN in original data with imputed dataset
    winter_atsite_filled = winter_atsite;
    summer_atsite_filled = summer_atsite;
    monsoon_atsite_filled = monsoon_atsite;
    fall_atsite_filled = fall_atsite;
    
    winter_atsite_filled(isnan(winter_atsite_filled)) = Imput_winter_prcp(isnan(winter_atsite_filled));
    summer_atsite_filled(isnan(summer_atsite_filled)) = Imput_summer_prcp(isnan(summer_atsite_filled));
    monsoon_atsite_filled(isnan(monsoon_atsite_filled)) = Imput_monsoon_prcp(isnan(monsoon_atsite_filled));
    fall_atsite_filled(isnan(fall_atsite_filled)) = Imput_fall_prcp(isnan(fall_atsite_filled));
    
    % Combine all seasons into a single table and sort
    T_winter = table(datetime(winter_atsite_filled(:, 1:3)), winter_atsite_filled(:, end));
    T_summer = table(datetime(summer_atsite_filled(:, 1:3)), summer_atsite_filled(:, end));
    T_monsoon = table(datetime(monsoon_atsite_filled(:, 1:3)), monsoon_atsite_filled(:, end));
    T_fall = table(datetime(fall_atsite_filled(:, 1:3)), fall_atsite_filled(:, end));
    T_total = [T_winter; T_summer; T_monsoon; T_fall];
    Pr_sort = sortrows(T_total, 'Var1');
    
    % Transform back to time series format
    Precip_final = [datevec(table2array(Pr_sort(:, 1))), table2array(Pr_sort(:, end))]; 
    Precip_final(:, 4:6) = [];
    
    % Export time series
    dlmwrite(fullfile(OUTPATH, 'filled_missing', sprintf('%05d_Prcp_filled.txt', WMO_ID)), Precip_final, 'delimiter', '\t');
    dlmwrite(fullfile(OUTPATH, 'Unfilled_station', sprintf('%05d_Prcp_unfilled.txt', WMO_ID)), Precip_TS, 'delimiter', '\t');     
     
    % Pause for review before clearing variables
    pause;
    
    % Clear variables for next iteration
    clear Near_grid DATA Prcp Time_dim Time dt_Prcp TA TC Precip_TS;
    clear Prcp_atsite winter_atsite summer_atsite monsoon_atsite fall_atsite;
    clear Grd_PrAll Prcp_gridded winter_gridded summer_gridded monsoon_gridded fall_gridded;
    clear winter_MAT summer_MAT monsoon_MAT fall_MAT;
    clear Winter_Filled M_winter F_winter Imput_winter_prcp;
    clear Summer_Filled M_summer F_summer Imput_summer_prcp;
    clear Monsoon_Filled M_monsoon F_monsoon Imput_monsoon_prcp;
    clear Fall_Filled M_fall F_fall Imput_fall_prcp;
    clear winter_atsite_filled summer_atsite_filled monsoon_atsite_filled fall_atsite_filled;
    clear T_winter T_summer T_monsoon T_fall T_total Pr_sort Precip_final;
end
