function trials = generateTrials_P1(handPosition)
    angles = 0:22.5:157.5;
    anglesPerDigit = {[angles, 60, 108]; % D2
                      [angles, 60, 36]; % D3
                      [angles, 120, 144]; % D4
                      [angles, 120, 72]}; % D5
            % original angles + angles from triangle and pentagon shapes

    numDigits = 4;
    numOri = length(anglesPerDigit{1}); 
    numTrialsPerCond = 25;
    numTrials = numDigits * numOri * numTrialsPerCond; % = 1000
    trialsPerBlock = numTrials / 5; 
    numBlocks = numTrials / trialsPerBlock;

    trials = table([1:numTrials]', 'VariableNames', {'Trial'});
    trials.block(:) = -1; 
    trials.digit(:) = -1;
    trials.orientation(:) = -1;
    trials.ITI(:) = -1;
    trials.stimDur(:) = 1; % 1 second stimulus
    trials.TriggerTimeRelativetoSessionStart(:) = -1; 
    trials.TriggerTimeOfTouchCommandRelativeToElectrodeSignal(:) = -1; 

    trials.digit = [repelem(2, numTrials/4)';
                    repelem(3, numTrials/4)';
                    repelem(4, numTrials/4)';
                    repelem(5, numTrials/4)'];

    for d = 2:5
        trials.orientation(trials.digit == d) = repmat(anglesPerDigit{d-1}', [numTrialsPerCond,1]);
    end
    
    if strcmpi(handPosition, "PalmDown")
        trials.orientation(trials.orientation > 0) = 180 - trials.orientation(trials.orientation > 0);
    end

    trials = trials(randperm(height(trials)),:); % randomize trial order 
    trials.Trial(:) = 1:height(trials); % reset trial number 

    blockNum = [];
    for b = 1:numBlocks
        blockNum = [blockNum; repelem(b, trialsPerBlock)'];
    end
    trials.block(:) = blockNum;
end

% OLD VERSION 
% function trials = generateTrials_P1()
%     angles = 0:22.5:157.5;
%     numTrials = 4 * 20 * 8; % number of digits * num trials per ori * num ori = 640
%     trials = table([1:numTrials]', 'VariableNames', {'Trial'});
%     trials.digit(:) = -1;
%     trials.orientation(:) = -1;
%     trials.ITI(:) = -1;
%     trials.stimDur(:) = 1; % 1 second stimulus
%     trials.stimtype(:) = -1;
%     trials.TriggerTimeRelativetoSessionStart(:) = -1; 
%     trials.TriggerTimeOfTouchCommandRelativeToElectrodeSignal(:) = -1; 
% 
%     trials.digit = [repelem(2, numTrials/4)';
%                     repelem(3, numTrials/4)';
%                     repelem(4, numTrials/4)';
%                     repelem(5, numTrials/4)'];
%     trials.orientation = repmat(angles', 4*20, 1);
% 
%     for t = 1:height(trials)
%         trials.stimtype(t) = str2double([num2str(trials.digit(t)), num2str(find(angles == trials.orientation(t)))]); % set stim types for tuning curve analysis 
%     end
% 
%     trials = trials(randperm(height(trials)),:); % randomize trial order 
%     trials.Trial(:) = 1:height(trials); % reset trial number 
% end