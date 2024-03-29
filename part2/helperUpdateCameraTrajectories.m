%% Example function taken from MATLAB

% helperUpdateCameraTrajectories update camera trajectories for VisualOdometryExample

% Copyright 2016-2019 The MathWorks, Inc. 
function helperUpdateCameraTrajectories(viewId, trajectoryEstimated, ...
    trajectoryActual, posesEstimated, posesActual)

% Plot the estimated trajectory.
locations = vertcat(posesEstimated.AbsolutePose.Translation);
set(trajectoryEstimated, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));

% Plot the ground truth trajectory
locationsActual = cat(1, posesActual.Location{1:viewId});
set(trajectoryActual, 'XData', locationsActual(:,1), 'YData', ...
    locationsActual(:,2), 'ZData', locationsActual(:,3));