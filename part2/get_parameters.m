function alg_parameters = get_parameters(varargin)
%% 

% This function generates hyperparameters for the algorithm. If the
% parameter struct alg_parameters exists, it is completed with default
% values if necessary. If not, it is initialized with default values.

%Input:
% - alg_parameters: parameter struct for the algorithm

%Output:
% - alg_parameters: parameter struct for the algorithm

% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B

%%
% Assign parameters
if nargin == 1
    alg_parameters = varargin{1};
    
    if isfield(alg_parameters,'MAX_GLOBAL') == 0
        alg_parameters.MAX_GLOBAL = 15; % Maximum frame for the global bundle adjustment DEFAULT = 15
    end
    
    if isfield(alg_parameters,'INTER_PARCIAL') == 0
        alg_parameters.INTER_PARCIAL = 7; % Interval between frames where partial bundle adjustment
    end                                   % is performed DEFAULT = 7
    
    if isfield(alg_parameters,'WINDOW_PARCIAL') == 0
        alg_parameters.WINDOW_PARCIAL = 15; % Window for the partial bundle adjustment DEFAULT 15
    end
    
    if isfield(alg_parameters,'SURF_POINTS') == 0
        alg_parameters.SURF_POINTS = 200; % Number of selected SURF points DEFAULT 200
    end
    
    if isfield(alg_parameters,'SURF_THRESHOLD') == 0
        alg_parameters.SURF_THRESHOLD = 500; % Metric Threshold for SURF DEFAULT 500
    end
    
else % nargin == 0, Assign all default values
    alg_parameters.MAX_GLOBAL = 15;
    alg_parameters.INTER_PARCIAL = 7;
    alg_parameters.WINDOW_PARCIAL = 15;
    alg_parameters.SURF_POINTS = 200;
    alg_parameters.SURF_THRESHOLD = 500;
end