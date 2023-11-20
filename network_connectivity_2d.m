% Load EEG data in .set format
eeg_file = 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\S02_F_CL_Sil_50_100.set';
EEG = pop_loadset(eeg_file);

% Compute adjacency matrix
adj_matrix = abs(corr(EEG.data'));

% Threshold the adjacency matrix
threshold = 0.5; % Adjust the threshold as per your requirements
adj_matrix_thresholded = adj_matrix > threshold;

% Get channel locations and names
channel_locs = EEG.chanlocs;
channel_names = {channel_locs.labels};

% Compute node connectivity (degree)
node_connectivity = sum(adj_matrix_thresholded, 2);

% Define colormap for nodes
node_cmap = jet;

% Normalize node connectivity values
node_connectivity_norm = (node_connectivity - min(node_connectivity)) / (max(node_connectivity) - min(node_connectivity));

% Plot brain network in 2D
figure;
hold on;

% Plot connections
[row, col] = find(adj_matrix_thresholded);
for i = 1:numel(row)
    x1 = channel_locs(row(i)).X;
    y1 = channel_locs(row(i)).Y;
    
    x2 = channel_locs(col(i)).X;
    y2 = channel_locs(col(i)).Y;
    
    % Calculate index for colormap
    strength = adj_matrix(row(i), col(i));
    [~, idx] = min(abs(strength - linspace(0, 1, size(node_cmap, 1))));
    
    line([x1 x2], [y1 y2], 'Color', node_cmap(idx, :), 'LineWidth', 1.5);
end

% Plot nodes with color based on connectivity
scatter([channel_locs.X], [channel_locs.Y], 100, node_connectivity_norm, 'filled', 'MarkerFaceAlpha', 0.8);
colormap(node_cmap); % Set the colormap
colorbar; % Add color bar

% Add node names
for i = 1:numel(channel_locs)
    text(channel_locs(i).X, channel_locs(i).Y, channel_names{i}, 'HorizontalAlignment', 'center');
end

title('Brain Network (2D)');
xlabel('X');
ylabel('Y');
axis equal; % Set equal aspect ratio