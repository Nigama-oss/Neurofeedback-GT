% Set the folder paths containing the .set EEG files
folderPaths = {'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Open Loop', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Closed Loop', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Resting'};

folderTitles = {'Closed Loop', 'Open Loop', 'Resting'};

% Initialize variables
mscValues = cell(1, numel(folderPaths));

% Loop through each folder
for f = 1:numel(folderPaths)
    folderPath = folderPaths{f};
    
    % Get a list of all .set files in the folder
    fileList = dir(fullfile(folderPath, '*.set'));

    % Loop through each .set file
    for i = 1:numel(fileList)
        % Load the EEG data using EEGLAB
        EEG = pop_loadset(fullfile(folderPath, fileList(i).name));

        % Compute the cross-spectral density matrix
        CSD = mscohere(EEG.data', EEG.data');

        % Calculate the mean square coherence (MSC)
        N = size(CSD, 1);
        MSC = sum(diag(CSD)) / N;

        % Store the MSC for the current EEG file
        mscValues{f} = [mscValues{f}, MSC];
    end
end

% Generate a box plot for each folder side by side with individual titles
figure;

numFolders = numel(folderPaths);
for f = 1:numFolders
    subplot(1, numFolders, f);
    boxplot(mscValues{f});
    ylabel('MSC');
    title(folderTitles{f});
    xticklabels({''});
end