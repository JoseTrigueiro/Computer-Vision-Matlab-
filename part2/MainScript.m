%% Computational Vision - Work number 2 - Problem 16 - Main Script

% This is the main program defining the algorithm for moncular visual
% odometry proposed in Problem 16.
% Four options are available:
% A - Open the Monocular Visual Odometry Matlab example
% B - Change the algorithm hyperparameters
% C - Perform experiment 1 (Kitchen Scene dataset)
% D - Perform experiment 2 (Room Scene dataset)


% Afonso Valador 87142 and Jose Trigueiro 87225
% November 2020 - MATLAB 2020B

%%

clc
close all
clearvars

%%

%Main menu
while true
    
    clc
    fprintf("\nWelcome to the Computer Vision Work 2 - Problem 16 Program.\n")
    fprintf("Please choose an option\n\n")
    fprintf("Option A - Open the original MATLAB example.\n")
    fprintf("Option B - Hyperparameters of the algorithm.\n")
    fprintf("Option C - Perform experiment 1.\n")
    fprintf("Option D - Perform experiment 2.\n")
    fprintf("Option E - Exit program.\n\n")
    
    choice = input("Option: ","s");
    
    switch choice
         
        
        case {"A","a"} %Load Original Example
            clc
            openExample('vision/VisualOdometryExample')
        
            
        case {"B","b"} % Hyperparameters of the algorithm      
    
            while true
                
                clc
                fprintf("Choose the parameters you want to change from the list below.\n\n")
                fprintf("1. Maximum frame for the global bundle adjustment.\n")
                fprintf("2. Interval between frames where partial bundle adjustment is performed.\n")
                fprintf("3. Window for the partial bundle adjustment.\n")
                fprintf("4. Number of selected SURF points.\n")
                fprintf("5. SURF Threshold.\n")
                fprintf("6. Reset to default values.\n")
                fprintf("7. Exit.\n\n")
                chosen_param = input("Option:","s");
                chosen_param = str2double(chosen_param);
                
                switch chosen_param
                    case {1}
                        clc
                        fprintf("1. Maximum frame for the global bundle adjustment. Default value: 15\n")
                        value = input("New Value: ");
                        alg_parameters.MAX_GLOBAL = value;
                        
                    case {2}
                        clc
                        fprintf("2. Interval between frames where partial bundle adjustment is performed. Default value: 7\n")
                        value = input("New Value: ");
                        alg_parameters.INTER_PARCIAL = value;
                        
                    case {3}
                        clc
                        fprintf("3. Window for the partial bundle adjustment. Default value: 15\n")
                        value = input("New Value: ");
                        alg_parameters.WINDOW_PARCIAL = value;
                        
                    case {4}
                        clc
                        fprintf("4. Number of selected SURF points. Default value: 200\n")
                        value = input("New Value: ");
                        alg_parameters.SURF_POINTS = value;
                        
                    case {5}
                        clc
                        fprintf("5. SURF Threshold. Default Value: 500\n\n")
                        value = input("New Value: ");
                        alg_parameters.SURF_THRESHOLD = value;
                        
                    case {6}
                        clc
                        fprintf("Reseting to default value...")
                        % Algorithm default parameters
                        alg_parameters.MAX_GLOBAL = 15;
                        alg_parameters.INTER_PARCIAL = 7;
                        alg_parameters.WINDOW_PARCIAL = 15;
                        alg_parameters.SURF_POINTS = 200;
                        alg_parameters.SURF_THRESHOLD = 500;
                        pause(0.5)
                        break
                        
                    case {7}
                        clc
                        fprintf("Returning to main menu...")
                        pause(0.7)
                        break
                    otherwise
                        clc
                end
                
            end
            
        
        case {"C","c"} % Experiment 1
            
            clc
            % Parameters of the algorithm
            if exist("alg_parameters","var")
                alg_parameters = get_parameters(alg_parameters);
            else
                alg_parameters = get_parameters();
            end
            axislims = [-375, 375, -375, 375, -20, 700];
            dist = [0,0,10];
            dataset = "kitchenscene\";
            
            %Check for folder and images
            if exist("kitchenscene","dir")==7
                filefolderlist = dir("kitchenscene");
                filteredlist = filefolderlist(~ismember({filefolderlist.name}, {'.', '..'}));
                if ~isempty(filteredlist)
                    % Run algorithm
                    VisualOdometryApplication(alg_parameters, axislims, dist, dataset);
                else
                    fprintf("The folder is empty. Please download the images from:\n\n")
                    fprintf("https://drive.google.com/drive/u/1/folders/1g_0ykAX_EsZJTUuElsp2mnfoykFf3fH3\n\n")
                    fprintf("to run the algorithm. Press any key to continue.")
                    pause;
                    clc
                end
            else
                fprintf("The folder doesn't exist. Please download the folder with images from:\n\n")
                fprintf("https://drive.google.com/drive/u/1/folders/1g_0ykAX_EsZJTUuElsp2mnfoykFf3fH3\n\n")
                fprintf("to run the algorithm. Press any key to continue.")
                pause;
                clc
            end

            
        
           
       case{"D","d"} % Experiment 2
            
            clc
            % Parameters of the algorithm
            if exist("alg_parameters","var")
                alg_parameters = get_parameters(alg_parameters);
            else
                alg_parameters = get_parameters();
            end
            axislims = [-20, 600, -300, 300, -300, 300];
            dist = [10,0,0];
            dataset = "roomscene\";
            %Check for folder and images
            if exist("roomscene","dir")==7
                filefolderlist = dir("roomscene");
                filteredlist = filefolderlist(~ismember({filefolderlist.name}, {'.', '..'}));
                if ~isempty(filteredlist)
                    %Run algorithm
                    VisualOdometryApplication(alg_parameters, axislims, dist, dataset);
                else
                    fprintf("The folder is empty. Please download the images from:\n\n")
                    fprintf("https://drive.google.com/drive/u/1/folders/1g_0ykAX_EsZJTUuElsp2mnfoykFf3fH3\n\n")
                    fprintf("to run the algorithm. Press any key to continue.")
                    pause;
                    clc
                end
            else
                fprintf("The folder doesn't exist. Please download the folder with images from:\n\n")
                fprintf("https://drive.google.com/drive/u/1/folders/1g_0ykAX_EsZJTUuElsp2mnfoykFf3fH3\n\n")
                fprintf("to run the algorithm. Press any key to continue.")
                pause;
                clc
            end
            
        case {"E","e"}
            clc
            fprintf("Program closing...")
            pause(1)
            clc
            break
            
        otherwise
            clc
            fprintf("Invalid option inserted. Returning to menu...")
            pause(1)
            clc
    end
end