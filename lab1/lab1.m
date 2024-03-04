% lab 1 CImg assignment
% Authors: César Borja and Nerea Gallego

close all;

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
figure; imshow(image);

% 3) Demosaicing (rggb)

% RGGB pattern
% 3.1) Demosaicing with nearest neighbor
demosaicNN = demosaicNearestNeighbor(image);

% 3.2) Demosaicing with bilinear interpolation
demosaicBI = demosaicingBilinearInterpolation(image);
figure(1); imshow(demosaicBI);

% 4) White balancing
% 4.1) White balancing using the white world assumption
% whiteBalanced = whiteBalancingWhiteWorld(demosaicBI);
% whiteBalanced = whiteBalancingGrayWorld(demosaicBI);
whiteBalanced = whiteBalancedManualBalancing(demosaicBI);
figure(2); imshow(whiteBalanced);

% 5) Denoising
% 5.1) Mean filtering
% meanFiltered = mean_filtering(whiteBalanced);
% figure; imshow(meanFiltered);


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
    % Get the size of the input image
    [height, width] = size(input);
    
    % Initialize the output image
    output = input;
    
    % Apply the mean filter
    for i = 1:height
        for j = 1:width
            % Index of the neighborhood of the pixel inside the image
            i1 = max(i-1, 1);
            i2 = min(i+1, height);
            j1 = max(j-1, 1);
            j2 = min(j+1, width);

            % Compute the mean of the neighborhood
            output(i, j) = mean(mean(input(i1:i2, j1:j2)));
        end
    end

end

function [output] = median_filtering(input)
    % Get the size of the input image
    [height, width] = size(input);
    
    % Initialize the output image
    output = zeros(height, width);
    
    % Apply the median filter
    for i = 2:height-1
        for j = 2:width-1
            output(i, j) = median(median(input(i-1:i+1, j-1:j+1)));
        end
    end
end

function [output] = gaussian_filtering(input)
    % Get the size of the input image
    [height, width] = size(input);
    
    % Initialize the output image
    output = zeros(height, width);

    
end