%% Slip Angle Test

clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = TREV2Parameters();

% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs

% Input Car Parameters
Wheelbase = vehicleObj.Wheelbase();
TrackWidth = vehicleObj.TrackWidth();
FTrackWidth = TrackWidth(1,:);
Ackermann = vehicleObj.Ackermann();
Toe = vehicleObj.Toe();
FToe = Toe(1,:);
a = vehicleObj.FrontAxleToCoG();
b = vehicleObj.CoGToRearAxle();
CoGh_RA = vehicleObj.CoGhRA();

K_s = vehicleObj.K_s();
K_ARB = vehicleObj.K_ARB();
MR_s = vehicleObj.MR_s();
MR_ARB = vehicleObj.MR_ARB();

K_t = [548 548; 548 548];%lbf/in 

% Input Steering Wheel Angle
SWAngle = 0; %deg (L = neg, R = pos)

% Input Test Cornering Parameters
Velocity = 27.1656; %mph
Radius = 348; %in
Beta = 0; %CoG slip angle (deg) (neg -> Right, pos -> Left)

SlipCarParameters = [a; b; TrackWidth(1,:); TrackWidth(2,:)];
    
%% Code

SteerAngles = SteerAngleSim(SWAngle,Wheelbase,FTrackWidth,Ackermann,FToe);
[SlipAngles,AccelG,Betamax] = SlipAngleSim(SteerAngles,Beta,Velocity,Radius,SlipCarParameters)

