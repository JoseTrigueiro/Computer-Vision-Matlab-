function [] = cone_highlights(rectangles_blue,rectangles_yellow,A)
%% cone_highlights Function Description

%This shows the original image with coloured rectangles indicating the
%detected blue and yellow cones.

%Inputs:
% - A - original image
% - rectangles_blue - coordinates of the rectangles of the ROI of each blue
%                     cone detected
% - rectangles_blue - coordinates of the rectangles of the ROI of each
%                     yellow cone detected

%Outputs:
% - none

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%
figure
imshow(A)
hold on
if isempty(rectangles_blue) & isempty(rectangles_yellow)
    fprintf("\nNo cones were found. Going back...\n")
    wait(1)
else
    if ~isempty(rectangles_blue) %Check for blue ROIs and plot
        for i =1:length(rectangles_blue)
            rectangle('Position', rectangles_blue{i},'Curvature',0.1,...
                      'EdgeColor','blue','LineWidth',2)
        end
    end
    if ~isempty(rectangles_yellow) %Check for yellow ROIs and plot
        for i =1:length(rectangles_yellow)
            rectangle('Position', rectangles_yellow{i},'Curvature',0.1,...
                      'EdgeColor','yellow','LineWidth',2)
        end
    end
end
clc
fprintf("Showing identified cones. Press any key to continue.")
pause;
close all
clc
