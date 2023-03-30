%% Tire Load Cases -> SUSP Forces Calcs

% This calculator uses the SUSP Force Sim (ForceSim.m) to determine the
% SUSP forces for given tire load cases

% List of Important Tire Load Cases
% - 0g Static
% - Max Acceleration (g's)
% - Max Deceleration (g's)
% - Max Cornering (g's) - Skidpad
% - Cone Strike (5g Bump)
% - Tilt Test (1.7 g's cornering)

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

% Load Geo Points .xlsx

% geopoints = readtable('EV24 Geo Points.xls');

% Input test tire forces for analysis

% format: [FL FR; RL RR]
Fx = [0 0; 0 0];
Fy = [0 0; 0 0];
Fz = [780 780; 845 845];

%% Calculations

% output:

% Note for me -akarsh, double check
FL = ForceSim().Forces_FL(Fx, Fy, Fz)
FR = ForceSim().Forces_FR(Fx, Fy, Fz)
RL = ForceSim().Forces_RL(Fx, Fy, Fz)
RR = ForceSim().Forces_RR(Fx, Fy, Fz)
