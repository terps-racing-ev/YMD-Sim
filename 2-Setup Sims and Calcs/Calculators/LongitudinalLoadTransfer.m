%% Longitudinal Load Transfer Test

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

K_t = [548 548; 548 548]; %lbf/in 
mux = 1.5;

% Input test G's Pulled (neg -> Braking, pos -> Acceleration)
Ax = 1.5;

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Load Transfer (lb)
[Fz,LoLT,Accelmax,Z] = LoLTSim(mux,Ax,K_r,vehicleObj);

disp('Fz: ');
disp(Fz);
disp('Max Longitudinal Acceleration: ');
disp(Accelmax);
disp('Wheel Displacement: ');
disp(Z);