clc; clear all; close all;
cor_path='I:\data\STAND_ALONE_LAG_EVENTS\ideal_lag\ideal_lag new\';
Rain_STN_path='I:\data\raw_data_imd\dist_fromsite\rain_data_threholds_applied\new\' % Path to rain data
addpath 'I:\data\STAND_ALONE_LAG_EVENTS\quantreg'
land_path='I:\data\imd_data_gridded\lag_rainevents\' % Path to landslide data
Station_list = dir(sprintf('%s%s',fullfile(cor_path),'*.xlsx'));
StationIndex = find(~[Station_list.isdir]);
% figure;
Station_list_ = dir(sprintf('%s%s',fullfile(land_path),'*.txt'));

idx = 2;


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
        
          subplot(3,3,idx-1);
        

% Plot the triggering events with a different color marker
x = data(:, 2);
y = data(:, 1);
x_ = Trigging_data(:, 2);
y_ = Trigging_data(:, 1);
x_c= data_combined(:, 2);
y_c= data_combined(:, 1);
hold on
s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
hold on
h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');

grid on;

n = 1;
tau = 0.20;
[b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
set(h(1),'LineWidth',2,'Color',[1 0 0])
 title('Darjeeling')


    
n = 1;
tau_5 = 0.5;
[b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])


n = 1;
tau_1 = 0.1;
[b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
set(h(1),'LineWidth',2,'LineStyle','--')
% Add quantile regression equation to plot
a = b(1);
b_val = b(2);
eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
% xlabel('Duration  $d$\textit (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
% ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
      
        lgd = legend('show', 'Location', 'best', 'FontName', 'Arial', 'FontSize', 8, 'AutoUpdate', 'off');
         lgd.Box = 'off';
         lgd.ItemTokenSize = [18 18];
         lgd.NumColumns =1;
         lgd.Position(1) = lgd.Position(1) + 0.05;
       lgd.Position(2) = lgd.Position(2) + 0.02;    

       
%       Set the distance between the axis and labels
     set(gca, 'FontSize', 14);
     set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
     set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
    
    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str



    idx =3 

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
        
          subplot(3,3,idx-1);
        
        % Plot the triggering events with a different color marker
        x = data(:, 2);
        y = data(:, 1);
        x_ = Trigging_data(:, 2);
        y_ = Trigging_data(:, 1);
        x_c= data_combined(:, 2);
        y_c= data_combined(:, 1);
        hold on
        s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
        hold on
        h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');
        
        grid on;
        
        n = 1;
        tau = 0.2;
        [b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
        set(h(1),'LineWidth',2,'Color',[1 0 0])

                n = 1;
        tau_5 = 0.5;
        [b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])
        
        
        n = 1;
        tau_1 = 0.1;
        [b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--')
        % Add quantile regression equation to plot
        a = b(1);
        b_val = b(2);
        eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
        % xlabel('Duration  $d$\textit (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
        % ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
         % xlabel('Duration  $d$\textit (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');

    
    title('Kalimpong')
     
%       Set the distance between the axis and labels
    set(gca, 'FontSize', 14);
    set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
    set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
 
    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str


  idx =4 
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
        
          subplot(3,3,idx-1);
        
        % Plot the triggering events with a different color marker
        x = data(:, 2);
        y = data(:, 1);
        x_ = Trigging_data(:, 2);
        y_ = Trigging_data(:, 1);
        x_c= data_combined(:, 2);
        y_c= data_combined(:, 1);
        hold on
        s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
        hold on
        h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');
        
        grid on;
        
        n = 1;
        tau = 0.2;
        [b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
        set(h(1),'LineWidth',2,'Color',[1 0 0])

        n = 1;
        tau_5 = 0.5;
        [b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])
        
        
        n = 1;
        tau_1 = 0.1;
        [b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--')
        % Add quantile regression equation to plot
        a = b(1);
        b_val = b(2);
        eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
        % xlabel('Duration  $d$\textit (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
        % ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
      title('Gangtok')


%       Set the distance between the axis and labels
    set(gca, 'FontSize', 14);
    set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
    set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);

    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str

 idx =5 

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
        
          subplot(3,3,idx-1);
        
        % Plot the triggering events with a different color marker
        x = data(:, 2);
        y = data(:, 1);
        x_ = Trigging_data(:, 2);
        y_ = Trigging_data(:, 1);
        x_c= data_combined(:, 2);
        y_c= data_combined(:, 1);
        hold on
        s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
        hold on
        h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');
        
        grid on;
        
        n = 1;
        tau = 0.2;
        [b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
        set(h(1),'LineWidth',2,'Color',[1 0 0])

        n = 1;
        tau_5 = 0.5;
        [b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])
        
        
        n = 1;
        tau_1 = 0.1;
        [b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--')
        % Add quantile regression equation to plot
        a = b(1);
        b_val = b(2);
        eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
       
    
    title('Guwahati')
     
%       Set the distance between the axis and labels
    set(gca, 'FontSize', 14);
    set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
    set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
     ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex');

    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str



   idx =6 

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
        
          subplot(3,3,idx-1);
        
        % Plot the triggering events with a different color marker
        x = data(:, 2);
        y = data(:, 1);
        x_ = Trigging_data(:, 2);
        y_ = Trigging_data(:, 1);
        x_c= data_combined(:, 2);
        y_c= data_combined(:, 1);
        hold on
        s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
        hold on
        h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');
        
        grid on;
        
        n = 1;
        tau = 0.2;
        [b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
        set(h(1),'LineWidth',2,'Color',[1 0 0])

        n = 1;
        tau_5 = 0.5;
        [b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])
        
        
        n = 1;
        tau_1 = 0.1;
        [b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--')
        % Add quantile regression equation to plot
        a = b(1);
        b_val = b(2);
        eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
       
    
    title('Shillong')
     
%       Set the distance between the axis and labels
    set(gca, 'FontSize', 14);
    set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
    set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
 
    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str


   idx =7
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
        
          subplot(3,3,idx-1);
        
        % Plot the triggering events with a different color marker
        x = data(:, 2);
        y = data(:, 1);
        x_ = Trigging_data(:, 2);
        y_ = Trigging_data(:, 1);
        x_c= data_combined(:, 2);
        y_c= data_combined(:, 1);
        hold on
        s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
        hold on
        h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');
        
        grid on;
        
        n = 1;
        tau = 0.2;
        [b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
        set(h(1),'LineWidth',2,'Color',[1 0 0])

        n = 1;
        tau_5 = 0.5;
        [b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])
        
        
        n = 1;
        tau_1 = 0.1;
        [b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--')
        % Add quantile regression equation to plot
        a = b(1);
        b_val = b(2);
        eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
       
    
    
    
    title("Kohima")
     
%       Set the distance between the axis and labels
    set(gca, 'FontSize', 14);
    set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
    set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
    % xlabel('Duration  $d$\textit (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');

    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str

   idx =8

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
        
          subplot(3,3,idx-1);
        
        % Plot the triggering events with a different color marker
        x = data(:, 2);
        y = data(:, 1);
        x_ = Trigging_data(:, 2);
        y_ = Trigging_data(:, 1);
        x_c= data_combined(:, 2);
        y_c= data_combined(:, 1);
        hold on
        s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
        hold on
        h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');
        
        grid on;
        
        n = 1;
        tau = 0.2;
        [b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
        set(h(1),'LineWidth',2,'Color',[1 0 0])
        
        n = 1;
        tau_5 = 0.5;
        [b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])
        
        
        n = 1;
        tau_1 = 0.1;
        [b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
        set(h(1),'LineWidth',2,'LineStyle','--')
        % Add quantile regression equation to plot
        a = b(1);
        b_val = b(2);
        eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
       
    
    
    
    title('Imphal')
     
%       Set the distance between the axis and labels
    set(gca, 'FontSize', 14);
    set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
    set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
%  xlabel('Duration (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');

    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str


idx = 9;


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
        
          subplot(3,3,idx-1);
        

% Plot the triggering events with a different color marker
x = data(:, 2);
y = data(:, 1);
x_ = Trigging_data(:, 2);
y_ = Trigging_data(:, 1);
x_c= data_combined(:, 2);
y_c= data_combined(:, 1);
hold on
s = scatter(x, y, 60, [0 0 0], 'o','MarkerEdgeColor', [0 0 1], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Non-triggering events');
hold on
h=scatter(x_, y_, 60, [1 0 0], 'o', 'filled', 'MarkerEdgeColor', [1 0 0], 'LineWidth', 2, 'MarkerFaceAlpha', 0.5, 'DisplayName', 'Triggering events');

grid on;

n = 1;
tau = 0.20;
[b,h] = ncquantreg(x_c,y_c,n,tau,'plot',2);
set(h(1),'LineWidth',2,'Color',[1 0 0])
 title('Aizwal')


    
n = 1;
tau_5 = 0.5;
[b,h] = ncquantreg(x_c,y_c,n,tau_5,'plot',2);
set(h(1),'LineWidth',2,'LineStyle','--','Color',[0.4 1 0.4])


n = 1;
tau_1 = 0.1;
[b,h] = ncquantreg(x_c,y_c,n,tau_1,'plot',2);
set(h(1),'LineWidth',2,'LineStyle','--')
% Add quantile regression equation to plot
a = b(1);
b_val = b(2);
eqn_str = sprintf('E = %.2f + %.2f*(duration)', a, b_val);
text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 8);
% ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');

 

       
%       Set the distance between the axis and labels
     set(gca, 'FontSize', 14);
     set(gca, 'TickLength', [0.02 0.02]);
     set(gca, 'TickLabelInterpreter', 'latex');
     set(gca, 'YMinorTick', 'on');
     set(gca, 'YGrid', 'on');
     set(gca, 'Box', 'on');
     set(gca, 'LineWidth', 1.2);
    % Add space between axis and labels
    set(gca, 'TickLabelInterpreter', 'latex', 'TickLength', [0.02, 0.02], 'FontSize', 10);
     xlabel('Duration  $d$\textit (days)', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex');

    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str
