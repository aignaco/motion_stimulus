classdef oriCCON
    properties(Access = public)
        mega;
        leo;
        uno; 
    end

    properties (Constant)
        daqDeviceId = "Dev1"; % nidaq device name
        DAQSamplingRate = 2000; % number of samples collected in one second;
        DAQscansAvailableFcnCount = 200; %  2000/200 = 10 times per second. Every 100ms
        DAQ_AIChannel = 0; % analog input channel number for analog listener for pulses sent to neurpixel 
        
        megaPort = 'COM5'; % Arduino Mega port for stepper motors
        megaBaudRate = 9600;

        leoPort = 'COM4'; % Arduino Leo port for linear actuators
        leoBaudRate = 9600; 

        unoPort = 'COM8'
        unoBaudRate = 9600; 
    end
end