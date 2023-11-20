% Set the folder paths containing the .set EEG files
folderPaths = {'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Open Loop', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Closed Loop', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Resting'};
folderTitles = {'Closed Loop', 'Open Loop', 'Resting'};

% Initialize variables
swIndices = cell(1, numel(folderPaths));

% Loop through each folder
for f = 1:numel(folderPaths)
    folderPath = folderPaths{f};
    
    % Get a list of all .set files in the folder
    fileList = dir(fullfile(folderPath, '*.set'));
    
    % Loop through each .set file
    for i = 1:numel(fileList)
        % Load the EEG data using EEGLAB
        EEG = pop_loadset(fullfile(folderPath, fileList(i).name));

        % Get the adjacency matrix from the EEG data
        adjacencyMatrix = abs(corr(EEG.data'));

        % Calculate the small-world index
        clusteringCoefficients = clustering_coef_bu(adjacencyMatrix);
        characteristicPathLength = charpath(distance_wei(weight_conversion(adjacencyMatrix, 'lengths')));
        smallWorldIndex = mean(clusteringCoefficients) / characteristicPathLength;

        % Store the small-world index for the current EEG file
        swIndices{f} = [swIndices{f}, smallWorldIndex];
    end
end

% Generate a box plot for each folder side by side
figure;
hold on;
numFolders = numel(folderPaths);
for f = 1:numFolders
    subplot(1, numFolders, f);
    boxplot(swIndices{f});
    ylabel('SWI');
    title(folderTitles{f});
    xticklabels({''});
end
hold off;
