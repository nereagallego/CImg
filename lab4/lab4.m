% NLOS Imaging

% Load the data
% data = load_hdf5_dataset('Data\Z_d=0.5_l=[1x1]_s=[256x256].hdf5');

G = backProjection_reconstruction(data);

volshow(G, volshow_config)