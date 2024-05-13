% NLOS Imaging

% Load the data
% data = load_hdf5_dataset('Data\planes_d=0.5_l=[16x16]_s=[16x16].hdf5');

% Start the timer

tic;

% Perform the back-projection reconstruction
G = backProjection_reconstruction_attenuation(data, 16, 1);

% Stop the timer and display the elapsed time
elapsed_time = toc;
% fprintf('Resolution: %d, Capture: %d\n', v, c);
fprintf('Elapsed time: %.6f seconds\n', elapsed_time);

% Save the reconstructed volume
filename = sprintf('planes_d=0.5_l=[16x16]_s=[16x16]_attenuated_v=%d_c=%d.mat', 16, 1);
save(filename, 'G');

f_lap = fspecial3('lap');
G_lap = imfilter(G, -f_lap, "symmetric");
% volumeViewer(G);
volumeViewer(G_lap)
G_squeeze = squeeze(max(G, [], 3));
colormap(hot(256));
imagesc(rot90(G_squeeze,2));
