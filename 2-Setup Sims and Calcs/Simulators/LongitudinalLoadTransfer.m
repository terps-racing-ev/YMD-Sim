%% Longitudinal Load Transfer Test

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
<<<<<<< HEAD
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

K_t = [442 442; 442 442]; %lbf/in 
Tire_psi = 8;

% Acceleration Case = True, Deceleration Case = False
Accel = true;

% Test Velocity (mph)
Velocity = 0;

%% Calculations

% % Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

[polyfits] = LateralCoFCalc(latTrainingData_P1,latTrainingData_P2);

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
[Fz,LoLT,Accelmax,Z] = LoLTCalc(0,Velocity,0,K_r,vehicleObj);

mu = [polyval(polyCalc,Fz(1,1)), polyval(polyCalc,Fz(1,2)); polyval(polyCalc,Fz(2,1)), polyval(polyCalc,Fz(2,2))];
=======

% Adding Tire Models
addpath([currentFolder, filesep, '1-Input Functions', filesep, 'Tire Modeling']);

% Adding Additional Calculators
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Calculators']);

% Adding Additional Similators
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

% Adding Reference Files
addpath([currentFolder, filesep, 'Reference Files\']);

vehicleObj = TREV2ParametersV2();

%% Tire Modeling

% Hoosier 16x7.5-10 R20 (8 in Rim)

% Input Front and Rear Tire Data
% Front
filename_P1F = 'A2356run8.mat';
[latTrainingData_P1F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P1F);

filename_P2F = 'A2356run9.mat';
[latTrainingData_P2F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P2F);

totDataF = cat(1,latTrainingData_P1F,latTrainingData_P2F);
trainDataF = totDataF;

% Rear
filename_P1R = 'A2356run8.mat';
[latTrainingData_P1R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P1R);

filename_P2R = 'A2356run9.mat';
[latTrainingData_P2R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P2R);

totDataR = cat(1,latTrainingData_P1R,latTrainingData_P2R);
trainDataR = totDataR;

% Front tires
disp([tire.IDF, ', Front Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainDataF);
[model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainDataF);
[model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainDataF);
[model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainDataF);
toc(t1)

disp('Training completed')

% Rear tires
disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
[model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
[model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
[model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
toc(t1)

disp('Training completed')

%% Tuned Car Parameters

% Tire Spring Rates (lbf/in)
[K_t] = SpringRateCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicleObj);

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

%% Inputs

% Acceleration Case = True, Deceleration Case = False
Accel = false;

% Test Velocity (mph)
Velocity = 86;

format longG

%% Calculations

% Static Weights at Velocity (lb) -> Max G's Possible on Entry
[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity,0,K_r,vehicleObj);

[IA] = CamberCalc(Z,0,0,vehicleObj);

[mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity,0,K_r,vehicleObj);
>>>>>>> main

if Accel == false
    Fx_max = mu.*Fz;
else
    Fx_max = -(mu.*Fz);
end

<<<<<<< HEAD
g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

if Accel == false
    Accelmaxprev = -g_avg;
else
    Accelmaxprev = mu(1,2)*(vehicleObj.FrontAxleToCoG/(vehicleObj.Wheelbase-(vehicleObj.CoGHeight*mu(1,2))));
end

% Dynamic Weights (lb) -> Max Fx from Weight Transfer
[Fz,LoLT,Accelmax,Z] = LoLTCalc(g_avg,Velocity,Accelmaxprev,K_r,vehicleObj);

mu = [polyval(polyCalc,Fz(1,1)), polyval(polyCalc,Fz(1,2)); polyval(polyCalc,Fz(2,1)), polyval(polyCalc,Fz(2,2))];
=======
disp('Max Static Fx (lb): ');
disp(round(Fx_max,4,"decimals"));

if Accel == false
    g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
else
    g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

    if (Accelmax_static < g_avg)
        g_avg = Accelmax_static;
    end
end

% Dynamic Weights (lb) -> Max Fx from Weight Transfer
[Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity,g_avg,K_r,vehicleObj);

[IA] = CamberCalc(Z,0,0,vehicleObj);

[mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);
>>>>>>> main

if Accel == false
    Fx_max = mu.*Fz;
else
    Fx_max = -(mu.*Fz);
end

<<<<<<< HEAD
disp('Fz (lb): ');
disp(Fz);
disp('Max Fx (lb): ');
disp(Fx_max);
disp('Max Longitudinal Acceleration (Gs): ');
disp(Accelmaxprev);
disp('Wheel Displacement (in): ');
disp(Z);
=======
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
disp(round(Fz,4,"decimals"));
disp('Max Fx (lb): ');
disp(round(Fx_max,4,"decimals"));
disp('Longitudinal Acceleration (Gs): ');
disp(round(g_avg,4,"decimals"));
disp('Max Acceleration Possible (Car Limit) (Gs): ');
disp(round(Accelmax_static,4,"decimals"));
disp('Pitch Angle (deg): ');
disp(round(Pitch_Angle,4,"decimals"));
disp('Camber (deg): ');
disp(round(IA,4,"decimals"));
disp('Wheel Displacement (in): ');
disp(round(Z,4,"decimals"));
>>>>>>> main
