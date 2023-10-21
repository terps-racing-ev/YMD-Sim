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

F_Tire_psi = vehicleObj.TirePressure(1,1);
R_Tire_psi = vehicleObj.TirePressure(2,1);

F_camber = vehicleObj.Camber(1,1);
R_camber = vehicleObj.Camber(2,1);

[polyfits0I,polyfits2I,polyfits4I] = SpringRateCalc(latTrainingData_P1,latTrainingData_P2);

% Front Spring Rate Calculator
if (F_Tire_psi == 8 && F_camber == 0)
    F_polyCalc = polyfits0I(1,:);
end

if (F_Tire_psi == 10 && F_camber == 0)
    F_polyCalc = polyfits0I(2,:);
end

if (F_Tire_psi == 12 && F_camber == 0)
    F_polyCalc = polyfits0I(3,:);
end

if (F_Tire_psi == 14 && F_camber == 0)
    F_polyCalc = polyfits0I(5,:);
end

if (F_Tire_psi == 8 && F_camber == 2)
    F_polyCalc = polyfits2I(1,:);
end

if (F_Tire_psi == 10 && F_camber == 2)
    F_polyCalc = polyfits2I(2,:);
end

if (F_Tire_psi == 12 && F_camber == 2)
    F_polyCalc = polyfits2I(3,:);
end

if (F_Tire_psi == 14 && F_camber == 2)
    F_polyCalc = polyfits2I(5,:);
end

if (F_Tire_psi == 8 && F_camber == 4)
    F_polyCalc = polyfits4I(1,:);
end

if (F_Tire_psi == 10 && F_camber == 4)
    F_polyCalc = polyfits4I(2,:);
end

if (F_Tire_psi == 12 && F_camber == 4)
    F_polyCalc = polyfits4I(3,:);
end

if (F_Tire_psi == 14 && F_camber == 4)
    F_polyCalc = polyfits4I(5,:);
end

% Rear Spring Rate Calculator
if (R_Tire_psi == 8 && R_camber == 0)
    R_polyCalc = polyfits0I(1,:);
end

if (R_Tire_psi == 10 && R_camber == 0)
    R_polyCalc = polyfits0I(2,:);
end

if (R_Tire_psi == 12 && R_camber == 0)
    R_polyCalc = polyfits0I(3,:);
end

if (R_Tire_psi == 14 && R_camber == 0)
    R_polyCalc = polyfits0I(5,:);
end

if (R_Tire_psi == 8 && R_camber == 2)
    R_polyCalc = polyfits2I(1,:);
end

if (R_Tire_psi == 10 && R_camber == 2)
    R_polyCalc = polyfits2I(2,:);
end

if (R_Tire_psi == 12 && R_camber == 2)
    R_polyCalc = polyfits2I(3,:);
end

if (R_Tire_psi == 14 && R_camber == 2)
    R_polyCalc = polyfits2I(5,:);
end

if (R_Tire_psi == 8 && R_camber == 4)
    R_polyCalc = polyfits4I(1,:);
end

if (R_Tire_psi == 10 && R_camber == 4)
    F_polyCalc = polyfits4I(2,:);
end

if (R_Tire_psi == 12 && R_camber == 4)
    F_polyCalc = polyfits4I(3,:);
end

if (R_Tire_psi == 14 && R_camber == 4)
    R_polyCalc = polyfits4I(5,:);
end

K_t = [F_polyCalc, F_polyCalc; R_polyCalc, R_polyCalc];

% Right Turn = True, Left Turn = False
RightTurn = true;

% Test Velocity (0 mph & Right Turn = Tilt Test)
Velocity = 25;

Radius = 348; %in

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

[polyfits] = LateralCoFCalc(latTrainingData_P1,latTrainingData_P2);

if (F_Tire_psi == 8)
    F_polyCalc = polyfits(1,:);
end

if (F_Tire_psi == 10)
    F_polyCalc = polyfits(2,:);
end

if (F_Tire_psi == 12)
    F_polyCalc = polyfits(3,:);
end

if (F_Tire_psi == 14)
    F_polyCalc = polyfits(5,:);
end

if (R_Tire_psi == 8)
    R_polyCalc = polyfits(1,:);
end

if (R_Tire_psi == 10)
    R_polyCalc = polyfits(2,:);
end

if (R_Tire_psi == 12)
    R_polyCalc = polyfits(3,:);
end

if (R_Tire_psi == 14)
    R_polyCalc = polyfits(5,:);
end

% Static Weights at Velocity (lb) -> Max G's Possible on Entry
[Fz,LoLT,Accelmax,Z] = LoLTCalc(0,Velocity,0,K_r,vehicleObj);

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
CornerSpeed = sqrt(((abs(sum(reshape(Fy_max,[1,4]))))/(vehicleObj.TotalWeight/32.2))*(Radius/12))/1.467;

% Dynamic Weights (lb) -> Max Fy from Weight Transfer
[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_roll,Velocity,mu_drive,vehicleObj);

mu = [mu_F,mu_R];

mu_F = [polyval(F_polyCalc,Fz(1,1)), polyval(F_polyCalc,Fz(1,2))];
mu_R = [polyval(R_polyCalc,Fz(2,1)), polyval(R_polyCalc,Fz(2,2))];

if RightTurn == true
    Fy_max = -([mu_F;mu_R].*Fz);
else
    Fy_max = [mu_F;mu_R].*Fz;
end

g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

% Rough Yaw Calculator
Yaw_Wheel = Fy_max.*[vehicleObj.FrontAxleToCoG,vehicleObj.FrontAxleToCoG;vehicleObj.CoGToRearAxle,vehicleObj.CoGToRearAxle];

Yaw = sum(Yaw_Wheel(1,:))-sum(Yaw_Wheel(2,:));

disp('Fz (lb): ');
disp(Fz);
disp('Max Fy (lb): ');
disp(Fy_max);
disp('Yaw Moment (lb*in):');
disp(Yaw);
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