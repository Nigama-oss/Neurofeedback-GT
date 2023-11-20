% Define the mean and standard deviation values for each feature in group 1
group1_mean = [0.1249, 0.0011843, 0.35299, 0.284713, 0.143389]; % Mean values for each feature in group 1
group1_std = [0.021206, 0.00073405, 0.031985, 0.030191, 0.058240]; % Standard deviation values for each feature in group 1

% Define the mean and standard deviation values for each feature in group 2
group2_mean = [0.13386, 0.0010988, 0.36507, 0.293855, 0.137285]; % Mean values for each feature in group 2
group2_std = [0.020629, 0.00059938, 0.028348, 0.026300, 0.048037]; % Standard deviation values for each feature in group 2

% Concatenate the data for all features and groups
data = [group1_mean; group2_mean];

% Compute the number of groups and the number of samples per group
[num_groups, num_features] = size(data);
num_samples_per_group = ones(1, num_groups) * num_features;

% Compute the sums of squares for each group
SSG = num_features * sum((mean(data) - mean(mean(data))).^2);

% Compute the sums of squares within each group
SSW = 0;
for i = 1:num_groups
    SSW = SSW + sum((data(i, :) - mean(data(i, :))).^2);
end

% Compute the total sums of squares
SST = SSG + SSW;

% Compute the degrees of freedom
dfG = num_groups - 1;
dfW = num_features * (num_groups - 1);
dfT = num_samples_per_group - 1;

% Compute the mean squares
MSG = SSG / dfG;
MSW = SSW / dfW;

% Compute the F-statistic
F = MSG / MSW;

% Compute the p-value using the F-distribution
p_value = 1 - fcdf(F, dfG, dfW);

% Display the results
disp('One-way ANOVA Results:');
disp(['F-statistic: ', num2str(F)]);
disp(['p-value: ', num2str(p_value)]);


