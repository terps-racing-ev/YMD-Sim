%% Steering Angle Sweep

clc
%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = TREV2Parameters();

% Adding StiffnessSim & LLTSim
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs

% Input Car Parameters
Wheelbase = vehicleObj.Wheelbase();
TrackWidth = vehicleObj.TrackWidth();
FTrackWidth = TrackWidth(1,:);
Ackermann = vehicleObj.Ackermann();
Toe = vehicleObj.Toe();
FToe = Toe(1,:);

% Steering Wheel Angle Sweep
SWAngle = linspace(-90,90,37); %deg (L = neg, R = pos)

%% Code
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
xlabel('Steering Wheel Angle (deg)');
ylabel('Steer Angles (deg)');
legend(' FL',' FR','Location','eastoutside')

figure('Name','Turning Radius Sweep');
plot(SWAngle,TurnRadius,'-b*');
title('Turning Radius Sweep');
xlim([-90 90]);
xlabel('Steering Wheel Angle (deg)');
ylabel('Turning Radius (ft)');