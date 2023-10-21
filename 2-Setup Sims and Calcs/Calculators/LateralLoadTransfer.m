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

%% Inputs

K_t = [442 442; 442 442]; %lbf/in 

<<<<<<< Updated upstream
% Input test G's Pulled (neg -> Right, pos -> Left)
Ay = -1.7594;
=======
% Test Velocity (0 mph & Right Turn = Tilt Test)
Velocity = 29;
>>>>>>> Stashed changes

% Test Velocity (0 mph = Tilt Test)
Velocity = 0;

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Load Transfer (lb)
[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_roll,Velocity,Ay,vehicleObj);

<<<<<<< Updated upstream
disp('Fz: ');
=======
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
Yaw_Wheel = Fy_max.*[vehicleObj.FrontAxleToCoG,vehicleObj.FrontAxleToCoG;vehicleObj.CoGToRearAxle,vehicleObj.CoGToRearAxle];

Yaw = sum(Yaw_Wheel(1,:))-sum(Yaw_Wheel(2,:));

disp('Fz (lb): ');
>>>>>>> Stashed changes
disp(Fz);
disp('LLT_D: ');
disp(LLT_D);
disp('Roll Sensitivity: ');
disp(R_g);
disp('Roll Angle: ');
disp(Roll_Angle);
disp('Wheel Displacement: ');
disp(Z);