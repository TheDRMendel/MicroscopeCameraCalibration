% _____________________________________________________ 
% |                                                     |
% |              OPTOMECHATRONIKA  PROJEKT              |
% |    Duplamikroszkóp képeinek egymásra kalibrálása    |
% |_____________________________________________________|

close all
clc();
clear();

% Load the homography matrix
load("Data/Transform.mat");
% load("Data/Transform2.mat");

% Define the folders to save the images
fittedImagesFolder = "FittedImages";
differenceImagesFolder = "DifferenceImages";
grayDifferenceImagesFolder = "GrayDifferenceImages";

% Create the folders if they don't exist
if ~exist(fittedImagesFolder, 'dir')
    mkdir(fittedImagesFolder);
end
if ~exist(differenceImagesFolder, 'dir')
    mkdir(differenceImagesFolder);
end
if ~exist(grayDifferenceImagesFolder, 'dir')
    mkdir(grayDifferenceImagesFolder);
end

% Filtering Images folder
imagesFolder = "Images";
shapeFolders = dir(imagesFolder);
shapeFolders = shapeFolders([shapeFolders.isdir]);
shapeFolders = shapeFolders(~ismember({shapeFolders.name}, {'.', '..'}));

% Loop through each shape folder
for i = 1:length(shapeFolders)
    currentShapeFolder = fullfile(imagesFolder, shapeFolders(i).name);
    colorRepresentations = dir(currentShapeFolder);
    colorRepresentations = colorRepresentations([colorRepresentations.isdir]);
    colorRepresentations = colorRepresentations(~ismember({colorRepresentations.name}, {'.', '..'}));

    grayImageFiles = dir(fullfile(currentShapeFolder, colorRepresentations(1).name, '*.png'));
    rgbImageFiles = dir(fullfile(currentShapeFolder, colorRepresentations(2).name, '*.png'));
    grayNum = numel(grayImageFiles);
    rgbNum = numel(rgbImageFiles);
    
    loopLength = min(grayNum, rgbNum);

    % Loop through image pairs
    for j = 1:loopLength
        % Reading image pairs
        currentGrayImage = imread(fullfile(currentShapeFolder, colorRepresentations(1).name, grayImageFiles(j).name));
        currentRGBImage = imread(fullfile(currentShapeFolder, colorRepresentations(2).name, rgbImageFiles(j).name));

        % Checking if RGB image is really in RGB representation
        if ~(ndims(currentRGBImage) == 3)
            tmpImage = currentGrayImage;
            currentGrayImage = currentRGBImage;
            currentRGBImage = tmpImage;
            clear("tmpImage");
        end
        
        % Transform RGB image
        transformedRgbImage = imwarp(currentRGBImage, tform, 'OutputView', imref2d(size(currentGrayImage)));

        % Create a mask for the black regions in the transformed RGB image
        blackMask = transformedRgbImage(:,:,1) == 0 & transformedRgbImage(:,:,2) == 0 & transformedRgbImage(:,:,3) == 0;
        
        % Invert the black mask
        inverseMask = ~blackMask;
        
        % Create the combined image by overlaying the transformed RGB image onto the gray image
        combinedImage = currentGrayImage;
        combinedImage(inverseMask) = 0; % transformedRgbImage(inverseMask);
        
        rgbCombImage = cat(3, combinedImage, combinedImage, combinedImage);
        fittedImg = rgbCombImage + transformedRgbImage;

        % Convert grayscale image to RGB
        grayImageRGB = cat(3, currentGrayImage, currentGrayImage, currentGrayImage);
        
        % Compute difference image
        diffImg = abs(grayImageRGB - fittedImg);
        newdiffImg = rgb2gray(diffImg);
        mask = newdiffImg > 10;
        newdiffImg(mask) = 255;
        
        % Display difference image
        subplot(1,2,1);
        imshow(fittedImg);
        subplot(1,2,2);
        imshow(newdiffImg);

        % Save the images in the specified folders
        fittedImgFilename = fullfile(fittedImagesFolder, sprintf('fittedImage_%s_%d.png', shapeFolders(i).name, j));
        diffImgFilename = fullfile(differenceImagesFolder, sprintf('differenceImage_%s_%d.png', shapeFolders(i).name, j));
        grayDiffImgFilename = fullfile(grayDifferenceImagesFolder, sprintf('grayDifferenceImage_%s_%d.png', shapeFolders(i).name, j));
        
        imwrite(fittedImg, fittedImgFilename);
        imwrite(diffImg, diffImgFilename);
        imwrite(newdiffImg, grayDiffImgFilename);

        pause(0.25);
    end
end
