%% Braking Test

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

% Input Test Braking Force (lbf)
DriverForce = 120;

BrakeParameters = [1.45;1;3.131;0.3;4;1.45;1;1.5708;0.3;2;0.9375;0.69029;7;4.13;0.5];

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Braking Forces (lb)
[Fx,Ax,BF] = BrakingSim(DriverForce,mux,BrakeParameters,vehicleObj);

% Load Transfer (lb)
[Fz,LoLT,Accelmax,Z] = LoLTSim(mux,Ax,K_r,vehicleObj);

% Tire Limit (g's)
[TL] = tireLimits(BF,Fz);

disp('Fx: ');
disp(Fx);
disp('Fz: ');
disp(Fz);
disp('Longitudinal Acceleration: ');
disp(Ax);
disp('Wheel Displacement: ');
disp(Z);
disp('Tire Limits: ');
disp(TL);