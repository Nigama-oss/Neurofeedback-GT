% Load EEG data in .set format
EEG = pop_loadset('filename', 'S01_C_OLoop.set', 'filepath', 'D:\Faller_et_al_2019_PNAS_EEG_Neurofeedback_VR_Flight\preprocessed');

% Extract adjacency matrix from the data
adj = zeros(EEG.nbchan);
for i = 1:EEG.nbchan
    for j = i+1:EEG.nbchan
        c1 = EEG.data(i,:);
        c2 = EEG.data(j,:);
        corr_coef = corrcoef(c1, c2);
        adj(i,j) = abs(corr_coef(1,2));
        adj(j,i) = adj(i,j);
    end
end

% Calculate clustering coefficient
clustering_coef = zeros(EEG.nbchan,1);
for i = 1:EEG.nbchan
    neighbors = find(adj(i,:));
    num_neighbors = length(neighbors);
    if num_neighbors >= 2
        subgraph = adj(neighbors,neighbors);
        num_edges = sum(subgraph(:))/2;
        clustering_coef(i) = 2*num_edges/(num_neighbors*(num_neighbors-1));
    end
end

% Plot clustering coefficient values
figure;
topoplot(clustering_coef, EEG.chanlocs, 'maplimits', [0 1]);
colorbar;
title('Clustering Coefficient');
