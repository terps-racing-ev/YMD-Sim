%% Longitudinal Load Transfer Test

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

%% Tire Modeling

filename_P1 = 'A2356run8.mat';
[latTrainingData_P1,tireID,testID] = createLatTrngDataCalc(filename_P1);

filename_P2 = 'A2356run9.mat';
[latTrainingData_P2,tireID,testID] = createLatTrngDataCalc(filename_P2);

totData = cat(1,latTrainingData_P1,latTrainingData_P2);
trainData = latTrainingData_P1;

%% Inputs

% Acceleration Case = True, Deceleration Case = False
Accel = true;

% Test Velocity (mph)
Velocity = 0;

%% Calculations

% Tire Spring Rates (lbf/in)
[F_polyCalc_Kt,R_polyCalc_Kt] = SpringRateCalc(latTrainingData_P1,latTrainingData_P2,vehicleObj);

K_t = [F_polyCalc_Kt, F_polyCalc_Kt; R_polyCalc_Kt, R_polyCalc_Kt];

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

[F_polyCalc,R_polyCalc] = LateralCoFCalc(latTrainingData_P1,latTrainingData_P2,vehicleObj);

% Static Weights at Velocity (lb) -> Max G's Possible on Entry
[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity,0,K_r,vehicleObj);

mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];

[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity,0,K_r,vehicleObj);

if Accel == false
    Fx_max = [mu_F;mu_R].*Fz;
else
    Fx_max = -([mu_F;mu_R].*Fz);
end

disp('Max Static Fx (lb): ');
disp(round(Fx_max,3,"decimals"));

if Accel == false
    g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
else
    g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

    if (Accelmax_static < g_avg)
        g_avg = Accelmax_static;
    end
end

% Dynamic Weights (lb) -> Max Fx from Weight Transfer
[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity,g_avg,K_r,vehicleObj);

mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];

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
disp(round(Fz,3,"decimals"));
disp('Max Fx (lb): ');
disp(round(Fx_max,3,"decimals"));
disp('Longitudinal Acceleration (Gs): ');
disp(round(g_avg,3,"decimals"));
if Accel == true
    disp('Max Acceleration Possible (Car Limit) (Gs): ');
    disp(round(Accelmax_static,3,"decimals"));
end
disp('Pitch Angle (deg): ');
disp(round(Pitch_Angle,3,"decimals"));
disp('Wheel Displacement (in): ');
disp(round(Z,3,"decimals"));