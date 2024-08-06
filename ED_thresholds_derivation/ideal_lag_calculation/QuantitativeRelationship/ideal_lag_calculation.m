clc; clear all; close all;

land_path = 'I:\data\STAND_ALONE_LAG_EVENTS\correlation\new\'; % Path to landslide data
Rain_STN_path = 'I:\data\raw_data_imd\dist_fromsite\rain_data_threholds_applied\new\'; % Path to rain data

Station_list = dir(sprintf('%s%s', fullfile(Rain_STN_path), '*.txt'));
StationIndex = find(~[Station_list.isdir]);
N=15
% Looping through all the stations
for idx = 2:size(StationIndex, 2)

    % Clear necessary variables
    clearvars -except land_path Rain_STN_path Station_list StationIndex idx;
    
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
    
    % Initialize matrix to collect all events for the station
    sx = [];
    
    % Calculating triggering events
    for jdx = 1:size(l_trigger, 1)
        starttime = l_trigger(jdx, 1);
        startsearch = starttime - datenum(0, 0, 1, 0, 0, 0);
        endsearch = starttime - datenum(0, 0, N, 0, 0, 0);
        tlower = datetime(startsearch);
        tupper = datetime(endsearch);

        Timestamp = table((tupper:caldays(1):tlower)');
        C = T_rain(ismember(T_rain(:, 1), Timestamp(:, 1)), :);
        Precip = [datevec(table2array(C(:, 1))) table2array(C(:, 2))]; 
        Precip(:, 4:6) = [];
        
        % Checking if there is a rain event in the 60 days before landslide
        if any(Precip(:, 4)) == 1
            Precip_series = [Precip Precip(:, 4) > 0]; % Add a column next to precipitation column with 0 for no rain & 1 for with rain
            
            % Initialize variables for event duration and total precipitation
            event_durations = [];
            event_precipitations = [];
            current_duration = 0;
            current_precipitation = 0;
            
            % Loop through the precipitation series to find continuous rain events
            for k = 1:size(Precip_series, 1)
                if Precip_series(k, 5) == 1
                    current_duration = current_duration + 1;
                    current_precipitation = current_precipitation + Precip_series(k, 4);
                else
                    if current_duration > 0
                        event_durations = [event_durations; current_duration];
                        event_precipitations = [event_precipitations; current_precipitation];
                        current_duration = 0;
                        current_precipitation = 0;
                    end
                end
            end
            
            % Handle the last event if it ends at the end of the loop
            if current_duration > 0
                event_durations = [event_durations; current_duration];
                event_precipitations = [event_precipitations; current_precipitation];
            end
            
            % Combine the event durations and precipitations into a single matrix
            new_events = [event_precipitations, event_durations];
            
            % Append to the main matrix for the station
            sx = [sx; new_events];
        end
    end
    
    % Save the matrix to a text file
    writematrix(sx, [num2str(STN{1,1}, '%5d'), 'ideal_duration_115.xlsx']);
end
