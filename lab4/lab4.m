% NLOS Imaging

% Load the data
data = load_hdf5_dataset('data/concavities_l[0.00,-0.50,0.00]_r[1.57,0.00,3.14]_v[0.81,0.51,0.80]_s[256]_l[256]_gs[1.00]_conf.hdf5');

% Start the timer

% tic;
% 
% % Perform the back-projection reconstruction
G = backProjection_confocal_reconstruction(data, 16, 1);
% 
% % Stop the timer and display the elapsed time
% elapsed_time = toc;
% % fprintf('Resolution: %d, Capture: %d\n', v, c);
% fprintf('Elapsed time: %.6f seconds\n', elapsed_time);
% 
% % Save the reconstructed volume
% filename = sprintf('Z_d=0.5_l=[1x1]_s=[256x256]_v=%d_c=%d.mat', 16, 1);
% save(filename, 'G');

%G = load("bunny_d=0.5_c=[256x256]_v=16_c=1.mat");
%G = G.G;

f_lap = fspecial3('lap');
G_lap = imfilter(G, -f_lap, "symmetric");
%volumeViewer(G);
volumeViewer(G_lap)
G_squeeze = squeeze(max(G, [], 3));
colormap(hot(256));
imagesc(rot90(G_squeeze,2));
