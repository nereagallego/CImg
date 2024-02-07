% lab 1 CImg assignment
% Authors: César Borja and Nerea Gallego

% 2) Importing your image

% 2.1) Reading the image into Matlab

% Load the image in TIFF format into Matlab
filename = '';
image = imread(filename);

% Check and report how many bits per pixel the image has.
infor = imfinfo(filename);
bitsPerPixel = info.BitDepth / info.ColorType;
fprintf('The image has %d bits per pixel\n', bitsPerPixel)

% Check its width and its height.
width = info.Width;
height = info.Height;
fprintf('The image is %d pixels wide and %d pixels high.\n', width, height);

