% lab 1 CImg assignment
% Authors: César Borja and Nerea Gallego

close all;

config_fig = 0;

% 2) Importing your image

% 2.1) Reading the image into Matlab

% Load the image in TIFF format into Matlab
% filename = 'images_tiff/bottles.tiff';
filename = 'images_raw/IMG_0596.tiff';
image = imread(filename);

% Check and report how many bits per pixel the image has.
info = imfinfo(filename);
bitsPerPixel = info.SamplesPerPixel * info.BitsPerSample;
fprintf('The image has %d bits per pixel\n', bitsPerPixel);

% Check its width and its height.
width = info.Width;
height = info.Height;
fprintf('The image is %d pixels wide and %d pixels high.\n', width, height);

% Convert the image into a double-precision array.
image = double(image);

% 2.2) Linearization

% Apply linear transformation
image = (image - 1023) / (15600 - 1023);

% Clip values to [0, 1]
image = max(min(image, 1), 0);
config_fig = config_fig + 1;
figure(config_fig); imshow(image);

% 3) Demosaicing (rggb)

% RGGB pattern
% 3.1) Demosaicing with nearest neighbor
demosaicNN = demosaicNearestNeighbor(image);

% 3.2) Demosaicing with bilinear interpolation
demosaicBI = demosaicingBilinearInterpolation(image);
config_fig = config_fig + 1;
figure(config_fig); imshow(demosaicBI);

% 4) White balancing
% 4.1) White balancing using the white world assumption
% whiteBalanced = whiteBalancingWhiteWorld(demosaicBI);
whiteBalanced = whiteBalancingGrayWorld(demosaicBI);
% whiteBalanced = whiteBalancedManualBalancing(demosaicBI);
config_fig = config_fig + 1;
figure(config_fig); imshow(whiteBalanced);

% 5) Denoising

% 5.1) Mean filtering
% filtered = mean_filtering(whiteBalanced);

% 5.2) Median filtering
% filtered = median_filtering(whiteBalanced);

% 5.3) Gaussian filtering
filtered = gaussian_filtering(whiteBalanced, 5, 1.0);

config_fig = config_fig + 1;
figure(config_fig); imshow(filtered);

% 6) Color balance
colorBalanced = colorBalance(filtered);
config_fig = config_fig + 1;
figure(config_fig); imshow(colorBalanced);

% 7) Tone reproduction

% Brighten the image
scale = 1.3;
colorBalanced = colorBalanced * scale;
% Ensure that no value exceeds 1
colorBalanced = min(colorBalanced, 1);
config_fig = config_fig + 1;
figure(config_fig); imshow(colorBalanced);

% Adjust exposure
alpha = 1.3;
colorBalanced = colorBalanced * 2^alpha;
config_fig = config_fig + 1;
figure(config_fig); imshow(colorBalanced);

% Gamma correction
gammaCorrected = gammaCorrection(colorBalanced, 0.8);
config_fig = config_fig + 1;
figure(config_fig); imshow(gammaCorrected);

% 8) Compression

% Save the image in PNG format
imwrite(gammaCorrected, 'imgs/finalImage.png');

% JPEG format with quality setting 95
imwrite(gammaCorrected, 'imgs/finalImage.jpg', 'Quality', 95);

% By changing the JPEG quality settings, determine the lowest setting for which the compressed image is indistinguishable from the original
for compress=100:-5:1
    filename = ['imgs/finalImage_compressed', num2str(compress), '.jpg'];
    imwrite(gammaCorrected, filename, 'Quality', compress);
end

function [outputImage] = demosaicNearestNeighbor(inputImage)
    % Get the size of the input image
    [height, width] = size(inputImage);
    
    % Initialize the output image
    outputImage = zeros(height, width, 3);
    
    % Red channel
    outputImage(1:2:end, 1:2:end, 1) = inputImage(1:2:end, 1:2:end);
    
    % Green channel
    outputImage(1:2:end, 2:2:end, 2) = inputImage(1:2:end, 2:2:end);
    outputImage(2:2:end, 1:2:end, 2) = inputImage(2:2:end, 1:2:end);
    
    % Blue channel
    outputImage(2:2:end, 2:2:end, 3) = inputImage(2:2:end, 2:2:end);
    
    % Nearest neighbor interpolation

    % Red channel
    outputImage(1:2:end, 2:2:end, 1) = outputImage(1:2:end, 1:2:end-1, 1);
    outputImage(2:2:end, 1:2:end, 1) = outputImage(1:2:end-1, 1:2:end, 1);
    outputImage(2:2:end, 2:2:end, 1) = outputImage(1:2:end-1, 1:2:end-1, 1);
    
    % Green channel
    outputImage(2:2:end, 2:2:end, 2) = outputImage(2:2:end, 1:2:end-1, 2);
    outputImage(1:2:end, 1:2:end, 2) = outputImage(1:2:end, 2:2:end, 2);
    
    % Blue channel
    outputImage(2:2:end, 1:2:end, 3) = outputImage(2:2:end, 2:2:end, 3);
    outputImage(1:2:end, 2:2:end, 3) = outputImage(2:2:end, 2:2:end, 3);
    outputImage(1:2:end, 1:2:end, 3) = outputImage(2:2:end, 2:2:end, 3);
end

function [outputImage] = demosaicingBilinearInterpolation(inputImage)
    % Get the size of the input image
    [height, width] = size(inputImage);
    
    % Initialize the output image
    outputImage = zeros(height, width, 3);
    
    % Red channel
    outputImage(1:2:end, 1:2:end, 1) = inputImage(1:2:end, 1:2:end);
    
    % Green channel
    outputImage(1:2:end, 2:2:end, 2) = inputImage(1:2:end, 2:2:end);
    outputImage(2:2:end, 1:2:end, 2) = inputImage(2:2:end, 1:2:end);
    
    % Blue channel
    outputImage(2:2:end, 2:2:end, 3) = inputImage(2:2:end, 2:2:end);
    
    % Bilinear interpolation

    % Red channel
    outputImage(2:2:end-1, 2:2:end-1,1) = (outputImage(1:2:end-2,1:2:end-2,1) + outputImage(1:2:end-2,3:2:end,1) + outputImage(3:2:end,1:2:end-2,1) + outputImage(3:2:end, 3:2:end,1))/4;
    outputImage(1:2:end, 2:2:end-1,1) = (outputImage(1:2:end,1:2:end-2,1) + outputImage(1:2:end,3:2:end,1))/2;
    outputImage(2:2:end-1, 1:2:end,1) = (outputImage(1:2:end-2,1:2:end,1) + outputImage(3:2:end, 1:2:end,1))/2;
    if mod(height,2) == 0
        outputImage(end,1:2:end,1) = outputImage(end-1,1:2:end,1);
        outputImage(end,2:2:end-1,1) = (outputImage(end-1,1:2:end-2,1) + outputImage(end-1,3:2:end,1))/2;
    end
    if mod(width,2) == 0
        outputImage(1:2:end,end,1) = outputImage(1:2:end,end-1,1);
        outputImage(2:2:end-1, end,1) = (outputImage(1:2:end-2,end-1,1) + outputImage(3:2:end,end-1,1))/2;
    end
    if mod(height,2) == 0 && mod(width,2) == 0
        outputImage(end,end,1) = outputImage(end-1,end-1,1);
    end

    % Green channel
    outputImage(2:2:end-1, 2:2:end-1,2) = (outputImage(1:2:end-2,2:2:end-2,2) + outputImage(2:2:end-2, 1:2:end-2, 2) + outputImage(2:2:end-2, 3:2:end,2) + outputImage(3:2:end, 2:2:end-2, 2) )/4;
    outputImage(3:2:end-1, 3:2:end-1,2) = (outputImage(2:2:end-2,3:2:end-1,2) + outputImage(3:2:end-1, 2:2:end-2, 2) + outputImage(3:2:end-1, 4:2:end,2) + outputImage(4:2:end, 3:2:end-1, 2) )/4;
    outputImage(1, 1:2:end, 2) = (outputImage(1, 2:2:end, 2) + outputImage(2, 1:2:end, 2))/2;
    outputImage(3:2:end-1, 1, 2) = (outputImage(2:2:end-2, 1, 2) + outputImage(4:2:end, 1, 2) + outputImage(3:2:end-1, 2, 2))/3;
    if mod(width,2) == 0
        outputImage(2:2:end-1, end, 2) = (outputImage(1:2:end-2, end, 2) + outputImage(3:2:end, end, 2) + outputImage(2:2:end-1, end-1, 2))/3;
    end
    if mod(height,2) == 0
        outputImage(end, 2:2:end-1, 2) = (outputImage(end, 1:2:end-2, 2) + outputImage(end, 3:2:end, 2) + outputImage(end-1, 2:2:end-1, 2))/3;
    end
    
    % Blue channel
    outputImage(3:2:end-1,3:2:end-1,3) = (outputImage(2:2:end-2,2:2:end-2,3) + outputImage(2:2:end-2,4:2:end,3) + outputImage(4:2:end, 2:2:end-2,3) + outputImage(4:2:end, 4:2:end,3))/4;
    outputImage(3:2:end-1, 2:2:end,3) = (outputImage(2:2:end-1,2:2:end,3) + outputImage(4:2:end,2:2:end,3))/2;
    outputImage(2:2:end, 3:2:end-1,3) = (outputImage(2:2:end,2:2:end-1,3) + outputImage(2:2:end,4:2:end,3))/2; 
    outputImage(1,1,3) = outputImage(2,2,3);
    outputImage(1, 2:2:end,3) = outputImage(2,2:2:end,3);
    outputImage(2:2:end,1,3) = outputImage(2:2:end,2,3);
    outputImage(3:2:end-1,1,3) = (outputImage(2:2:end-2,2,3) + outputImage(4:2:end,2,3))/2;
    outputImage(1,3:2:end-1,3) = (outputImage(1,2:2:end-2,3) + outputImage(1,4:2:end,3))/2;

    if mod(height,2) == 1
        outputImage(end,1,3) = outputImage(end-1,2,3);
    end
    if mod(width,2) == 1
        outputImage(1,end,3) = outputImage(2,end-1,3);
    end
    if mod(height,2) == 1 && mod(width,2) == 1
        outputImage(end,end,3) = outputImage(end-1,end-1,3);
    end
end

function [outputImage] = whiteBalancingWhiteWorld(inputImage)

    % Initialize the output image
    outputImage = inputImage;

    % Compute per-channel maximum
    maxR = max(max(inputImage(:,:,1)));
    maxG = max(max(inputImage(:,:,2)));
    maxB = max(max(inputImage(:,:,3)));

    % Normalize each channel by its maximum
    outputImage(:,:,1) = outputImage(:,:,1) / maxR;
    outputImage(:,:,2) = outputImage(:,:,2) / maxG;
    outputImage(:,:,3) = outputImage(:,:,3) / maxB;

    % Normalize by green channel maximum
    outputImage(:,:,1) = outputImage(:,:,1) * maxG;
    outputImage(:,:,2) = outputImage(:,:,2) * maxG;
    outputImage(:,:,3) = outputImage(:,:,3) * maxG;
    
    
   
end

function [outputImage] = whiteBalancingGrayWorld(inputImage)

    % Initialize the output image
    outputImage = inputImage;

    % Compute per-channel average
    avgR = mean(mean(inputImage(:,:,1)));
    avgG = mean(mean(inputImage(:,:,2)));
    avgB = mean(mean(inputImage(:,:,3)));

    % Normalize each channel by its average
    outputImage(:,:,1) = outputImage(:,:,1) / avgR;
    outputImage(:,:,2) = outputImage(:,:,2) / avgG;
    outputImage(:,:,3) = outputImage(:,:,3) / avgB;

    % Normalize by green channel average
    outputImage(:,:,1) = outputImage(:,:,1) * avgG;
    outputImage(:,:,3) = outputImage(:,:,3) * avgG;
    outputImage(:,:,2) = outputImage(:,:,2) * avgG;
    
   
end

function [output] = whiteBalancedManualBalancing(inputImage)
    output = inputImage;

    imshow(inputImage);
    % Get a pixel coordinate by mouse click
    [x, y] = ginput(1);

    % Round the coordinates as pixel indices must be integers
    x = round(x);
    y = round(y);

    % Get the RGB values of the selected pixel
    pixelValue = inputImage(y, x, :);

    % Deduce the weight of each channel 
    weightR = 1 / pixelValue(1);
    weightG = 1 / pixelValue(2);
    weightB = 1 / pixelValue(3);

    % If the object is recoded as rw, gw, bw use weights for each channel such that kr = k/rw, kg = k/gw, kb = k/bw where k controls the exposure
    % Normalize each channel by its weight
    output(:,:,1) = output(:,:,1) * weightR;
    output(:,:,2) = output(:,:,2) * weightG;
    output(:,:,3) = output(:,:,3) * weightB;

end

function [output] = mean_filtering(input)
    % Define the mean filter
    mean_filter = ones(3, 3) / 9;
    
    % Get the number of color channels in the input image
    [~, ~, num_channels] = size(input);
    
    % Initialize the output image
    output = zeros(size(input));
    
    % Apply the mean filter to each color channel separately
    for i = 1:num_channels
        output(:,:,i) = conv2(input(:,:,i), mean_filter, 'same');
    end
end

function [output] = median_filtering(input)
    % Get the size of the input image
    [height, width] = size(input);
    
    % Initialize the output image
    output = input;
    
    % Apply the median filter
    for i = 1:height
        for j = 1:width
            % Index of the neighborhood of the pixel inside the image
            i1 = max(i-1, 1);
            i2 = min(i+1, height);
            j1 = max(j-1, 1);
            j2 = min(j+1, width);

            % Compute the mean of the neighborhood
            output(i, j) = median(median(input(i1:i2, j1:j2)));
        end
    end
end

function kernel = gaussian_kernel(size, sigma)
    % Generate a 2D Gaussian kernel
    [x, y] = meshgrid(1:size, 1:size);
    x = x - floor(size / 2) - 1;
    y = y - floor(size / 2) - 1;
    kernel = (1/(2*pi*sigma^2)) * exp(-((x.^2 + y.^2)/(2*sigma^2)));
    kernel = kernel / sum(kernel(:));
end

function [output] = gaussian_filtering(input, kernel_size, sigma)
    % Get the size of the input image
    [height, width, num_channels] = size(input);
    
    % Initialize the output image
    output = zeros(height, width, num_channels);

    % Apply Gaussian filter to an RGB image
    % Generate 2D Gaussian kernel
    kernel = gaussian_kernel(kernel_size, sigma);
    
    for i = 1:num_channels  % Loop over RGB channels
        output(:,:,i) = conv2(input(:,:,i), kernel, 'same');
    end
    
    % output = uint8(output);
end

function [output] = colorBalance(input)
    % Convert to HSV
    hsv = rgb2hsv(input);

    % Boost the saturation
    hsv(:,:,2) = hsv(:,:,2) * 1.2;

    % Convert back to RGB
    output = hsv2rgb(hsv);
end

function [output] = gammaCorrection(input, gamma)
    % Apply gamma correction
    idx_leq = input <= 0.0031308;
    idx_gt = input > 0.0031308;
    output = input;
    output(idx_leq) = 12.92 * input(idx_leq);
    output(idx_gt) = 1.055 * input(idx_gt).^(1/gamma) - 0.055;
end