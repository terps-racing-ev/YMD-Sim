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
% currentFolder = pwd;
% addpath([currentFolder, filesep, '1-Input Functions']);
% addpath([currentFolder, filesep, '2-Setup Sims and Calcs']);
% 
% 
% vehicleObj = TREV2Parameters();
% Adding Additional Sims

%% Inputs

% Load Geo Points .xlsx
dataTable = readtable('TREV2 Cookbook.xlsx','Sheet', 'Geo Forces','VariableNamingRule','preserve');


% Display the modified column names
columnNames = dataTable.Properties.VariableNames;

% Input test tire forces for analysis
Zerog_Static = 3;
Max_Acceleration = 4;
Max_deceleration = 5; 
Max_Cornering = 6;
Tilt_Test = 7; 
Cone_Strike = 8; 
% Maximum_Compress = 9; 
% Maximum_Tension = 10;

%Choose column number from above
Col_Num = Zerog_Static;
% reading Gstatic , change column number for different cases
% 1x3 matrices - [Fx Fy Fz] 
F_FL = [dataTable{1,Col_Num}, dataTable{2,Col_Num} dataTable{3,Col_Num}];

F_FR = [dataTable{10,Col_Num}, dataTable{11,Col_Num} dataTable{12,Col_Num}];

F_RL = [dataTable{19,Col_Num} dataTable{20,Col_Num} dataTable{21,Col_Num}];

F_RR = [dataTable{28,Col_Num} dataTable{29,Col_Num} dataTable{30,Col_Num}];

%% Calculations

% output:
% 4 1x6 matrices 


disp(F_FL);
disp(F_FR);
disp(F_RL);
disp(F_RR);

FL = ForceCalc().Forces_FL(F_FL(1), F_FL(2), F_FL(3));
FR = ForceCalc().Forces_FR(F_FR(1), F_FR(2), F_FR(3));
RL = ForceCalc().Forces_RL(F_RL(1), F_RL(2), F_RL(3));
RR = ForceCalc().Forces_RR(F_RR(1), F_RR(2), F_RR(3));


disp(FL);
disp(FR);
disp(RL);
disp(RR);






