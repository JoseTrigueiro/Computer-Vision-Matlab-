function [colour_mask] = colour_part(A,HSV_colour, filtering_flag, decomposition_flag)
%% colour_mask Function Description

%This function converts an RGB image to HSV and thresholds it on the
%three channels at the same time. It also may, depending on input, plot the
%HSV channels separately or further filter the image by mathematical
%morphology. It also uses region analysis to find blobs belonging to the
%same cone and removes the smallest one

%Inputs:
% - A - image to process
% - HSV_colour - colour to detect (yellow or blue)
% - filtering_flag - if true activates mathematical morphology filtering
% - decomposition_flag - if true activates showing of HSV channels

%Outputs:
% - colour_mask - binary image (mask) identifying the detected coloured
%   blobs corresponding to cones

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%
%Color Interval HSV_colour = [Av As Ah- Ah+]
Vmin = HSV_colour(1);
Vmax = HSV_colour(2);
Smin = HSV_colour(3);
Hmin = HSV_colour(4);
Hmax = HSV_colour(5);

%RGB to HSV
Ahsv = rgb2hsv(A);
Ah = Ahsv(:,:,1);
As = Ahsv(:,:,2);
Av = Ahsv(:,:,3);


%Plotting HSV components
if decomposition_flag == false
    clc
    fprintf("Showing HSV decomposition. Press any key to continue.\n")
    figure
    subplot(2,2,1)
    imshow(A)
    title("Original Image")
    subplot(2,2,2)
    imshow(Ah)
    title("Hue")
    subplot(2,2,3)
    imshow(Av)
    title("Value")
    subplot(2,2,4)
    imshow(As)
    title("Saturation")
    pause;
    close all
end
%Defining spots of given colour
colour_mask = (((Av>Vmin & As>Smin) & Ah > Hmin) & Ah < Hmax) & Av<Vmax;

if filtering_flag == true
    %Filtering noise
    se = strel('square',3);
    colour_mask = imopen(colour_mask,se); %open
    colour_mask = imclose(colour_mask,se); %close
end

%Labeling blobs and property calculations
[Labels,Num_Labels]=bwlabel(colour_mask,8);

if Num_Labels ~= 0 %Check if labels were found
    %Centroid
    blob_centroids = regionprops(colour_mask,'centroid');
    blob_centroids = round(cat(1,blob_centroids.Centroid));
    %Area
    blob_areas = regionprops(colour_mask,'area');
    blob_areas = round(cat(1,blob_areas.Area));
    
    min_dist = 50;
    % Eliminating blobs from the same cone (finding indexes under a certain
    % distance from each other) and eliminating the one with smallest area
    blobs2del = [];
    for i = 1:Num_Labels
        for j = 1:Num_Labels
            if pdist([blob_centroids(i,:);blob_centroids(j,:)])<min_dist ...
                    && blob_areas(i)<blob_areas(j)
                blobs2del = [blobs2del i];
            end
        end
    end
    blobs2del = unique(blobs2del);  %avoid repeated indexes
    
    %deleting unwanted blobs from mask
    for i = 1:length(blobs2del)
        colour_mask(Labels == blobs2del(i)) = 0;
        Labels(Labels == blobs2del(i)) = 0;
    end
    
    A_colour = maskout(A,colour_mask); %mask application
    
    %Displaying mask and labels
    clc
    fprintf("Displaying object labels and binary mask over image. ")
    fprintf("Press any key to continue.")
    figure
    subplot(1,2,1)
    imagesc(Labels)
    title("Labeled Objects")
    subplot(1,2,2)
    imagesc(A_colour)
    title("Binary mask over image")
    pause;
    clc
    close all
end