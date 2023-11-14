%% Tire Load Cases -> SUSP Forces Calcs

% This calculator calculates the SUSP forces for a given tire load case

% List of Important Tire Load Cases
% - 0g Static
% - Max Acceleration (g's)
% - Max Deceleration (g's)
% - Max Cornering (g's)
% - Cone Strike (5g Bump)
% - Tilt Test (1.7 g's cornering)

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);

% Adding Tire Models
addpath([currentFolder, filesep, '1-Input Functions', filesep, 'Tire Modeling']);

% Adding Additional Calculators
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Calculators']);

% Adding Additional Similators
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

% Adding Reference Files
addpath([currentFolder, filesep, 'Reference Files\']);

vehicleObj = TREV2Parameters();

%% Inputs

% Load Geo Points from Cookbook
dataTable = readtable('TREV2 Cookbook-MATLAB.xlsx','Sheet', 'Geo Forces','VariableNamingRule','preserve');

% Input test tire forces for analysis
Zerog_Static = 3;
Max_Acceleration = 4;
Max_Deceleration = 5; 
Max_Cornering = 6;
Tilt_Test = 7; 
Cone_Strike = 8; 
% Maximum_Compress = 9; 
% Maximum_Tension = 10;

%Choose column number from above
Col_Num = 3;

% 1x3 matrices - [Fx Fy Fz] 
F_FL = [dataTable{1,Col_Num}; dataTable{2,Col_Num}; dataTable{3,Col_Num}];

F_FR = [dataTable{10,Col_Num}; dataTable{11,Col_Num}; dataTable{12,Col_Num}];

F_RL = [dataTable{19,Col_Num}; dataTable{20,Col_Num}; dataTable{21,Col_Num}];

F_RR = [dataTable{28,Col_Num}; dataTable{29,Col_Num}; dataTable{30,Col_Num}];

%% Calculations

% output:
% 4 1x6 matrices 

FL = round(ForceCalc().Forces_FL(F_FL(1), F_FL(2), F_FL(3)),4,"decimals");
FR = round(ForceCalc().Forces_FR(F_FR(1), F_FR(2), F_FR(3)),4,"decimals");
RL = round(ForceCalc().Forces_RL(F_RL(1), F_RL(2), F_RL(3)),4,"decimals");
RR = round(ForceCalc().Forces_RR(F_RR(1), F_RR(2), F_RR(3)),4,"decimals");

format longG

disp('Front Left (FL) Tire Loads');
disp(F_FL);
disp('------------------');
disp('Front Left (FL) Forces');
disp(FL);

disp('Front Right (FR) Tire Loads');
disp(F_FR);
disp('------------------');
disp('Front Right (FR) Forces');
disp(FR);

disp('Rear Left (RL) Tire Loads');
disp(F_RL);
disp('------------------');
disp('Rear Left (RL) Forces');
disp(RL);

disp('Rear Right (RR) Tire Loads');
disp(F_RR);
disp('------------------');
disp('Rear Right (RR) Forces');
disp(RR);

% winopen('TREV2 Cookbook.xlsx');
