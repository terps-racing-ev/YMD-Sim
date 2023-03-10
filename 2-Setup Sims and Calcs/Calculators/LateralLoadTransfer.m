%% Lateral Load Transfer Test

close all
clearvars
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
Weight = vehicleObj.TotalWeight();
StaticWeights = vehicleObj.staticWeights();
TrackWidth = vehicleObj.TrackWidth();
Z_r = vehicleObj.Zr;
a = vehicleObj.FrontAxleToCoG();
b = vehicleObj.CoGToRearAxle();
L = vehicleObj.Wheelbase();
CoGh_RA = vehicleObj.CoGhRA();

K_s = vehicleObj.K_s();
K_ARB = vehicleObj.K_ARB();
MR_s = vehicleObj.MR_s();
MR_ARB = vehicleObj.MR_ARB();

K_t = [548 548; 548 548];%lbf/in 

% Input test G's Pulled (neg -> Left, pos -> Right)

Ay = 1.5;

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_s,K_ARB,K_t,MR_s,MR_ARB,TrackWidth);

% Load Transfer (lb)
[Fz,LLT,LLT_D,R_g,Roll_Angle] = LLTSim(K_roll,Weight,StaticWeights,Ay,TrackWidth,CoGh_RA,Z_r,a,b,L);

% Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))
Z = [(tan(deg2rad(Roll_Angle))*(TrackWidth(1,:)/2)), -(tan(deg2rad(Roll_Angle))*(TrackWidth(1,:)/2));
    (tan(deg2rad(Roll_Angle))*(TrackWidth(2,:)/2)), -(tan(deg2rad(Roll_Angle))*(TrackWidth(2,:)/2))];

for i = 1:2
    for j = 1:2
        if(Z(i,j) < -1)
            Z(i,j) = -1;
        end
        if(Z(i,j) > 1)
            Z(i,j) = 1;
        end
    end
end

disp('Fz: ');
disp(Fz);
disp('LLT_D: ');
disp(LLT_D);
disp('Roll Sensitivity: ');
disp(R_g);
disp('Roll Angle: ');
disp(Roll_Angle);
disp('Wheel Displacement: ');
disp(Z);