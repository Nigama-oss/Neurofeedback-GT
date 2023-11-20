% Load the EEG data file
EEG = pop_loadset('D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Closed Loop\S01_F_CL_Sil_50_100.set');

% Convert the EEG data to a matrix
data = EEG.data;

% Reshape the data array to a 2D matrix
[n_channels, n_samples, n_trials] = size(data);
data2d = reshape(data, n_channels, n_samples*n_trials);

% Compute the correlation matrix
R = corr(data2d.');

% Convert the correlation matrix to a binary matrix
B = threshold_absolute(R, 0.5); % you can adjust the threshold value as needed

% Calculate the shortest path length matrix
D = distance_bin(B);

% Calculate the characteristic path length
L = mean(D(D~=Inf));

% Display the result
fprintf('Characteristic path length: %.2f\n', L);
