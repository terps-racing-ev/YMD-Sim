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

% Acceleration Case = True, Deceleration Case = False
Accel = false;

% Test Velocity (mph)
Velocity = 10;

%% Calculations

% Tire Spring Rates (lbf/in)
[F_polyCalc_Kt,R_polyCalc_Kt] = SpringRateSim(latTrainingData_P1,latTrainingData_P2,vehicleObj);

K_t = [F_polyCalc_Kt, F_polyCalc_Kt; R_polyCalc_Kt, R_polyCalc_Kt];

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

[F_polyCalc,R_polyCalc] = LateralCoFSim(latTrainingData_P1,latTrainingData_P2,vehicleObj);

% Static Weights at Velocity (lb) -> Max G's Possible on Entry
[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTSim(0,Velocity,0,K_r,vehicleObj);

mu_F = [polyval(F_polyCalc,Fz(1,1)), polyval(F_polyCalc,Fz(1,2))];
mu_R = [polyval(R_polyCalc,Fz(2,1)), polyval(R_polyCalc,Fz(2,2))];

[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTSim(mean(mu_R),Velocity,0,K_r,vehicleObj);

if Accel == false
    Fx_max = [mu_F;mu_R].*Fz;
else
    Fx_max = -([mu_F;mu_R].*Fz);
end

disp('Max Static Fx (lb): ');
disp(Fx_max);

if Accel == false
    g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
else
    g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

    if (Accelmax_static < g_avg)
        g_avg = Accelmax_static;
    end
end

% Dynamic Weights (lb) -> Max Fx from Weight Transfer
[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTSim(mean(mu_R),Velocity,g_avg,K_r,vehicleObj);

mu_F = [polyval(F_polyCalc,Fz(1,1)), polyval(F_polyCalc,Fz(1,2))];
mu_R = [polyval(R_polyCalc,Fz(2,1)), polyval(R_polyCalc,Fz(2,2))];

if Accel == false
    Fx_max = [mu_F;mu_R].*Fz;
else
    Fx_max = -([mu_F;mu_R].*Fz);
end

if Accel == false
    g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
else
    g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

    if (Accelmax_static < g_avg)
        g_avg = Accelmax_static;
    end
end

disp('---------------');
disp('Fz (lb): ');
disp(Fz);
disp('Max Fx (lb): ');
disp(Fx_max);
disp('Longitudinal Acceleration (Gs): ');
disp(g_avg);
disp('Max Acceleration Possible (Car Limit) (Gs): ');
disp(Accelmax_static);
disp('Pitch Angle (deg): ');
disp(Pitch_Angle);
disp('Wheel Displacement (in): ');
disp(Z);