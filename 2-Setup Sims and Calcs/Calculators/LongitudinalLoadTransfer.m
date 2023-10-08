%% Longitudinal Load Transfer Test

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

K_t = [442 442; 442 442]; %lbf/in 
Tire_psi = 8;

% Acceleration Case = True, Deceleration Case = False
Accel = true;

% Test Velocity (mph)
Velocity = 0;

%% Calculations

% % Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

[polyfits] = LateralCoFSim(latTrainingData_P1,latTrainingData_P2);

if (Tire_psi == 8)
    polyCalc = polyfits(1,:);
end

if (Tire_psi == 10)
    polyCalc = polyfits(2,:);
end

if (Tire_psi == 12)
    polyCalc = polyfits(3,:);
end

if (Tire_psi == 14)
    polyCalc = polyfits(5,:);
end

% Static Weights at Velocity (lb) -> Max G's Possible on Entry
[Fz,LoLT,Accelmax,Z] = LoLTSim(0,Velocity,0,K_r,vehicleObj);

mu = [polyval(polyCalc,Fz(1,1)), polyval(polyCalc,Fz(1,2)); polyval(polyCalc,Fz(2,1)), polyval(polyCalc,Fz(2,2))];

if Accel == false
    Fx_max = mu.*Fz;
else
    Fx_max = -(mu.*Fz);
end

g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

if Accel == false
    Accelmaxprev = -g_avg;
else
    Accelmaxprev = mu(1,2)*(vehicleObj.FrontAxleToCoG/(vehicleObj.Wheelbase-(vehicleObj.CoGHeight*mu(1,2))));
end

% Dynamic Weights (lb) -> Max Fx from Weight Transfer
[Fz,LoLT,Accelmax,Z] = LoLTSim(g_avg,Velocity,Accelmaxprev,K_r,vehicleObj);

mu = [polyval(polyCalc,Fz(1,1)), polyval(polyCalc,Fz(1,2)); polyval(polyCalc,Fz(2,1)), polyval(polyCalc,Fz(2,2))];

if Accel == false
    Fx_max = mu.*Fz;
else
    Fx_max = -(mu.*Fz);
end

disp('Fz (lb): ');
disp(Fz);
disp('Max Fx (lb): ');
disp(Fx_max);
disp('Max Longitudinal Acceleration (Gs): ');
disp(Accelmaxprev);
disp('Wheel Displacement (in): ');
disp(Z);