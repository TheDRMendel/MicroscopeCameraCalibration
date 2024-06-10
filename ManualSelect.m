%  _____________________________________________________ 
% |                                                     |
% |              OPTOMECHATRONIKA  PROJEKT              |
% |    Duplamikroszkóp képeinek egymásra kalibrálása    |
% |_____________________________________________________|

close all;
clear();
clc();

% Read the images
rgbImage = imread('Images/Pontok/SZ/pontok_1sz.png');
grayImage = imread('Images/Pontok/FF/pontok_1ff.png');
% rgbImage = imread('Images/Duplategla/SZ/duplategla_2sz.png');
% grayImage = imread('Images/Duplategla/FF/duplategla_2ff.png');

% [pts1, pts2] = cpselect(rgbImage, grayImage, 'Wait', true);
% save('Data/ManualData.mat', "pts1", "pts2");
% save('Data/ManualData2.mat', "pts1", "pts2");
load('Data/ManualData.mat'); % 50 point pair

% Assuming you have already selected and stored the control points in pts1 and pts2
tform = fitgeotform2d(pts1, pts2, 'affine');
% save('Data/Transform.mat', "tform");
% save('Data/Transform2.mat', "tform");

% Transform the RGB image
transformedRgbImage = imwarp(rgbImage, tform, 'OutputView', imref2d(size(grayImage)));

% Create a mask for the black regions in the transformed RGB image
blackMask = transformedRgbImage(:,:,1) == 0 & transformedRgbImage(:,:,2) == 0 & transformedRgbImage(:,:,3) == 0;

% Invert the black mask
inverseMask = ~blackMask;

% Create the combined image by overlaying the transformed RGB image onto the gray image
combinedImage = grayImage;
combinedImage(inverseMask) = 0; %transformedRgbImage(inverseMask);

rgbCombImage = cat(3, combinedImage, combinedImage, combinedImage);
twoImage = rgbCombImage + transformedRgbImage;

figure;
% subplot(2,3,1);
% imshow(rgbCombImage);
% subplot(2,3,3);
% imshow(transformedRgbImage);
% subplot(2,3,5);
imshow(twoImage);
disp(tform.T);
itform = invert(tform);
disp(itform.T);

% Convert grayscale image to RGB
grayImageRGB = cat(3, grayImage, grayImage, grayImage);

% Compute difference image
diffImg = abs(grayImageRGB - twoImage);
diffImg = rgb2gray(diffImg);
diffImg = diffImg > 10;

% Display difference image
figure;
imshow(diffImg);
