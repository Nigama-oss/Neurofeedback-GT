% Set the folder paths containing the .set EEG files
folderPaths = {'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Open Loop', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Closed Loop', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Resting'};

folderTitles = {'Closed Loop', 'Open Loop', 'Resting'};

% Initialize variables
pliValues = cell(1, numel(folderPaths));
numGroups = 10; % Number of groups or regions
numPairsPerGroup = 100; % Number of pairs to compute PLI within each group

% Loop through each folder
for f = 1:numel(folderPaths)
    folderPath = folderPaths{f};
    
    % Get a list of all .set files in the folder
    fileList = dir(fullfile(folderPath, '*.set'));
    
    % Loop through each .set file
    for i = 1:numel(fileList)
        % Load the EEG data using EEGLAB
        EEG = pop_loadset(fullfile(folderPath, fileList(i).name));

        % Compute the phase differences
        phaseDiff = angle(hilbert(EEG.data'));

        % Divide electrodes into groups or regions
        N = size(phaseDiff, 1);
        groupSize = ceil(N / numGroups);
        groups = cell(numGroups, 1);
        for j = 1:numGroups
            startIdx = (j - 1) * groupSize + 1;
            endIdx = min(startIdx + groupSize - 1, N);
            groups{j} = startIdx:endIdx;
        end

        % Calculate the phase lag index (PLI) within each group
        pli = zeros(numGroups, 1);
        for j = 1:numGroups
            pairs = nchoosek(groups{j}, 2);
            numPairs = min(numPairsPerGroup, size(pairs, 1));
            randPairs = pairs(randperm(size(pairs, 1), numPairs), :);

            pliVals = zeros(numPairs, 1);
            for k = 1:numPairs
                m = randPairs(k, 1);
                n = randPairs(k, 2);
                pliVals(k) = abs(mean(sign(sin(phaseDiff(m, :) - phaseDiff(n, :)))));
            end

            pli(j) = mean(pliVals);
        end

        % Average PLI across all groups
        averagePLI = mean(pli);

        % Store the PLI for the current EEG file
        pliValues{f} = [pliValues{f}, averagePLI];
    end
end

% Generate a box plot for each folder side by side
figure;
hold on;
numFolders = numel(folderPaths);
for f = 1:numFolders
    subplot(1, numFolders, f);
    boxplot(pliValues{f});
    ylabel('PLI');
    title(folderTitles{f});
    xticklabels({''});
end
hold off;