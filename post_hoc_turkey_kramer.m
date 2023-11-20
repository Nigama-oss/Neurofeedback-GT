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

% Perform one-way ANOVA
[p, tbl, stats] = anova1(data, [], 'off');

% Display ANOVA table
disp('One-way ANOVA Results:');
disp(tbl);

% Set significance level
alpha = 0.05;

% Perform pairwise comparisons using Tukey-Kramer test
[p_values, ~, ~, comparison_labels] = multcompare(stats, 'CType', 'tukey-kramer');

% Identify significant features
significant_features = cell(1, num_features);
for i = 1:num_features
    feature_p_values = p_values((i-1)*num_groups+1 : i*num_groups, 6);
    significant_features{i} = comparison_labels(feature_p_values < alpha, :);
end

% Define feature names
feature_names = {'Small World Index', 'Rich Club Coefficient', 'Average Connectivity', 'Eigenvector Centrality', 'Betweenness Centrality'};

% Display significant features
for i = 1:num_features
    disp(['Significant features for ', feature_names{i}]);
    disp(significant_features{i});
    disp(' ');
end