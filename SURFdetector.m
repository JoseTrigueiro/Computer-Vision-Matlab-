function SURFdetector()
%% optical_flow Function Description

%This function gives an example of matching using SURF features of an
%example cone and a real image.

%Inputs:
% - none
%Outputs:
% - none

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%

%Read images
coneImage = rgb2gray(imread('images\blue_cone1.png'));
Image = rgb2gray(imread('images\cone3.png'));

%Detect features in original image and cone
conePoints = detectSURFFeatures(coneImage);
imagePoints = detectSURFFeatures(Image);

%Extracting features from image and cone
[coneFeatures, conePoints] = extractFeatures(coneImage, conePoints);
[imageFeatures, imagePoints] = extractFeatures(Image, imagePoints);
conePairs = matchFeatures(coneFeatures, imageFeatures,"MatchThreshold",100,"MaxRatio",1);

%Match the images
matchedConePoints = conePoints(conePairs(:, 1), :);
matchedImagePoints = imagePoints(conePairs(:, 2), :);

clc
fprintf("Showing matched features. Press any key to continue.")
figure;
showMatchedFeatures(coneImage, Image, matchedConePoints, ...
    matchedImagePoints, 'montage');
title('Matched Points (Including Outliers)');
pause;
clc
close all
