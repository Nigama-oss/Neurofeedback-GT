% Set the folder path containing the .set EEG files
folderPath = 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Open Loop';

% Get a list of all .set files in the folder
fileList = dir(fullfile(folderPath, '*.set'));

% Initialize variables
richClubCoefficients = [];

% Loop through each .set file
for i = 1:numel(fileList)
    % Load the EEG data using EEGLAB
    EEG = pop_loadset(fullfile(folderPath, fileList(i).name));
    
    % Get the adjacency matrix from the EEG data
    adjacencyMatrix = abs(corr(EEG.data'));
    
    % Calculate the rich club coefficient
    k = sum(adjacencyMatrix);
    k_c = clustering_coef_bu(adjacencyMatrix);
    k_c_normalized = k_c ./ (k.*(k-1));
    richClubCoefficients = [richClubCoefficients, mean(k_c_normalized)];
end

% Calculate the average and standard deviation of the rich club coefficient
averageRichClubCoefficient = mean(richClubCoefficients);
stdRichClubCoefficient = std(richClubCoefficients);

% Display the average and standard deviation of the rich club coefficient
disp(['Average Rich Club Coefficient across all files: ', num2str(averageRichClubCoefficient)]);
disp(['Standard Deviation of Rich Club Coefficient: ', num2str(stdRichClubCoefficient)]);