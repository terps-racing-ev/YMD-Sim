 %% YMD Test
% Credit - LJ Hamilton

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

%% Motor Parameters

Max_Velocity = 86; % mph

%% Inputs

VelocityInput = 0.1; % mph

SWAngle = 20; % deg (pos->Right, neg->Left)

BetaInput = 0; % deg (pos->Right, neg->Left)

Radius = 329; % in (pos->Right, neg->Left)

converge = false;

%% Calculations

    SA = [-13:1:13]'; %slip angle vector
    UCV = ones(size(SA)); %makes a unit column vector of the same length as the slip angle vector

    FzRange = [-50, -100, -150, -200, -250];
    mu_FLSweep = zeros(1,numel(FzRange));
    mu_FRSweep = zeros(1,numel(FzRange));
    mu_RLSweep = zeros(1,numel(FzRange));
    mu_RRSweep = zeros(1,numel(FzRange));

    % Maximum mu Sweep
    for i = 1:numel(FzRange)
        mu_FL = max(abs(Model_muyF.predictFcn([SA vehicle.Camber(1,1)*UCV FzRange(i)*UCV vehicle.TirePressure(1,1)*UCV])));
        mu_FR = max(abs(Model_muyF.predictFcn([SA vehicle.Camber(1,2)*UCV FzRange(i)*UCV vehicle.TirePressure(1,2)*UCV])));
        mu_RL = max(abs(Model_muyR.predictFcn([SA vehicle.Camber(2,1)*UCV FzRange(i)*UCV vehicle.TirePressure(2,1)*UCV])));
        mu_RR = max(abs(Model_muyR.predictFcn([SA vehicle.Camber(2,2)*UCV FzRange(i)*UCV vehicle.TirePressure(2,2)*UCV])));
        
        mu_FLSweep(1,i) = mu_FL;
        mu_FRSweep(1,i) = mu_FR;
        mu_RLSweep(1,i) = mu_RL;
        mu_RRSweep(1,i) = mu_RR;
    end

    polyFL = polyfit(log(FzRange),mu_FLSweep,1);
    polyFR = polyfit(log(FzRange),mu_FRSweep,1);
    polyRL = polyfit(log(FzRange),mu_RLSweep,1);
    polyRR = polyfit(log(FzRange),mu_RRSweep,1);

    mu_FLcalc = real(polyval(polyFL,log(Fz(1,1))));
    mu_FRcalc = real(polyval(polyFR,log(Fz(1,2))));
    mu_RLcalc = real(polyval(polyRL,log(Fz(2,1))));
    mu_RRcalc = real(polyval(polyRR,log(Fz(2,2))));

    mu = [mu_FLcalc, mu_FRcalc; mu_RLcalc, mu_RRcalc];