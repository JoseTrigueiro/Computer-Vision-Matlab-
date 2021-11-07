%% Computational Vision - Work number 1 - Problem 16 - Main Script
% This is the main program defining the algorithm for yellow and blue cones
% identification proposed in Problem 16.

% The following methods were implemented:
% - HSV colour space thresholding
% - Mathematical morphology (open/close)
% - Blob analysis
% - Hough transform - line recognition
% - K-means clustering segmentation
%
% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B


%%
clc
close all
clearvars

%% Load image

%Main menu
while true
    
    clc
    fprintf("\nWelcome to the Computer Vision - Problem 16 Program.\n")
    fprintf("Please choose an option\n\n")
    fprintf("Option A - Import a new image.\n")
    fprintf("Option B - HSV threshold based segmentation (Warning: Leads to bad results!).\n")
    fprintf("Option C - HSV threshold based segmentation and mathematical morphology post processing.\n")
    fprintf("Option D - HSV threshold based segmentation and Hough transform post processing.\n")
    fprintf("Option E - HSV threshold based segmentation and Hough transform + mathematical morphology.\n")
    fprintf("Option F - Optical flow calculation - separate video will be loaded.\n")
    fprintf("Option G - K means clustering method.\n")
    fprintf("Option H - SURF method example.\n")
    fprintf("Option I - Exit program.\n\n")
    
    choice = input("Option: ","s");
    switch choice
        case {"A","a"} %Load Image
            clc
            im_id = input("\n What image do you want to import?\n Choose a number between 1 and 4:","s");
            switch im_id
                case {"1","2","3","4"}
                    clc
                    imagename = ['images\' 'cone' im_id '.png'];
                    A = imread(imagename);
                    fprintf("\nImage Imported")
                otherwise
                    clc
                    fprintf("Invalid number. Please try a number between 1 and 4.")
            end
        case {"B","b"} % Threshold only
            if exist("A","var")
                clc
                %Threshold parameters
                %Color Interval defined as
                % HSV_colour = [Av- Av+ As- Ah- Ah+]
                HSV_blue = [0.1 0.6 0.58 0.52 0.72];
                HSV_yellow = [0.1 1 0.60 0.08 0.17];
                filtering_flag = false;
                decomposition_flag = false;
                
                %Calculation and plotting window over image
                [blue_mask] = colour_part(A,HSV_blue, filtering_flag, decomposition_flag);
                [subimages_blue,rectangles_blue] = search_windows(A,blue_mask,"blue");
                decomposition_flag = true;
                [yellow_mask] = colour_part(A,HSV_yellow, filtering_flag, decomposition_flag);
                [subimages_yellow,rectangles_yellow] = search_windows(A,yellow_mask,"yellow");
                cone_highlights(rectangles_blue,rectangles_yellow,A);
            else
                clc
                fprintf("Image not found. Please load a valid image.")
                pause(1)
                clc                
            end
        case {"C","c"} % Threshold + Math. Morphology
            if exist("A","var")
                clc
                %Threshold parameters
                %Color Interval defined as
                % HSV_colour = [Av- Av+ As- Ah- Ah+]
                HSV_blue = [0.1 0.6 0.58 0.52 0.72];
                HSV_yellow = [0.1 1 0.60 0.08 0.17];
                filtering_flag = true;
                decomposition_flag = false;
                
                %Calculation and plotting window over image
                [blue_mask] = colour_part(A,HSV_blue, filtering_flag, decomposition_flag);
                [subimages_blue,rectangles_blue] = search_windows(A,blue_mask,"blue");
                decomposition_flag = true;
                [yellow_mask] = colour_part(A,HSV_yellow, filtering_flag, decomposition_flag);
                [subimages_yellow,rectangles_yellow] = search_windows(A,yellow_mask,"yellow");
                cone_highlights(rectangles_blue,rectangles_yellow,A);
            else
                clc
                fprintf("Image not found. Please load a valid image.")
                pause(1)
                clc                
            end 
        case {"D","d"} % Threshold + Hough Transform
            if exist("A","var")
                clc
                %Threshold parameters
                %Color Interval defined as
                % HSV_colour = [Av- Av+ As- Ah- Ah+]
                HSV_blue = [0.1 0.6 0.58 0.52 0.72];
                HSV_yellow = [0.1 1 0.60 0.08 0.17];
                filtering_flag = false;
                decomposition_flag = false;
                
                %Calculation and plotting window over image
                [blue_mask] = colour_part(A,HSV_blue, filtering_flag, decomposition_flag);
                [subimages_blue,rectangles_blue] = search_windows(A,blue_mask,"blue");
                decomposition_flag = true;
                [yellow_mask] = colour_part(A,HSV_yellow, filtering_flag, decomposition_flag);
                [subimages_yellow,rectangles_yellow] = search_windows(A,yellow_mask,"yellow");
                [new_yellow] = hough_selection(subimages_yellow,rectangles_yellow);
                [new_blue] = hough_selection(subimages_blue,rectangles_blue);
                cone_highlights(new_blue,new_yellow,A);
            else
                clc
                fprintf("Image not found. Please load a valid image.")
                pause(1)
                clc
            end        
        case {"E","e"} % Threshold + Hough Transform + Math. Morphology
            if exist("A","var")
                clc
                %Threshold parameters
                %Color Interval defined as
                % HSV_colour = [Av- Av+ As- Ah- Ah+]
                HSV_blue = [0.1 0.6 0.58 0.52 0.72];
                HSV_yellow = [0.1 1 0.60 0.08 0.17];
                filtering_flag = true;
                decomposition_flag = false;
                
                %Calculation and plotting window over image
                [blue_mask] = colour_part(A,HSV_blue, filtering_flag, decomposition_flag);
                [subimages_blue,rectangles_blue] = search_windows(A,blue_mask,"blue");
                [yellow_mask] = colour_part(A,HSV_yellow, filtering_flag, decomposition_flag);
                [subimages_yellow,rectangles_yellow] = search_windows(A,yellow_mask,"yellow");
                [new_yellow] = hough_selection(subimages_yellow,rectangles_yellow);
                [new_blue] = hough_selection(subimages_blue,rectangles_blue);
                cone_highlights(new_blue,new_yellow,A);       
            else
                clc
                fprintf("Image not found. Please load a valid image.")
                pause(1)
                clc
            end         
        case {"F","f"} % Optical Flow
            clc
            fprintf("\nVideo loading...\n")
            optical_flow()
            clc
        case {"H","h"} % SURF
            clc
            SURFdetector()
            clc
        case {"I","i"}
            clc
            fprintf("Program closing...")
            pause(1)
            clc
            break
        otherwise
            clc
            fprintf("Invalid option inserted. Returning to menu...")
            pause(1)
            clc
    end
end
