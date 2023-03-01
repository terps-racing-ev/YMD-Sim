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
SWAngle = linspace(-90,90,37); %deg (L = neg, R = pos)

%% Code
Wheelbase = vehicleObj.Wheelbase();
TrackWidth = vehicleObj.TrackWidth();
FTrackWidth = TrackWidth(1,:);
Ackermann = vehicleObj.Ackermann();
Toe = vehicleObj.Toe();
FToe = Toe(1,:);

for i = 1:37
    [SteerAngles(i,:),TurnRadius(i,:)] = SteerAngleSim(SWAngle(:,i),Wheelbase,FTrackWidth,Ackermann,FToe);
end

%% Plots
figure('Name','Steering Angle Sweep');
plot(SWAngle,SteerAngles(:,1),'-r*');
hold on
plot(SWAngle,SteerAngles(:,2),'-ro');
hold on
title('Steering Angle Sweep');
xlim([-90 90]);
legend(' FL',' FR','Location','eastoutside')

figure('Name','Turrning Radius Sweep');
plot(SWAngle,TurnRadius,'-b*');
title('Turning Radius Sweep');
xlim([-90 90]);