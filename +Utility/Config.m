classdef Config
    %CONFIG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        % LOCATIONS
        nwbBaseLocation = fullfile("Data", "Tests");
        storageDir = fullfile(pwd, "Data", "Monkey");
        altSaveBoxDir = fullfile("C:\Users\ramirezlab\Box\BCSRochester\CodeReps\MonkeyA001\Data", "Monkey");
%         waterDurationLoggingFile = []; 
        color Utility.Colors = Utility.Colors();
        monkeyList = {'JD'};
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%% SAVE LOCATIONS %%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% NOTE: Save locations for the model are in 
        %%%%%%%%%%%%%%%%%% config model. %%%%%%%%%%%%%%
        
    end
    
    properties
        
    end
        
    
    methods

    end
end

