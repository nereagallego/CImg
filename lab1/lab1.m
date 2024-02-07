% lab 1 CImg assignment
% Authors: César Borja and Nerea Gallego

% 2) Importing your image

% 2.1) Reading the image into Matlab

% Load the image in TIFF format into Matlab
filename = 'images_tiff/bottles.tiff';
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


% 3) Demosaicing (bggr)

% BGGR pattern
% 3.1) Demosaicing with nearest neighbor
demosaicNN = demosaicNearestNeighbor(image);

% 3.2) Demosaicing with bilinear interpolation
demosaicBI = demosaicingBilinearInterpolation(image);

function [outputImage] = demosaicNearestNeighbor(inputImage)
    % Get the size of the input image
    [height, width] = size(inputImage);
    
    % Initialize the output image
    outputImage = zeros(height, width, 3);
    
    % Blue channel
    outputImage(1:2:end, 1:2:end, 3) = inputImage(1:2:end, 1:2:end);
    
    % Green channel
    outputImage(1:2:end, 2:2:end, 2) = inputImage(1:2:end, 2:2:end);
    outputImage(2:2:end, 1:2:end, 2) = inputImage(2:2:end, 1:2:end);
    
    % Red channel
    outputImage(2:2:end, 2:2:end, 1) = inputImage(2:2:end, 2:2:end);
    
    % Nearest neighbor interpolation

    % Blue channel
    outputImage(1:2:end, 2:2:end, 3) = outputImage(1:2:end, 1:2:end-1, 3);
    outputImage(2:2:end, 1:2:end, 3) = outputImage(1:2:end-1, 1:2:end, 3);
    outputImage(2:2:end, 2:2:end, 3) = outputImage(1:2:end-1, 1:2:end-1, 3);
    
    % Green channel
    outputImage(2:2:end, 2:2:end, 2) = outputImage(2:2:end, 1:2:end-1, 2);
    outputImage(1:2:end, 1:2:end, 2) = outputImage(1:2:end, 2:2:end, 2);
    
    % Red channel
    outputImage(2:2:end, 1:2:end, 1) = outputImage(2:2:end, 2:2:end, 1);
    outputImage(1:2:end, 2:2:end, 1) = outputImage(2:2:end, 2:2:end, 1);
    outputImage(1:2:end, 1:2:end, 1) = outputImage(2:2:end, 2:2:end, 1);
end

function [outputImage] = demosaicingBilinearInterpolation(inputImage)
    % Get the size of the input image
    [height, width] = size(inputImage);
    
    % Initialize the output image
    outputImage = zeros(height, width, 3);
    
    % Blue channel
    outputImage(1:2:end, 1:2:end, 3) = inputImage(1:2:end, 1:2:end);
    
    % Green channel
    outputImage(1:2:end, 2:2:end, 2) = inputImage(1:2:end, 2:2:end);
    outputImage(2:2:end, 1:2:end, 2) = inputImage(2:2:end, 1:2:end);
    
    % Red channel
    outputImage(2:2:end, 2:2:end, 1) = inputImage(2:2:end, 2:2:end);
    
    % Bilinear interpolation

    % Blue channel
    outputImage(1:2:end, 2:2:end-2, 3) = (outputImage(1:2:end, 1:2:end-2, 3) + outputImage(1:2:end, 3:2:end, 3))/2 ; % Horizontal
    if mod(width,2) == 0
        outputImage(1:2:end, end, 3) = outputImage(1:2:end, end-1,3);
    end
    outputImage(2:2:end-1, 1:2:end, 3) = (outputImage(1:2:end-2, 1:2:end, 3) + outputImage(3:2:end, 1:2:end, 3)) / 2; % Vertical
    if mod(height,2) == 0
        outputImage(end, 1:2:end, 3) = outputImage(end-1, 1:2:end, 3);
    end
    outputImage(2:2:end-1, 2:2:end-1, 3) = (outputImage(1:2:end-2, 1:2:end-2, 3) + outputImage(1:2:end-2, 3:2:end,3) + outputImage(3:2:end, 1:2:end-2, 3)+ outputImage(3:2:end, 3:2:end, 3))/4; % Diagonal
    
    % Green channel
    outputImage(2:2:end, 2:2:end, 2) = outputImage(2:2:end, 1:2:end-1, 2);
    outputImage(1:2:end, 1:2:end, 2) = outputImage(1:2:end, 2:2:end, 2);
    
    % Red channel
    outputImage(2:2:end, 1:2:end, 1) = outputImage(2:2:end, 2:2:end, 1);
    outputImage(1:2:end, 2:2:end, 1) = outputImage(2:2:end, 2:2:end, 1);
    outputImage(1:2:end, 1:2:end, 1) = outputImage(2:2:end, 2:2:end, 1);
end


