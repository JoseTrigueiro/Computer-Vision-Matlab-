function [] = get_error(groundTruthPoses,vSet)
%%
% This function compares the real ground truth poses and the estimated
% camera poses, and calculates the error in position in each coordinate and
% the total euclidean distance / error between trajectories

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B

%%

nviews = height(vSet.Views); %number of views

% Real positions
real_position = cell2mat(groundTruthPoses.Location);

%Extract positions from view set
estimate_position = cell(nviews,1);
for i=1:nviews
estimate_position{i,1} = vSet.Views.AbsolutePose(i,1).Translation;
end
estimate_position = cell2mat(estimate_position);

%Calculate and plot error on each coordinate
figure("WindowState", "maximized")
subplot(1,2,1)
hold on
plot(0:(nviews-1),abs(real_position(:,1)-estimate_position(:,1)), "LineWidth", 2)
plot(0:(nviews-1),abs(real_position(:,2)-estimate_position(:,2)), "LineWidth", 2)
plot(0:(nviews-1),abs(real_position(:,3)-estimate_position(:,3)), "LineWidth", 2)
title("Errors in estimating each coordinate",'FontSize', 18)
xlabel("View Nr", 'FontSize', 16)
ylabel("Error (mm)", 'FontSize', 16)
legend("x error (mm)","y error (mm)", "z error (mm)", 'FontSize', 14, "Location", "Northwest")
grid on

%Calculate and plot euclidean distance
subplot(1,2,2)
plot( 0:(nviews-1), sqrt( (real_position(:,1)-estimate_position(:,1)).^2 + ...
      (real_position(:,2)-estimate_position(:,2)).^2 + ...
      (real_position(:,3)-estimate_position(:,3)).^2), "LineWidth", 2 )
title("Euclidean distance between real and estimated trajectory",'FontSize', 18)
xlabel("View Nr", 'FontSize', 16)
ylabel("Error (mm)", 'FontSize', 16)
legend("Euclidean error", 'FontSize', 14, "Location", "Northwest")
grid on

