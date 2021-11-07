function [lines] = hough_transform(I)
%% hough_transform  Function Description

%This function generates the Hough Transform of the Saturation component

%Inputs:
% - I - image to process using the Hough transform (cone ROI)
%Outputs:
% - lines - 2 highest peaks in the hough transform space, correspondent to
%   2 strongest lines in the -35 to 35 degree region

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 MATLAB 2020B

%%

clc
fprintf("Peaks of Hough transform are being shown. Press any key to continue.")
%HSV
Ihsv = rgb2hsv(I);
Is = Ihsv(:,:,2);



%Edge detection
BW = edge(Is, 'canny',0.2,5);
figure
subplot(1,2,1)
imshow(BW)

%Hough Transform and peaks
[H,T,R] = hough(BW,'Theta',-35:3:35,"RhoResolution",2);
P  = houghpeaks(H,2,'Theta',-35:3:35,'threshold',ceil(0.3*max(H(:))),'NHoodSize',[55 15]);

%Finding two strongest lines
lines = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);

%Plotting lines over image
subplot(1,2,2), imshow(I), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

pause;
close all
clc