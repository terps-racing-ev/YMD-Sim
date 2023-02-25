%% Steering Angle Test

clc
%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = VehicleParameters();

% Adding StiffnessSim & LLTSim
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs
SWAngle = 10; %deg (L = neg, R = pos)

%% Code
Wheelbase = vehicleObj.Wheelbase();
TrackWidth = vehicleObj.TrackWidth();
FTrackWidth = TrackWidth(1,:);
Ackermann = vehicleObj.Ackermann();
Toe = vehicleObj.Toe();
FToe = Toe(1,:);

[SteerAngles,TurnRadius] = SteerAngleSim(SWAngle,Wheelbase,FTrackWidth,Ackermann,FToe);

disp('Steering Angles: ');
disp(SteerAngles);
disp('Turning Radius: ');
disp(TurnRadius);