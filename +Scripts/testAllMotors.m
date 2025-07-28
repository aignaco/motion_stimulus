%% Test Linear Actuator
clc;clear; 
serialLA = serialport('COM5', 9600);
configureTerminator(serialLA, "CR/LF");
set(serialLA, 'Timeout',15); 

commandLabel = 1;
goalPos = 900; 

serialCommand = sprintf("%d\n", [commandLabel goalPos]);
write(serialLA, serialCommand, "string"); 

%% Test Stepper Motor / Herkulex
clc;clear;
serialSM = serialport('COM3', 115200);
configureTerminator(serialSM, "CR/LF");
set(serialSM, 'Timeout',15); 

%% Test Herkulex with Duration 
commandLabel = 2;
setSpeed = -500; 
duration = 1500; 

serialCommand = sprintf("%d\n", [commandLabel setSpeed duration]);
write(serialSM, serialCommand, "string"); 

%% Test Herkulex withOUT Duration 
commandLabel = 3;
setSpeed = 0; 

serialCommand = sprintf("%d\n", [commandLabel setSpeed]);
write(serialSM, serialCommand, "string"); 

%% Test Stepper Motor 
commandLabel = 6;
mtrNum = 1; 
angleDirection = 0; 
angleAmount = 90; 

serialCommand = sprintf("%d\n", [commandLabel mtrNum angleDirection angleAmount]);
write(serialSM, serialCommand, "string"); 