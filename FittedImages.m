    %  _____________________________________________________ 
% |                                                     |
% |              OPTOMECHATRONIKA  PROJEKT              |
% |    Duplamikroszkóp képeinek egymásra kalibrálása    |
% |_____________________________________________________|

close all
clc();
clear();

% Figure to loop through the image pairs
figure();

% Load the homography matrix
load("Data/Transform.mat");
% load("Data/Transform2.mat");
fitImGIF = "fittedImages.gif";
difImGIF = "differenceImages.gif";
gdifImGIF = "grayDifferenceImages.gif";


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
        %imshow(fittedImg);

        % Convert grayscale image to RGB
        grayImageRGB = cat(3, currentGrayImage, currentGrayImage, currentGrayImage);
        
        % Compute difference image
        diffImg = abs(grayImageRGB - fittedImg);
        
        % Display difference image
        % figure;
        subplot(1,2,1);
        imshow(fittedImg);
        subplot(1,2,2);
        imshow(diffImg);

        % Convert the fitted image to indexed format
        [fit_im, fit_map] = rgb2ind(fittedImg, 256);
        [dif_im, dif_map] = rgb2ind(diffImg, 256);
        [gdif_im, gdif_map] = gray2ind(rgb2gray(diffImg), 256);

        % Write the indexed image to the GIF file
        if i == 1 && j == 1
            imwrite(fit_im, fit_map, fitImGIF, 'gif', 'LoopCount', Inf, 'DelayTime', 0.5);
            imwrite(dif_im, dif_map, difImGIF, 'gif', 'LoopCount', Inf, 'DelayTime', 0.5);
            imwrite(gdif_im, gdif_map, gdifImGIF, 'gif', 'LoopCount', Inf, 'DelayTime', 0.5);
        else
            imwrite(fit_im, fit_map, fitImGIF, 'gif', 'WriteMode', 'append', 'DelayTime', 0.5);
            imwrite(dif_im, dif_map, difImGIF, 'gif', 'WriteMode', 'append', 'DelayTime', 0.5);
            imwrite(gdif_im, gdif_map, gdifImGIF, 'gif', 'WriteMode', 'append', 'DelayTime', 0.5);
        end
        pause(0.25);
    end
end
