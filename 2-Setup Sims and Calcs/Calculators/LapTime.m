%% Lap Time Calculator

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

%% Tire Modeling

filename_P1 = 'A2356run8.mat';
[latTrainingData_P1,tireID,testID] = createLatTrngData(filename_P1);

filename_P2 = 'A2356run9.mat';
[latTrainingData_P2,tireID,testID] = createLatTrngData(filename_P2);

totData = cat(1,latTrainingData_P1,latTrainingData_P2);
trainData = latTrainingData_P1;

%% Track Sections

% convert track in straights and corners

% Straights: x_straight
% Corners: track entry/exit width & arc_angle (0-360 deg)

%% Corners

% generate corner radii
% for each corner radii generated...
% take a test entry speed and iterate until entry speed = cornering speed
% use highest speed as 

%% Straights

% for each straight generated...
% x_accel + x_braking = x_straight
% add driveline losses, rolling resistance, and drag
