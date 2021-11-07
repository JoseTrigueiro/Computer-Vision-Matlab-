function [new_rectangle] = hough_selection(subimages,rectangle)
%% hough_selection  Function Description

%This function calls another function that detects straight lines in an
%image, then takes the 2 longest lines and compares their angles and
%magnitudes to define if they are strong enough and form an acute angle.

%Inputs:
% - subimages - cell array with regions of interest around detected cones
% - rectangle - cell array with the coordinates that will be used to draw
%   rectangles around cones in cone_highlights.m
%Outputs:
% - new_rectangle - cell array with coordinates of rectangles around cones
%   that were validated by the Hough Transform

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%
j=1;
new_rectangle = {};

%Loop over all ROI's
for i=1:length(subimages)
    I = subimages{i};
    % 2 Highest Hough Peaks
    [lines] = hough_transform(I);
    % Long Lines (1st and 2nd conditions) that form not too large or small
    % acute angle (3rd) and have oposite slopes (4th)
    if length(lines)>=2 
        if (lines(1).rho > 25 && lines(1).rho >25) && abs(lines(1).theta-lines(2).theta)<60 && abs(lines(1).theta-lines(2).theta)>5 && (lines(1).theta*lines(2).theta<0)
        new_rectangle{j} = rectangle{i};
        j=j+1;
        end
    end
    
end


