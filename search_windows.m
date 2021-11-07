function [subimages, window_lim_list] = search_windows(A,colour_mask,colour_flag)
%% search_windows Function Description

%This functions applies a binary mask to an image and counts the resulting
%regions. It also outputs a rectangular region of interest around the
%centroid of each blob

%Inputs:
% - A - image to process
% - colour_mask - binary mask to apply (yellow or blue)
% - colour_flag - identifies the colour associated with the mask

%Outputs:
% - subimages - cell array of cropped regions of interest around each
%               detected region


% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%
%Defining search window sizes
width = 80;
height = 120;

%Image dimensions
imwidth = size(A,2);
imheight = size(A,1);


%Calculate centroids
blob_centroids = regionprops(colour_mask,'centroid');
blob_centroids = round(cat(1,blob_centroids.Centroid));
Num_blobs = size(blob_centroids,1);
clc
fprintf("The number of ")
fprintf(colour_flag)
fprintf(" cones found in the image was %i . Press any key to continue.\n"...
        ,Num_blobs)
pause;
clc

%Defining crop region
window_lim_list = cell(1,Num_blobs);
if Num_blobs ~=0
    for i = 1:Num_blobs
        window_lim = [blob_centroids(i,1)-width/2 blob_centroids(i,2)-height/2 width height];
        %Accounting for image edges
        %Left limit outside left border
        if window_lim(1) <1
            delta = 1- window_lim(1);
            window_lim(1) = 1;
            window_lim(3) = window_lim(3) - delta;
            %Right limit outside right border
        elseif window_lim(1) + window_lim(3) > imwidth
            delta = window_lim(1) + window_lim(3) - imwidth;
            window_lim(3) = window_lim(3) - delta;
        end
        %Upper limit outside upper border
        if window_lim(2) < 1
            delta = 1 - window_lim(2);
            window_lim(2) = 1;
            window_lim(4) = window_lim(4) - delta;
            %Lower limit outside lower border
        elseif window_lim(2) + window_lim(4) > imheight
            delta = window_lim(2) + window_lim(4) - imheight;
            window_lim(4) = window_lim(4) - delta;
        end
        window_lim_list{i} = window_lim;
        subimages{i} = imcrop(A,window_lim);
    end
else
    clc
    fprintf("\nCropped ")
    fprintf(colour_flag)
    fprintf(" cones not found. Going back...\n")
    pause(1);
    clc
    subimages = {};
    window_lim_list ={};
end