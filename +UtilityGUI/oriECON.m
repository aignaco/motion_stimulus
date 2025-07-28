classdef oriECON
    properties(Access = public)
        numTrials = -1; 
        dataBox = []; %filename for data for current experiment in Box folder
        dataLocal = []; %filename for data for current experiment in local folder
        trials = []; %empty variable for trials
        expinfo = []; %empty variable for experiment info
    end
    properties (Constant)
        conditions = 1:3; 
        angles = 0:22.5:157.5;
        stimDur = 1; %stim duration = 1 sec
        iti = 2:0.1:4; %randomi ITIs between 1 and 3 sec
        localfolder = fullfile(pwd, "+MonkeyA002_Orientation","Data_Local");
        boxfolder = fullfile("C:\Users\ramirezlab\Box\BCSRochester\CodeReps\MonkeyA001\Data", "MonkeyA002_Orientation");
    end
end