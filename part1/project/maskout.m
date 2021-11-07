function masked = maskout(src,mask)
%% colour_mask Function Description

%This function applies a binary mask to an image, displaying only the image
%where the mask is 1, where the mask is 0 it turns black;

%Inputs:
% - mask - binary maskr, same size as the image, but does not have to be
% same data type (int vs logical)
% - src: rgb or gray image
% - filtering_flag - if true activates mathematical morphology filtering
% - decomposition_flag - if true activates showing of HSV channels

%Outputs:
% - colour_mask - binary image (mask) identifying the detected coloured
%   blobs corresponding to cones

% Adapted from: https://www.mathworks.com/matlabcentral/answers/38547-masking-out-image-area-using-binary-mask
% (consulted November 2020)

%%
    masked = bsxfun(@times, src, cast(mask,class(src)));

