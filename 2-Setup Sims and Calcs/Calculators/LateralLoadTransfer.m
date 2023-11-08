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
[latTrainingData_P1,tireID,testID] = createLatTrngData(filename_P1);

filename_P2 = 'A2356run9.mat';
[latTrainingData_P2,tireID,testID] = createLatTrngData(filename_P2);

totData = cat(1,latTrainingData_P1,latTrainingData_P2);
trainData = latTrainingData_P1;

%% Inputs

% Right Turn = True, Left Turn = False
RightTurn = false;

% Test Velocity (0 mph & Right Turn = Tilt Test)
Velocity = 20;

Radius = 348; %in

%% Calculations

% Tire Spring Rates (lbf/in)
[F_polyCalc_Kt,R_polyCalc_Kt] = SpringRateSim(latTrainingData_P1,latTrainingData_P2,vehicleObj);

K_t = [F_polyCalc_Kt, F_polyCalc_Kt; R_polyCalc_Kt, R_polyCalc_Kt];

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

[F_polyCalc,R_polyCalc] = LateralCoFSim(latTrainingData_P1,latTrainingData_P2,vehicleObj);

% Static Weights at Velocity (lb) -> Max G's Possible on Entry
[Fz,LoLT,Accelmax,Z] = LoLTSim(0,Velocity,0,K_r,vehicleObj);

mu_F = [polyval(F_polyCalc,Fz(1,1)), polyval(F_polyCalc,Fz(1,2))];
mu_R = [polyval(R_polyCalc,Fz(2,1)), polyval(R_polyCalc,Fz(2,2))];

if RightTurn == true
    Fy_max = -([mu_F;mu_R].*Fz);
else
    Fy_max = [mu_F;mu_R].*Fz;
end

g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

mu_drive = g_avg;

if Velocity == 0 && RightTurn == true
    mu_drive = -1.7;
end

% disp('Fz (lb): ');
% disp(Fz);
% disp('Max Fy (lb): ');
% disp(Fy_max);
% % disp('Yaw Moment (lb*in):');
% % disp(Yaw);
% disp('Max Lateral Acceleration (Gs): ');
% disp(g_avg);
% disp('Wheel Displacement (in): ');
% disp(Z);

% Maximum Cornering Velocity (mph)
% CornerSpeed = sqrt(((abs(sum(reshape(Fy_max,[1,4]))))/(vehicleObj.TotalWeight/32.2))*(Radius/12))/1.467;

% Dynamic Weights (lb) -> Max Fy from Weight Transfer
[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_r,K_roll,Velocity,mu_drive,vehicleObj);

mu = [mu_F,mu_R];

mu_F = [polyval(F_polyCalc,Fz(1,1)), polyval(F_polyCalc,Fz(1,2))];
mu_R = [polyval(R_polyCalc,Fz(2,1)), polyval(R_polyCalc,Fz(2,2))];

if RightTurn == true
    Fy_max = -([mu_F;mu_R].*Fz);
else
    Fy_max = [mu_F;mu_R].*Fz;
end

g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

% Maximum Cornering Velocity (mph)
CornerSpeed = sqrt(((abs(sum(reshape(Fy_max,[1,4]))))/(vehicleObj.TotalWeight/32.2))*(Radius/12))/1.467;

% Rough Yaw Calculator
% Yaw_Wheel = Fy_max.*[vehicleObj.FrontAxleToCoG,vehicleObj.FrontAxleToCoG;vehicleObj.CoGToRearAxle,vehicleObj.CoGToRearAxle];
% 
% Yaw = sum(Yaw_Wheel(1,:))-sum(Yaw_Wheel(2,:));

% disp('----------');
disp('Fz (lb): ');
disp(Fz);
disp('Max Fy (lb): ');
disp(Fy_max);
% disp('Yaw Moment (lb*in):');
% disp(Yaw);
disp('Max Lateral Acceleration (Gs): ');
disp(g_avg);
disp('Max Cornering Velocity (mph): ');
disp(CornerSpeed);
disp('LLT_D: ');
disp(LLT_D);
disp('Roll Sensitivity (deg/g): ');
disp(R_g);
disp('Roll Angle (deg): ');
disp(Roll_Angle);
disp('Wheel Displacement (in): ');
disp(Z);