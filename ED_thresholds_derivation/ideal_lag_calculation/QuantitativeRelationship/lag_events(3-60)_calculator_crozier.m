clc; clear all; close all;

land_path = 'I:\data\STAND_ALONE_LAG_EVENTS\correlation\new\'; % Path to landslide data
Rain_STN_path = 'I:\data\raw_data_imd\dist_fromsite\rain_data_threholds_applied\new\'; % Path to rain data

Station_list = dir(sprintf('%s%s', fullfile(Rain_STN_path), '*.txt'));
StationIndex = find(~[Station_list.isdir]);

% Parameters for Crozier function
n = 61; % Number of days for lag
k = 0.9; % Decay factor

% Function definition for Crozier is read from the provided file
crozier = @crozier;

% Calculating triggering events
for idx = 1:size(StationIndex, 2)

    Station = Station_list(StationIndex(idx)).name;
    disp(Station);
    STN = strsplit(Station, '.');
    
    [PATHSTR, NAME_STN, EXT] = fileparts(sprintf(Station));   
    % Reading the slide and rain data for the particular station
    last_trigging_day = load(sprintf('%s%s', fullfile(land_path), [STN{1,1}, 'trigging_duration', '.txt']));
    Rain_STN = load(sprintf('%s%s', fullfile(Rain_STN_path), [STN{1,1}, '.txt']));
    Precip_TS = Rain_STN(:, 1:4);
    
    l_trigger = datetime(last_trigging_day(:, 1:3));
    T_rain = table(datetime(Rain_STN(:, 1:3)), Rain_STN(:, 4));
    
    % Initialize matrix to store results
    result_matrix = [];
        
    for jdx = 1:size(l_trigger, 1)
        starttime = l_trigger(jdx, 1);
        
        startsearch = starttime - datenum(0, 0, 0, 0, 0, 0);
        endsearch = starttime - datenum(0, 0, 60, 0, 0, 0);
        tlower = datetime(startsearch);
        tupper = datetime(endsearch);
        
        Timestamp = table((tupper:caldays(1):tlower)');
        C = T_rain(ismember(T_rain(:, 1), Timestamp(:, 1)), :);
        Precip = [datevec(table2array(C(:, 1))) table2array(C(:, 2))];
        Precip(:,4:6)=[];
        % Pad Precip with zeros if it doesn't have enough rows
        if size(Precip, 1) < n
            Precip = [zeros(n - size(Precip, 1), size(Precip, 2)); Precip];
        end
        
        % Applying Crozier formulation
        Precip_Crozier = crozier(Precip, n, k);
        
          
        
 
        % Append results to matrix
        result_matrix = [result_matrix; last_trigging_day(jdx, 1:3) Precip_Crozier];
    end

    % Save result matrix to file
    writematrix(result_matrix,[num2str(STN{1,1},'%5d'),'_60_crozier.txt'],'Delimiter','tab');
    
    % Clear variables for the next iteration
    clear Station STN PATHSTR NAME_STN EXT last_trigging_day Rain_STN Precip_TS l_trigger T_rain result_matrix;
end

% Clear all remaining variables
clearvars;
