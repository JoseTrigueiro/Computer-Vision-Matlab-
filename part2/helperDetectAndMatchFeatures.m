%% Example function taken from MATLAB, with modifications

%% Modification for the application

% This function was modified to take two extra inputs:
% - numPoints - the number of SURF points to extract from the image
% - threshold - metric threshold for SURF feature detection

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B

%%
% helperDetectAndMatchFeatures Detect, extract, and match features 
%   [currPoints, currFeautres, indexPairs] = helperDetectAndMatchFeatures(
%   prevFeatures, I) detects and extract features from image I and matches
%   them to prevFeatures. prevFeatures is an M-by-N matrix fof SURF
%   descriptors. I is a grayscale image. currPoints are the SURF points
%   detected in image I, and currFeatures are the corresponding SURF
%   descriptors. indexPairs is an M-by-2 matrix containing the indices of
%   matches between prevFeatures and currFeatures.
%
%   See also detectSURFFeatures, selectUniform, extractFeatures,
%   matchFeatures

% Copyright 2016 The MathWorks, Inc. 




function [currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
    prevFeatures, I, numPoints, threshold)

%numPoints = 150;

% Detect and extract features from the current image.
currPoints   = detectSURFFeatures(I, 'MetricThreshold', threshold);
currPoints   = selectUniform(currPoints, numPoints, size(I));
currFeatures = extractFeatures(I, currPoints, 'Upright', true);

% Match features between the previous and current image.
indexPairs = matchFeatures(prevFeatures, currFeatures, 'Unique', true);