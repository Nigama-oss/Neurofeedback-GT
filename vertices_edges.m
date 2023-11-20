% Load the EEG data file
EEG = pop_loadset('D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\S01_C_OLoop.set');

% Get the number of vertices (channels)
num_vertices = size(EEG.data, 1);

% Get the number of edges
num_edges = num_vertices*(num_vertices-1)/2;

% Display the results
fprintf('Number of vertices: %d\n', num_vertices);
fprintf('Number of edges: %d\n', num_edges);