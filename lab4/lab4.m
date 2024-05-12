% NLOS Imaging

% Load the data
% data = load_hdf5_dataset('Data\Z_d=0.5_l=[1x1]_s=[256x256].hdf5');

G = backProjection_reconstruction(data, 16);

f_lap = fspecial3('laplacian');
G_lap = imfilter(G, -f_lap, "symmetric");
volumeViewer(G_lap);
G_squeeze = squeeze(max(G_lap, [], 2));
colormap(hot(256));
imagesc(rot90(G_squeeze,2));