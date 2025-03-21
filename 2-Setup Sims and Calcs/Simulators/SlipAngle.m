%% Slip Angle Test

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = TREV1Parameters();

% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs

K_t = [548 548; 548 548];%lbf/in 

% Input Steering Wheel Angle
SWAngle = 0; %deg (L = neg, R = pos)

% Input Test Cornering Parameters
Velocity = 20; %mph
Radius = 348; %in (neg -> Left, pos -> Right)
Beta = 0; %CoG slip angle (deg) (neg -> Right, pos -> Left)
    
%% Code

SteerAngles = SteerAngleCalc(SWAngle,vehicleObj);
[SlipAngles,LatAccelG,Betamax] = SlipAngleCalc(SteerAngles,Beta,Velocity,Radius,vehicleObj)
