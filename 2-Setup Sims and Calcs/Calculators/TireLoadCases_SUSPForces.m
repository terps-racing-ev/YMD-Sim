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

%% Inputs

% Load Geo Points .xlsx

geopoints = readtable('EV24 Geo Points.xls');

% Input test tire forces for analysis

F_x = 0;
F_y = 0;
F_z = 0;

%% Calculations

results = ForceSim(geopoints,F_x,F_y,F_Z);
