%% Lateral Load Transfer Test

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

K_t = [635 635; 635 635];%lbf/in 

% Input test G's Pulled (neg -> Left, pos -> Right)
Ay = 1.7;

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