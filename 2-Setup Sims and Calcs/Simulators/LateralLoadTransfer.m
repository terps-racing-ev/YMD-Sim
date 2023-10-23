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

%% Tire Modeling

filename_P1 = 'A2356run8.mat';
[latTrainingData_P1,tireID,testID] = createLatTrngDataCalc(filename_P1);

filename_P2 = 'A2356run9.mat';
[latTrainingData_P2,tireID,testID] = createLatTrngDataCalc(filename_P2);

totData = cat(1,latTrainingData_P1,latTrainingData_P2);
trainData = latTrainingData_P1;

%% Inputs

