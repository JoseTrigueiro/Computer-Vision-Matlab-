function [groundTruthPoses] = CreateTable(dist,Nimages)
%% 
% This function generates ground truth data by knowing the constant
% distance between consecutive views in the sequence

% Inputs:
% - dist - vector with x, y and z components of the distance between
% consecutive views in the sequence
% - Nimages - number of images in the sequence

% Outputs:
% - groundTruthPoses - table with orientation and location of each camera
% view

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B

%%
Orientation = cell(Nimages,1);
Location = cell(Nimages,1);
ViewId(1:Nimages,1) = 1:Nimages;
%Loop over all views, orientation is always in the positive z direction,
%location increases by dist each iteration
for i = 1:Nimages
    Orientation{i,1} = [1,0,0;0,1,0;0,0,1];
    Location{i,1} = [dist(1,1)*(i-1),dist(1,2)*(i-1),dist(1,3)*(i-1)];
end

% Format as table
groundTruthPoses = table(ViewId, Location, Orientation);


