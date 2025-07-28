classdef GUICore < handle
    
    properties
        ccon MonkeyA002_Orientation.UtilityGUI.oriCCON = MonkeyA002_Orientation.UtilityGUI.oriCCON; % connection properties of the equipment
        econ MonkeyA002_Orientation.UtilityGUI.oriECON = MonkeyA002_Orientation.UtilityGUI.oriECON; % experiment properties 
        tcon MonkeyA002_Orientation.UtilityGUI.oriTCON = MonkeyA002_Orientation.UtilityGUI.oriTCON; % trial properties 
        color MonkeyA002_Orientation.Utility.Colors = MonkeyA002_Orientation.Utility.Colors;
        config MonkeyA002_Orientation.Utility.Config = MonkeyA002_Orientation.Utility.Config;
    end
    
    methods
        
        function self = GUICore()
            % DON'T MAKE THIS A FUNCTION WHICH TAKES INPUT ARGUMENTS
        end
        
        function sendMotorCommand(self, commandLabel, varargin)
            value = [];
            board = commandLabel{2};
            commandValue = commandLabel{1};
            switch commandValue
                case self.ccon.labelRotateMotor{1}
                    if nargin == 3
                        value = round(varargin{1} + self.dcon.wheelBias);
                    else
                        disp("You need to provide an angle for rotation")
                    end
                case self.ccon.labelSpeedTest{1}
                    if nargin == 3
                        value = varargin{1};
                    else
                        value = self.dcon.wheelSpeed * self.dcon.wheelDirection;
                    end
                case self.ccon.labelSpeedWithDurationTest{1}
                    if nargin == 4
                        value = [varargin{1}, varargin{2}];
                    elseif nargin == 3
                        % let's assume that it is always duration
                        % as the variable argument
                        value = [self.dcon.wheelSpeed * self.dcon.wheelDirection, varargin{1}];
                    else
                        value = [self.dcon.wheelSpeed * self.dcon.wheelDirection, self.dcon.durationOfSpeedInMilliseconds];
                    end
                case self.ccon.labelActuatorTest{1}
                    if nargin == 3
                        goalPosition = varargin{1};
                        value = goalPosition;
                    end
                case self.ccon.labelMoveStepperMotor{1}
                    if nargin == 3
                        value = round(varargin{1});
                    end
                case self.ccon.labelMoveStepperMotorAbs{1}
                    if nargin == 3
                        value = round(varargin{1});
                    end
            end
            
            if strcmpi(board, 'leo') && self.ccon.okDevices('Leonardo')
                fprintf(self.ccon.leo, "%d\n", [commandLabel{1}, value]);
                disp("Sending Command to Leo");
            elseif strcmpi(board, 'mega') && self.ccon.okDevices('Mega2560')
                fprintf(self.ccon.mega, "%d\n", [commandLabel{1}, value]);
                disp("Sending Command to Mega");
            elseif strcmpi(board, 'uno') && self.ccon.okDevices('Uno')
                fprintf(self.ccon.uno, "%d\n", [commandLabel{1}, value]);
                disp("Sending Command to Uno");
            elseif strcmpi(board, 'stimLocManip') && self.ccon.okDevices('StimLocManip')
                fprintf(self.ccon.stimLocManip, "%d\n", [commandLabel{1}, value]);
                disp("Sending Command to Stepper Motor");
            else
                disp("You have an issue with sending Motor Commands")
            end
            
        end
        function [ok, conn, lamp] = establishArduinoConnection(self, board)
            
            ok = false;
            lamp = self.color.Red;
            
            if strcmpi(board, 'Mega2560')
                portName = self.ccon.megaPort;
                baudRate = self.ccon.megaBaudRate;
                conn = self.ccon.mega;
            elseif strcmpi(board, 'Leonardo')
                portName = self.ccon.leoPort;
                baudRate = self.ccon.leoBaudRate;
                conn = self.ccon.leo;
            else
                conn = -1;
                return;
            end
            
            % if the port is already open
            try
                fprintf(conn, "%d\n", self.ccon.helloLabel);
                ok = true;
                lamp = self.color.Green;
                disp("Succesfully able to send the label value");
                return;
            catch
                disp("Either the obj hasn't been defined yet, or nothing open.");
            end
            
            % Something else is connected to this connection?
            try
                try
                    fclose(conn);
                catch
                    disp("Invalid Connection Closing Operation.");
                end
                delete(conn);
                clear conn;
            catch
                disp("There was no old connection.");
            end
            
            conn = serialport(portName, baudRate); 
            configureTerminator(conn, "CR/LF"); 
            set(conn, 'Timeout', 15);

            try
                lamp = self.color.Green;
                ok = true;
                return;
            catch
                try
                    delete(instrfind('port', portName));
                    disp('Deleting old open port.');
                catch
                    disp('Terminating. Cannot establish connection');
                    ok = false;
                    lamp = self.color.Red;
                    conn = -1;
                    return;
                end
            end
        end
       

        function [self, ok] = runCheckForDevice(self, device)
            ok = 0;
            switch device
                case 'Mega2560'
                    [ok, self.ccon.mega, ~] = ...
                        self.establishArduinoConnection('Mega2560');
                case 'mic'
                    ok = self.checkMic();
                case 'camera'
                    ok = self.checkCamera();
                case 'Uno'
                    [ok, self.ccon.uno, ~] = ...
                        self.establishArduinoConnection('Uno');
                case 'Leonardo'
                    [ok, self.ccon.leo, ~] = ...
                        self.establishArduinoConnection('Leonardo');
                case 'DAQ'
                    % I don't create a permanent DAQ connection and send it because
                    % it's whatever apps responsibility to establish and
                    % close these connections.
                    [ok, ~] = self.establishDAQConnection();
                case 'StimLocManip'
                    [ok, self.ccon.stimLocManip, ~] = ...
                        self.establishArduinoConnection('StimLocManip');
                otherwise
                    error(strcat("You listed a device that I cannot check yet: "), device);
            end
            
        end
        
        function [self, ok] = checkAllConnections(self)
            % an abstracted version which return 1/0 to see if all checks
            % are okay.
            devices = self.ccon.devicesInUse;
            oks = zeros(numel(devices), 1);
            for idd = 1:numel(devices)
                self = self.runMultipleIterationsOfChecks(devices{idd});
                oks(idd) = self.ccon.okDevices(devices{idd});
            end
            if sum(oks) == numel(devices), ok = 1; else, ok = 0; end
        end
        
        function self = runMultipleIterationsOfChecks(self, varargin)
            p = inputParser;
            addRequired(p, 'device');
            addParameter(p, 'n_reps', 3);
            
            if ~isempty(varargin)
                p.parse(varargin{:})
            else
                parse(p)
            end
            
            n_reps = p.Results.n_reps;
            device = p.Results.device;
            for i = 1:n_reps
                % Just by the virtue of my code design, this needs to run
                % multiple times to allow connectivity to the respective
                % Arduino Connection
                [self, ok] = self.runCheckForDevice(device);
                if ok
                    self.ccon.okDevices(device) = 1;
                    break;
                end
            end
        end
        
        function closeConnections(self)
            try
                fclose(self.ccon.leo);
            catch
                disp("Leo couldn't close");
            end
            
            
            try
                fclose(self.ccon.mega);
            catch ME
                disp("Could not close mega");
            end
            
            try
                fclose(self.ccon.uno);
            catch
                disp("Uno couldn't close");
            end
            
            try
                fclose(self.ccon.stimLocManip);
            catch
                disp("Stimulus Location Manipulator couldn't close");
            end
            
            
            try
                fclose(serial(instrfind('Port', self.ccon.leoPort)));
            catch ME
                disp("Could not delete LeoPort")
            end
            
            try
                fclose(serial(instrfind('Port', self.ccon.megaPort)));
            catch ME
                disp("Could not delete MegaPort")
            end
            
            try
                fclose(serial(instrfind('Port', self.ccon.unoPort)));
            catch ME
                disp("Could not delete UnoPort")
            end
            
            try
                fclose(serial(instrfind('Port', self.ccon.stimLocManipPort)));
            catch ME
                disp("Could not delete Stepper Motor Microcontroller object");
            end
            
        end
        function self = setDevices(self, listOfDevices)
            self.ccon.devicesInUse = listOfDevices;
            self.ccon.okDevices = containers.Map(listOfDevices, zeros(numel(listOfDevices), 1));
        end
        
         
        
        
        
    end
end