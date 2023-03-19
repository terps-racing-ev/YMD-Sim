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
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Load Transfer (lb)
[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_roll,Ay,vehicleObj);

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