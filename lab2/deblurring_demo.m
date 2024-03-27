% Read data
aperture = imread('apertures/zhou.bmp');
image = imread('images/penguins.jpg');

% Noise level (Gaussian noise)
sigma = 0.005;

% Blur size
blurSize = 7; %7

% for blurSize = [2, 7, 12]

f0 = im2double(image);
[height, width, channel] = size(f0);

% Prior matrix: 1/f law
A_star = eMakePrior(height, width) + 0.00000001;
C = sigma.^2 * height * width ./ A_star;

% Normalization
temp = fspecial('disk', blurSize);
flow = max(temp(:));

% Calculate effective PSF
k1 = im2double(...
    imresize(aperture, [2*blurSize + 1, 2*blurSize + 1], 'nearest')...
);

k1 = k1 * (flow / max(k1(:)));

for sigma = [0.5, 0.05, 0.005]
    for it = [1, 10, 100]
        dirName = ['figures/zhou/blur/deconvlucy/color/sigma_', num2str(sigma)];
        if ~exist(dirName, 'dir')
        mkdir(dirName);
        end
        filename_rec = [dirName, '/recovered_', num2str(it), '.png'];
        filename_def = [dirName, '/defocused_', num2str(it), '.png'];

        % Initialize color image matrices
        f1 = zeros(height, width, channel);
        f0_hat = zeros(height, width, channel);
        
        % Apply blur and recover for each color channel
        for ch = 1:channel
            f0_ch = f0(:,:,ch);
            f1_ch = zDefocused(f0_ch, k1, sigma, 0);
            f0_hat_ch = deconvlucy(f1_ch,k1, it);
            f1(:,:,ch) = f1_ch;
            f0_hat(:,:,ch) = f0_hat_ch;
        end
        
        imwrite(f0_hat, filename_rec);
        imwrite(f1, filename_def);
        
    end
end
