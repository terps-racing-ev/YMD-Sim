%% Steering Angle Sweep

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
<<<<<<< Updated upstream:2-Setup Sims and Calcs/Calculators/SteeringAngleSweep.m
vehicleObj = TREV1Parameters();
=======
>>>>>>> Stashed changes:2-Setup Sims and Calcs/Simulators/SteeringAngleSweep.m

% Adding StiffnessSim & LLTSim
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

<<<<<<< Updated upstream:2-Setup Sims and Calcs/Calculators/SteeringAngleSweep.m
=======
% Adding Reference Files
addpath([currentFolder, filesep, 'Reference Files\']);

vehicleObj = TREV2Parameters();

>>>>>>> Stashed changes:2-Setup Sims and Calcs/Simulators/SteeringAngleSweep.m
%% Inputs

% Steering Wheel Angle Sweep
SWAngle = linspace(-90,90,37); %deg (L = neg, R = pos)

%% Code
for i = 1:37
    [SteerAngles(:,:,i),TurnRadius(:,i)] = SteerAngleSim(SWAngle(:,i),vehicleObj);
end

%% Plots

subplot(1,2,1);
title('Steering Angle Sweep');
SteerAnglesL = squeeze(SteerAngles(1,1,:));
plot(SWAngle,SteerAnglesL,'-r*');
hold on
SteerAnglesR = squeeze(SteerAngles(1,2,:));
plot(SWAngle,SteerAnglesR,'-ro');
hold on
title('Steering Angle Sweep');
xlim([-90 90]);
xlabel('Steering Wheel Angle (deg)');
ylabel('Steer Angles (deg)');
legend(' FL',' FR','Location','eastoutside')

subplot(1,2,2);
title('Turning Radius Sweep');
plot(SWAngle,TurnRadius,'-b*');
title('Turning Radius Sweep');
xlim([-90 90]);
xlabel('Steering Wheel Angle (deg)');
ylabel('Turning Radius (ft)');