% Read data
aperture = imread('apertures/zhou.bmp');
image = imread('images/penguins.jpg');
image = image(:, :, 1);

% Noise level (Gaussian noise)
sigma = 0.005;

% Blur size
blurSize = 7; %7


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
        filename = ['figures/blur/wiener/sigma_', num2str(sigma), '/recovered', '.png'];
        % Apply blur
        f1 = zDefocused(f0, k1, sigma, 0);
     

        % Recover
        f0_hat = zDeconvWNR(f1, k1, C);
        % f0_hat = deconvlucy(f1,k1, it);
        % f0_hat = deconvwnr(f1,k1, C);
        imwrite(f0_hat, filename);
        
    end
end

% Apply blur
f1 = zDefocused(f0, k1, sigma, 0);

% Recover
f0_hat = zDeconvWNR(f1, k1, C);
% f0_hat = deconvlucy(f1,k1);

% Display results
figure;

subplot_tight(1, 3, 1, 0.0, false)
imshow(f0);
%title('Focused');

subplot_tight(1, 3, 2, 0.0, false)
imshow(f1);
%title('Defocused');

subplot_tight(1, 3, 3, 0.0, false)
imshow(f0_hat);
%title('Recovered');
