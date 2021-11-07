function [] = optical_flow()
%% optical_flow Function Description

%This function calculates the optical flow of a given video of a lap around
%a Formula Student Racetrack, stored in folder images, using an
%approximation method:
% - Horn-Schunk
% - Farneback
% - Lucas-Kanade
% - Lucas-Kanade DoG
%Inputs:
% - none
%Outputs:
% - none

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%
%Loading video
imagename = ['images\' 'video.mp4'];
clc
vidReader = VideoReader(imagename);
choice_flag = true;

%Choose the approximation
while choice_flag == true
    clc
    fprintf("\nChoose an approximation method: \n\n")
    fprintf("A - Horn-Schunck (best results)\n")
    fprintf("B - Farneback\n")
    fprintf("C - Lucas-Kanade\n")
    fprintf("D - Lucas-Kanade DoG\n\n")
    aprox_choice = input("Select an option: ","s");
    switch aprox_choice
        case {"A","a"}
            opticFlow = opticalFlowHS;
            choice_flag = false;
            clc
        case {"B","b"}
            opticFlow = opticalFlowFarneback;
            choice_flag = false;
            clc
        case {"C","c"}
            opticFlow = opticalFlowLK;
            choice_flag = false;
            clc
        case{"D",""}
            opticFlow = opticalFlowLKDoG;
            choice_flag = false;
            clc
        otherwise
            clc
            fprintf("Please choose a valid option.")
            pause(1);
            clc
    end
end

fprintf("Showing optical flow in video. After finishing press any key to continue")

%Play video while estimating optical flow
h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);
while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    frameGray = rgb2gray(frameRGB);  
    flow = estimateFlow(opticFlow,frameGray);
    imshow(frameRGB)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',60,'Parent',hPlot);
    hold off
    pause(10^-3)
end
pause;
clc