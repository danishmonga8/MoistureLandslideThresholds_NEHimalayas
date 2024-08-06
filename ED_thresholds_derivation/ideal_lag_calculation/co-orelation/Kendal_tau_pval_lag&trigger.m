clc; clear all; close all;
addpath 'G:\data\STAND_ALONE_LAG_EVENTS'
l_trigger_path ='G:\data\STAND_ALONE_LAG_EVENTS\correlation\new\' % Path to landslide data
Rain_STN_path='G:\data\raw_data_imd\dist_fromsite\rain_data_threholds_applied\new\' % Path to rain data
trigging_event_path='G:\data\STAND_ALONE_LAG_EVENTS\trigging_events\'
Station_list = dir(sprintf('%s%s',fullfile(Rain_STN_path),'*.txt'));
StationIndex = find(~[Station_list.isdir]);
N=60
for    idx =1:size(StationIndex,2) 

    Station = Station_list(StationIndex(idx)).name; 
    disp(Station);
    STN = strsplit(Station,'.');
    
    [PATHSTR,NAME_STN,EXT] = fileparts(sprintf(Station));
   
    l_trigger =load(sprintf('%s%s',fullfile(l_trigger_path),[STN{1,1},'trigging_duration.txt']));
    Rain_STN =load(sprintf('%s%s',fullfile(Rain_STN_path),[STN{1,1},'.txt']));
    t_trigging=load(sprintf('%s%s',fullfile(trigging_event_path),[STN{1,1},'trigging.txt']));

    Precip_TS=Rain_STN(:,1:4);
       
    T_slides = datetime(l_trigger(:,1:3));
    
    T_rain = table(datetime(Rain_STN(:,1:3)),Rain_STN(:,4));
 %        T_slides=T_slides(1:26,:) lagging ny desired number of days
            for jdx = 1:size(T_slides)
                starttime = T_slides(jdx,1);
            
                startsearch=starttime+datenum(0,0,0,0,0,0);
                endsearch=starttime - datenum(0,0,N,0,0,0);
                startsearch_vec = datevec(startsearch(:,1))
                endsearch_vec = datevec(endsearch(:,1))
                tlower=datetime(startsearch)
                tupper = datetime(endsearch)
                Timestamp =table((tupper:caldays(1):tlower)');
                C = T_rain(ismember(T_rain(:,1),Timestamp(:,1)),:)
                Precip = [datevec(table2array(C(:,1))) table2array(C(:,2))]; 
                Precip(:,4:6) = [];
              
                [ap]=crozier(Precip,[N+1],0.9)

                 sx(jdx,1)=ap
                 clear ap ,clear C ,clear starttime and endsearch;
            end
            
%             Obtaing pvalues and rho values
    [rho(idx,:) pval(idx,:)] = corr(t_trigging(:,4),sx,'type','kendall')%Spearman
    %A p-value less than 0.05 is typically considered to be statistically significant
    % lag_acum=[l_trigger(:,1:3) sx(:,1)];
disp(N)
    % writematrix(lag_acum,[num2str(STN{1,1},'%5d'),'_30_crozier.txt'],'Delimiter','tab');
    clear lag_acum l_trigger Rain_STN Precip_TS T_slides T_rain s_trigg  sx
end


