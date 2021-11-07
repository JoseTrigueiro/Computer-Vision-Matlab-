function [ ] = VisualOdometryApplication(alg_parameters, axislims, dist, dataset)
%% Monocular Visual Odometry

% This program applies the Monocular Visual Odometry from the Matlab example
% to our datasets. The code is based on the example, but it was altered to
% generate the ground truth in a different way, to import camera intrinsics
% from our calibration and to display the errors. It was also made more
% general to fit variation in hyperparameters

% Intputs:
% - alg_parameters: struct with the algorithms hyperparameters
% - axislims: limits for the axis in the trajectory plot
% - dist: distance in x,y and z between consecutive views
% - dataset: the name of the dataset to load


% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B

%%
fprintf("Estimating the trajectory. Please wait...\n")

%% Hyperparameters

MAX_GLOBAL = alg_parameters.MAX_GLOBAL;
INTER_PARCIAL = alg_parameters.INTER_PARCIAL;
WINDOW_PARCIAL = alg_parameters.WINDOW_PARCIAL;
SURF_POINTS = alg_parameters.SURF_POINTS;
SURF_THRESHOLD = alg_parameters.SURF_THRESHOLD;

%% Read Input Image Sequence

% The dataset used is a sequence with kitchen objects with the camera
% moving in a straight line. 
%Load the image sequence
images = imageDatastore(dataset);
Nimages = length(images.Files); %number of captured images in the sequence


%% Create a View Set Containing the First View of the Sequence


% Create an empty imageviewset object to manage the data associated with each view.
vSet = imageviewset;


% Read and display the first image.
Irgb = readimage(images, 1);
player = vision.VideoPlayer;

%Auto scale video to fit window
set(0,'showHiddenHandles','on');
fig_handle = gcf ;  
fig_handle.findobj; % to view all the linked objects with the vision.VideoPlayer
ftw = fig_handle.findobj ('TooltipString', 'Maintain fit to window');   % this will search the object in the figure which has the respective 'TooltipString' parameter.
ftw.ClickedCallback();  % execute the callback linked with this object

step(player, Irgb);

% Load the intrinsics matrix from a previous calibration 
% (file calib_params.mat)
load("calib_params.mat", "cameraParams")
intrinsics = cameraParams.Intrinsics;

%Generate the ground truth assuming a straight line movement with distance
%dist between views and Nimages images. Ground truth data assumes a
% straight movement measured using a tape measure.
[groundTruthPoses] = CreateTable(dist,Nimages);


%% 
% Convert to gray scale and undistort.
prevI = undistortImage(rgb2gray(Irgb), intrinsics); 

% Detect features. 
prevPoints = detectSURFFeatures(prevI, 'MetricThreshold', SURF_THRESHOLD);

% Select a subset of features, uniformly distributed throughout the image.
numPoints = SURF_POINTS;
prevPoints = selectUniform(prevPoints, numPoints, size(prevI));

% Extract features. Using 'Upright' features improves matching quality if 
% the camera motion involves little or no in-plane rotation.
prevFeatures = extractFeatures(prevI, prevPoints, 'Upright', true);

% Add the first view. Place the camera associated with the first view
% at the origin, oriented along the Z-axis.
viewId = 1;
vSet = addView(vSet, viewId, rigid3d(eye(3), [0 0 0]), 'Points', prevPoints);


%% Plot Initial Camera Pose
% Create two graphical camera objects representing the estimated and the actual 
% camera poses based on ground truth data from the New Tsukuba dataset.

% Setup axes.
figure
axis(axislims);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
hold on

% Plot estimated camera pose. 
cameraSize = 7;
camPose = poses(vSet);
camEstimated = plotCamera(camPose, 'Size', cameraSize,...
    'Color', 'g', 'Opacity', 0);

% Plot actual camera pose.
camActual = plotCamera('Size', cameraSize, 'AbsolutePose', ...
    rigid3d(groundTruthPoses.Orientation{1}, groundTruthPoses.Location{1}), ...
    'Color', 'b', 'Opacity', 0);

% Initialize camera trajectories.
trajectoryEstimated = plot3(0, 0, 0, 'g-');
trajectoryActual    = plot3(0, 0, 0, 'b-');

legend('Estimated Trajectory', 'Actual Trajectory');
title('Camera Trajectory');
%% Estimate the Pose of the Second View

% Read and display the image.
viewId = 2;
Irgb = readimage(images, viewId);
step(player, Irgb);

% Convert to gray scale and undistort.
I = undistortImage(rgb2gray(Irgb), intrinsics);

% Match features between the previous and the current image.
[currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
    prevFeatures, I, numPoints, SURF_THRESHOLD);

% Estimate the pose of the current view relative to the previous view.
[orient, loc, inlierIdx] = helperEstimateRelativePose(...
    prevPoints(indexPairs(:,1)), currPoints(indexPairs(:,2)), intrinsics);

% Exclude epipolar outliers.
indexPairs = indexPairs(inlierIdx, :);
    
% Add the current view to the view set.
vSet = addView(vSet, viewId, rigid3d(orient, loc), 'Points', currPoints);

% Store the point matches between the previous and the current views.
vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);
%% 
% The location of the second view relative to the first view can only be recovered 
% up to an unknown scale factor. Compute the scale factor from the ground truth , simulating 
% an external sensor, which would be used in a typical monocular visual odometry 
% system.

vSet = helperNormalizeViewSet(vSet, groundTruthPoses);


%% 
% Update camera trajectory plots.

helperUpdateCameraPlots(viewId, camEstimated, camActual, poses(vSet), ...
    groundTruthPoses);
helperUpdateCameraTrajectories(viewId, trajectoryEstimated, trajectoryActual,...
    poses(vSet), groundTruthPoses);

prevI = I;
prevFeatures = currFeatures;
prevPoints   = currPoints;


%% Bootstrap Estimating Camera Trajectory Using Global Bundle Adjustment

for viewId = 3:MAX_GLOBAL
    % Read and display the next image
    Irgb = readimage(images, viewId);
    step(player, Irgb);
    
    % Convert to gray scale and undistort.
    I = undistortImage(rgb2gray(Irgb), intrinsics);
    
    % Match points between the previous and the current image.
    [currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
        prevFeatures, I, numPoints, SURF_THRESHOLD);
      
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(prevPoints(indexPairs(:,1)),...
        currPoints(indexPairs(:, 2)), intrinsics);
    indexPairs = indexPairs(inlierIdx, :);
    
    % Triangulate points from the previous two views, and find the 
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet,...
        intrinsics, indexPairs, currPoints);
    
    % Since RANSAC involves a stochastic process, it may sometimes not
    % reach the desired confidence level and exceed maximum number of
    % trials. Disable the warning when that happens since the outcomes are
    % still valid.
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    % Estimate the world camera pose for the current view.
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, intrinsics);
    
    % Restore the original warning state
    warning(warningstate)
    
    % Add the current view to the view set.
    vSet = addView(vSet, viewId, rigid3d(orient, loc), 'Points', currPoints);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);    
    
    tracks = findTracks(vSet); % Find point tracks spanning multiple views.
        
    camPoses = poses(vSet);    % Get camera poses for all views.
    
    % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, intrinsics);
    
    % Refine camera poses using bundle adjustment.
    [~, camPoses] = bundleAdjustment(xyzPoints, tracks, camPoses, ...
        intrinsics, 'PointsUndistorted', true, 'AbsoluteTolerance', 1e-12,...
        'RelativeTolerance', 1e-12, 'MaxIterations', 200, 'FixedViewID', 1);
        
    vSet = updateView(vSet, camPoses); % Update view set.
    
    % Bundle adjustment can move the entire set of cameras. Normalize the
    % view set to place the first camera at the origin looking along the
    % Z-axes and adjust the scale to match that of the ground truth.
    vSet = helperNormalizeViewSet(vSet, groundTruthPoses);
    
    % Update camera trajectory plot.
    helperUpdateCameraPlots(viewId, camEstimated, camActual, poses(vSet), ...
        groundTruthPoses);
    helperUpdateCameraTrajectories(viewId, trajectoryEstimated, ...
        trajectoryActual, poses(vSet), groundTruthPoses);
    
    prevI = I;
    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end
%% Estimate Remaining Camera Trajectory Using Windowed Bundle Adjustment

for viewId = (MAX_GLOBAL+1):numel(images.Files)
    % Read and display the next image
    Irgb = readimage(images, viewId);
    step(player, Irgb);
    
    % Convert to gray scale and undistort.
    I = undistortImage(rgb2gray(Irgb), intrinsics);

    % Match points between the previous and the current image.
    [currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
        prevFeatures, I, numPoints, SURF_THRESHOLD);    
          
    % Triangulate points from the previous two views, and find the 
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet, ...
        intrinsics, indexPairs, currPoints);

    % Since RANSAC involves a stochastic process, it may sometimes not
    % reach the desired confidence level and exceed maximum number of
    % trials. Disable the warning when that happens since the outcomes are
    % still valid.
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    % Estimate the world camera pose for the current view.
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, intrinsics);
    
    % Restore the original warning state
    warning(warningstate)
    
    % Add the current view and connection to the view set.
    vSet = addView(vSet, viewId, rigid3d(orient, loc), 'Points', currPoints);
    vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);
        
    % Refine estimated camera poses using windowed bundle adjustment. Run 
    % the optimization every "INTER_PARCIAL"'th view.
    if mod(viewId, INTER_PARCIAL) == 0        
        % Find point tracks in the last WINDOW_PARCIAL views and triangulate.
        windowSize = WINDOW_PARCIAL;
        startFrame = max(1, viewId - windowSize);
        tracks = findTracks(vSet, startFrame:viewId);
        camPoses = poses(vSet, startFrame:viewId);
        [xyzPoints, reprojErrors] = triangulateMultiview(tracks, camPoses, intrinsics);
                                
        % Hold the first two poses fixed, to keep the same scale. 
        fixedIds = [startFrame, startFrame+1];
        
        % Exclude points and tracks with high reprojection errors.
        idx = reprojErrors < 2;
        
        [~, camPoses] = bundleAdjustment(xyzPoints(idx, :), tracks(idx), ...
            camPoses, intrinsics, 'FixedViewIDs', fixedIds, ...
            'PointsUndistorted', true, 'AbsoluteTolerance', 1e-12,...
            'RelativeTolerance', 1e-12, 'MaxIterations', 200);
        
        vSet = updateView(vSet, camPoses); % Update view set.
    end
    
    % Update camera trajectory plot.
    helperUpdateCameraPlots(viewId, camEstimated, camActual, poses(vSet), ...
        groundTruthPoses);    
    helperUpdateCameraTrajectories(viewId, trajectoryEstimated, ...
        trajectoryActual, poses(vSet), groundTruthPoses);    
    
    prevI = I;
    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end
hold off

clc

fprintf("Estimation complete! Press any key to see the estimation error.")
pause;
close all
imtool close all;
clc

%Calculate error
get_error(groundTruthPoses,vSet);
fprintf("Showing the errors. Press any key to go back.")
pause;
clc
close all
