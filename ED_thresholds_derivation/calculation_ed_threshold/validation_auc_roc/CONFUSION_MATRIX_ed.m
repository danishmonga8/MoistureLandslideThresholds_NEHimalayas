 
clc; clear all; close all;
cor_path='I:\data\STAND_ALONE_LAG_EVENTS\ideal_lag\ideal_lag new\';
Rain_STN_path='I:\data\raw_data_imd\dist_fromsite\rain_data_threholds_applied\new\' % Path to rain data

land_path='I:\data\imd_data_gridded\lag_rainevents\' % Path to landslide data
Station_list = dir(sprintf('%s%s',fullfile(cor_path),'*.xlsx'));
StationIndex = find(~[Station_list.isdir]);
% figure;
Station_list_ = dir(sprintf('%s%s',fullfile(land_path),'*.txt'));

    idx = 4;


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
        
% Define the proportion of the data to include in the training set
train_proportion = 0.8;

% Calculate the number of observations to include in the training set
num_train = round(train_proportion * size(data_combined, 1));

% Create a logical index vector where training instances are 1 and the rest are 0
rng(28797);
idx = randperm(size(data_combined, 1));
train_idx = false(size(data_combined, 1), 1);
train_idx(idx(1:num_train)) = true;

% Define the training set
D = data_combined(train_idx, 2); % Duration
y = data_combined(train_idx, 1); % rainfall

% Define the test set
D_test = data_combined(~train_idx, 2);
y_test = data_combined(~train_idx, 1);

% Derive the parameters a and b using the training set
n = 1;
tau = 0.20;
[b,~] = ncquantreg(D, y, n, tau);
a = b(1);
b = b(2);

% Apply the derived parameters to the entire dataset
y_pred_train = a + b*D;
y_pred_test = a + b*D_test;
max(y_pred_train)
max(D)
% Define the threshold for binary conversion
threshold = prctile(y_pred_train, 20);

% Convert the test outcomes and predictions to binary form
y_test_bin = y_test >= threshold;
y_pred_test_bin = y_pred_test >= threshold;

% Initialize the confusion matrix
TP = 0; FP = 0; FN = 0; TN = 0;

% Calculate the confusion matrix
for i = 1:length(y_test_bin)
    if y_test_bin(i) == 1 && y_pred_test_bin(i) == 1
        TP = TP + 1;
    elseif y_test_bin(i) == 0 && y_pred_test_bin(i) == 1
        FP = FP + 1;
    elseif y_test_bin(i) == 1 && y_pred_test_bin(i) == 0
        FN = FN + 1;
    else
        TN = TN + 1;
    end
end



% Display the confusion matrix
disp('Confusion matrix:');
disp([TP, FP; FN, TN]);



% Calculate the ROC curve and AUC
[X,Y,T,AUC] = perfcurve(y_test_bin, y_pred_test, 1); 

% Display the AUC
fprintf('AUC: %.2f\n', AUC);

% Plot the ROC curve with labels and title
figure;
% Subplot 1
subplot(1, 3, 1);
plot(X,Y, 'LineWidth', 2) % Increased line width for better visibility
hold on;
plot([0 1], [0 1], '--k', 'LineWidth', 1.5) % Added 1:1 reference line

% Enhancing labels and title 
xlabel('False Positive Rate', 'FontSize',17,'FontWeight','bold')
ylabel('True Positive Rate', 'FontSize',17,'FontWeight','bold')
title('Gangtok','FontSize',17,'FontWeight','bold')
% Add AUC to the plot
% Add AUC to the plot with a box
str = sprintf('AUC: %.2f', AUC);
dim = [.7 .2 .3 .3]; % position and size of the box (left, bottom, width, height)
annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize', 12);
% Adjusting axis for equal scaling 
axis equal 
xlim([-0.1, 1])
ylim([-0, 1])

grid on; % Added grid for better readability of plot points

hold on;


    idx = 7;


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
        
% Define the proportion of the data to include in the training set
train_proportion = 0.8;

% Calculate the number of observations to include in the training set
num_train = round(train_proportion * size(data_combined, 1));

% Create a logical index vector where training instances are 1 and the rest are 0
rng(1432);
idx = randperm(size(data_combined, 1));
train_idx = false(size(data_combined, 1), 1);
train_idx(idx(1:num_train)) = true;

% Define the training set
D = data_combined(train_idx, 2); % Duration
y = data_combined(train_idx, 1); % rainfall

% Define the test set
D_test = data_combined(~train_idx, 2);
y_test = data_combined(~train_idx, 1);

% Derive the parameters a and b using the training set
n = 1;
tau = 0.20;
[b,~] = ncquantreg(D, y, n, tau);
a = b(1);
b = b(2);

% Apply the derived parameters to the entire dataset
y_pred_train = a + b*D;
y_pred_test = a + b*D_test;
max(y_pred_train)
max(D)
% Define the threshold for binary conversion
threshold = prctile(y_pred_train, 20);

% Convert the test outcomes and predictions to binary form
y_test_bin = y_test >= threshold;
y_pred_test_bin = y_pred_test >= threshold;

% Initialize the confusion matrix
TP = 0; FP = 0; FN = 0; TN = 0;

% Calculate the confusion matrix
for i = 1:length(y_test_bin)
    if y_test_bin(i) == 1 && y_pred_test_bin(i) == 1
        TP = TP + 1;
    elseif y_test_bin(i) == 0 && y_pred_test_bin(i) == 1
        FP = FP + 1;
    elseif y_test_bin(i) == 1 && y_pred_test_bin(i) == 0
        FN = FN + 1;
    else
        TN = TN + 1;
    end
end



% Display the confusion matrix
disp('Confusion matrix:');
disp([TP, FP; FN, TN]);



% Calculate the ROC curve and AUC
[X,Y,T,AUC] = perfcurve(y_test_bin, y_pred_test, 1); 

% Display the AUC
fprintf('AUC: %.2f\n', AUC);

% Plot the ROC curve with labels and title

% Subplot 1
subplot(1, 3, 2);
plot(X,Y, 'LineWidth', 2) % Increased line width for better visibility
hold on;
plot([0 1], [0 1], '--k', 'LineWidth', 1.5) % Added 1:1 reference line

% Enhancing labels and title 
xlabel('False Positive Rate', 'FontSize',17,'FontWeight','bold')
ylabel('True Positive Rate', 'FontSize',17,'FontWeight','bold')
title('Kohima','FontSize',17,'FontWeight','bold')
% Add AUC to the plot
% Add AUC to the plot with a box
str = sprintf('AUC: %.2f', AUC);
dim = [.7 .2 .3 .3]; % position and size of the box (left, bottom, width, height)
annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize', 12);
% Adjusting axis for equal scaling 
axis equal 
xlim([-0.1, 1])
ylim([-0, 1])

grid on; % Added grid for better readability of plot points

hold on;

  idx = 3;


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
        
% Define the proportion of the data to include in the training set
train_proportion = 0.8;

% Calculate the number of observations to include in the training set
num_train = round(train_proportion * size(data_combined, 1));

% Create a logical index vector where training instances are 1 and the rest are 0
rng(124);
idx = randperm(size(data_combined, 1));
train_idx = false(size(data_combined, 1), 1);
train_idx(idx(1:num_train)) = true;

% Define the training set
D = data_combined(train_idx, 2); % Duration
y = data_combined(train_idx, 1); % rainfall

% Define the test set
D_test = data_combined(~train_idx, 2);
y_test = data_combined(~train_idx, 1);

% Derive the parameters a and b using the training set
n = 1;
tau = 0.20;
[b,~] = ncquantreg(D, y, n, tau);
a = b(1);
b = b(2);

% Apply the derived parameters to the entire dataset
y_pred_train = a + b*D;
y_pred_test = a + b*D_test;
max(y_pred_train)
max(D)
% Define the threshold for binary conversion
threshold = prctile(y_pred_train, 20);

% Convert the test outcomes and predictions to binary form
y_test_bin = y_test >= threshold;
y_pred_test_bin = y_pred_test >= threshold;

% Initialize the confusion matrix
TP = 0; FP = 0; FN = 0; TN = 0;

% Calculate the confusion matrix
for i = 1:length(y_test_bin)
    if y_test_bin(i) == 1 && y_pred_test_bin(i) == 1
        TP = TP + 1;
    elseif y_test_bin(i) == 0 && y_pred_test_bin(i) == 1
        FP = FP + 1;
    elseif y_test_bin(i) == 1 && y_pred_test_bin(i) == 0
        FN = FN + 1;
    else
        TN = TN + 1;
    end
end



% Display the confusion matrix
disp('Confusion matrix:');
disp([TP, FP; FN, TN]);



% Calculate the ROC curve and AUC
[X,Y,T,AUC] = perfcurve(y_test_bin, y_pred_test, 1); 

% Display the AUC
fprintf('AUC: %.2f\n', AUC);

% Plot the ROC curve with labels and title

% Subplot 1
subplot(1, 3, 3);
plot(X,Y, 'LineWidth', 2) % Increased line width for better visibility
hold on;
plot([0 1], [0 1], '--k', 'LineWidth', 1.5) % Added 1:1 reference line

% Enhancing labels and title 
xlabel('False Positive Rate', 'FontSize',17,'FontWeight','bold')
ylabel('True Positive Rate', 'FontSize',17,'FontWeight','bold')
title('Kalimpong','FontSize',17,'FontWeight','bold')
% Add AUC to the plot
% Add AUC to the plot with a box
str = sprintf('AUC: %.2f', AUC);
dim = [.7 .2 .3 .3]; % position and size of the box (left, bottom, width, height)
annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize', 12);
% Adjusting axis for equal scaling 
axis equal 
xlim([-0.1, 1])
ylim([-0, 1])

grid on; % Added grid for better readability of plot points

hold off;














% % Initialize the confusion matrix for training data
% TP_train = 0; FP_train = 0; FN_train = 0; TN_train = 0;
% 
% % Convert the training outcomes and predictions to binary form
% y_train_bin = y > threshold;
% y_pred_train_bin = y_pred_train > threshold;
% 
% % Calculate the confusion matrix for training data
% for i = 1:length(y_train_bin)
%     if y_train_bin(i) == 1 && y_pred_train_bin(i) == 1
%         TP_train = TP_train + 1;
%     elseif y_train_bin(i) == 0 && y_pred_train_bin(i) == 1
%         FP_train = FP_train + 1;
%     elseif y_train_bin(i) == 1 && y_pred_train_bin(i) == 0
%         FN_train = FN_train + 1;
%     else
%         TN_train = TN_train + 1;
%     end
% end

% % Display the confusion matrix for training data
% disp('Confusion matrix for training data:');
% disp([TP_train, FP_train; FN_train, TN_train]);

% % Calculate rates for training data
% FPR_train = FP_train / (FP_train + TN_train);
% TNR_train = TN_train / (FP_train + TN_train);
% 
% % Display rates for training data
% % disp(['Training Data: FPR = ', num2str(FPR_train), ', TNR = ', num2str(TNR_train)]);
% 
% % Calculate rates for test data
% FPR_test = FP / (FP + TN);
% TNR_test = TN / (FP + TN);
% 
% % Display rates for test data
% disp(['Test Data: FPR = ', num2str(FPR_test), ', TNR = ', num2str(TNR_test)]);
% 
% 
% 
% % Calculate precision, recall, and F-score
% Precision = TP / (TP + FP);
% Recall = TP / (TP + FN);
% % Calculate F-score for beta = 0.5, 1, 2
% beta = [0.5, 1, 2];
% F_score = (1 + beta.^2) .* (Precision .* Recall) ./ ((beta.^2 .* Precision) + Recall);
% % Calculate accuracy
% Accuracy = (TP + TN) / (TP + FP + FN + TN);
% % Calculate Specificity
% Specificity = TN / (TN + FP);
% % Calculate Negative Predictive Value (NPV)
% NPV = TN / (TN + FN);
% % Calculate False Positive Rate (FPR)
% FPR = FP / (FP + TN);
% % Calculate False Discovery Rate (FDR)
% FDR = FP / (FP + TP);
% % Calculate Matthews Correlation Coefficient (MCC)
% MCC = (TP*TN - FP*FN) / sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
% 
% 
% % Create a table to display the results
% results_TR_TE = table(Precision, Recall, F_score, Accuracy, Specificity, NPV, FPR, FDR, MCC);
% results_TR_TE.Properties.VariableNames = {'Precision', 'Recall', 'F_score', 'Accuracy', 'Specificity', 'NPV', 'FPR', 'FDR', 'MCC'};
% 
% % Display the results
% disp(results_TR_TE);
% % Specify the path and filename for the Excel file
% filename = 'F:\data\results_TR_TE.xlsx';
% 
% % Write the table to an Excel file
% writetable(results_TR_TE, filename);


%Recall: Recall is the ratio of correctly predicted positive observations to all observations in the actual class. It’s a measure of a classifier’s completeness. For example, if there were 100 landslides and your model identified 80, your recall would be 0.8.

%F-score: The F-score is the harmonic mean of precision and recall. It tries to find the balance between precision and recall. beta determines the weight of precision in the combined score. beta < 1 lends more weight to precision, while beta > 1 favors recall, and beta = 1 gives equal weight to both.

%Accuracy: Accuracy is the ratio of correctly predicted observations to the total observations. For example, if your model correctly predicted 100 landslides out of 120 total predictions, your accuracy would be 0.83.

%Specificity: Specificity is the ratio of correctly predicted negative observations to the total actual negatives. It%s a measure of the classifier’s ability to identify negative instances. For example, if there were 100 non-landslide events and your model identified 90, your specificity would be 0.9.

%Negative Predictive Value (NPV): NPV is the ratio of correctly predicted negative observations to the total predicted negatives. For example, if your model predicted 100 non-landslides and 90 of them were correct, your NPV would be 0.9.

%False Positive Rate (FPR): FPR is the ratio of incorrectly predicted positive observations to the total actual negatives. For example, if there were 100 non-landslide events and your model incorrectly identified 10 as landslides, your FPR would be 0.1.

%False Discovery Rate (FDR): FDR is the ratio of incorrectly predicted positive observations to the total predicted positives. For example, if your model predicted 100 landslides and 10 of them were incorrect, your FDR would be 0.1.

%Matthews Correlation Coefficient (MCC): The MCC is a measure of the quality of binary classifications. It takes into account true and false positives and negatives and is generally regarded as a balanced measure which can be used even if the classes are of very different sizes.


%As for the best parameter for your landslide prediction model, it depends on what you value most in your predictions. 
% If you care most about minimizing false positives (i.e., predicting a landslide when there isn%t one), you might value precision. \
% If you care most about catching all possible landslides, you might value recall. If you want a balance between the two, you might choose the F-score.
% If you care about overall correctness, you might choose accuracy. It\s important to consider the costs and benefits associated with each type of error in the context of your specific application. 


