clc; clear all; close all;
cor_path='I:\data\STAND_ALONE_LAG_EVENTS\ideal_lag\ideal_lag new\';

Station_list = dir(sprintf('%s%s',fullfile(cor_path),'*.xlsx'));
StationIndex = find(~[Station_list.isdir]);
% figure;

for    idx =10

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
        
        data(:,2)=data(:,2)*24
        Trigging_data(:,2)=Trigging_data(:,2)*24
        data_combined(:,2)=data_combined(:,2)*24


     
        
        
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
        

        % plot the line
        dur_range = min(x_c):max(x_c); % duration range
        E = 14.82 * (dur_range .^ 0.61); % calculate E for each duration in range
        plot(dur_range, E, 'LineWidth', 2, 'Color', [0 1 1], 'DisplayName', 'E=14.82*(Duration)^0.61');
        E_2=4.93*(dur_range .^ 0.504)
        plot(dur_range, E_2, 'LineWidth', 2, 'Color', [0 0 0], 'DisplayName', 'E=4.93*(Duration)^0.504');

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
        text(0.05, 0.85, eqn_str, 'Units', 'normalized', 'FontSize', 14);
        % xlabel('Duration  $d$\textit (days)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
        % ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');

    
    title(STN{1,1})
     % Add legend and set its properties
         lgd = legend('show', 'Location', 'best', 'FontName', 'Arial', 'FontSize', 14, 'AutoUpdate', 'off');
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
  ylabel('Rainfall $E$\textit   (mm)', 'FontSize', 24, 'FontWeight', 'bold', 'Interpreter', 'latex');
 xlabel('Duration (h)', 'FontSize', 24, 'FontWeight', 'bold', 'Interpreter', 'latex');

    axis tight
    hold off
    clear data PATHSTR Trigging_data Station STN uniqueDuration groupedData x y x_ y_ x_c y_c eqn_str
end
