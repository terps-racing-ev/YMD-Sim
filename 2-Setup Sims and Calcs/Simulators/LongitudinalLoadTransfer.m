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

% Input Front and Rear Tire Data
% Front
filename_P1F = 'A2356run8.mat';
[latTrainingData_P1F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P1F);

filename_P2F = 'A2356run9.mat';
[latTrainingData_P2F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P2F);

totDataF = cat(1,latTrainingData_P1F,latTrainingData_P2F);
trainDataF = totDataF;

% Rear
filename_P1FR = 'A2356run8.mat';
[latTrainingData_P1FR,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P1FR);

filename_P2FR = 'A2356run9.mat';
[latTrainingData_P2FR,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P2FR);

totDataR = cat(1,latTrainingData_P1FR,latTrainingData_P2FR);
trainDataR = totDataR;

% Front tires
disp([tire.IDF, ', Front Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainDataF);
[model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainDataF);
[model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainDataF);
% [model.muxFront, validation.RMSE_muxFront] = Trainer_mux(trainDataF);
% [model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainDataF);
toc(t1)

disp('Training completed')

% Rear tires
disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
[model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
[model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
% [model.muxRear, validation.RMSE_muxRear] = Trainer_mux(trainDataR);
% [model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
toc(t1)

disp('Training completed')

%% Tuned Car Parameters

% Tire Spring Rates (lbf/in)
[K_t] = SpringRateCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicleObj);

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

[F_polyCalc,R_polyCalc] = LateralCoFCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicleObj);

%% Inputs

% Acceleration Case = True, Deceleration Case = False
Accel = false;

% Test Velocity (mph)
Velocity = 10;

%% Calculations

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