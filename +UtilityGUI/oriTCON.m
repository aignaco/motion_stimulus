classdef oriTCON
    properties(Access = public)
        trialNum = 0;
        digit = -1;
        orientation = -1;
        condition = -1; % Protocol 2 condition
            % 1 = same orientation across all digits
            % 2 = orthogonal orientations between preferred and unpreferred digits
            % 3 = random orientation for all 
        expstatus = -1; % experiment status
            % 1 = start/ongoing
            % 0 = paused
            % -1 = stopped / not started 
        
    end
    properties (Constant)
        dMtr = 1.75; 
        dStepper = 1.75; 
    end
end
