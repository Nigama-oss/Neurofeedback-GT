% Load the EEG data file
EEG = pop_loadset('D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed\Closed Loop\S01_F_CL_Sil_50_100.set');

% Reshape the data matrix to a two-dimensional matrix
data = reshape(EEG.data, EEG.nbchan, EEG.pnts * EEG.trials);

% Compute the cross-covariance matrix of the EEG data
C = cov(data.');

% Compute the adjacency matrix
W = abs(C) > mean(abs(C(:)));

% Convert W to a double matrix
W = double(W);

% Compute the betweenness centrality
bc = betweenness_wei(W);

figure;
plot(bc);
hold on;
[bc_max, node_bc_max] = max(bc);
stem(node_bc_max, bc_max, 'or');
ylabel('betweenness centrality');
xlabel('nodes');
