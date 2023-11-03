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

%% Tuned Car Parameters

% Tire Spring Rates (lbf/in)
[F_polyCalc_Kt,R_polyCalc_Kt] = SpringRateCalc(latTrainingData_P1,latTrainingData_P2,vehicleObj);

K_t = [F_polyCalc_Kt, F_polyCalc_Kt; R_polyCalc_Kt, R_polyCalc_Kt];

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

[F_polyCalc,R_polyCalc] = LateralCoFCalc(latTrainingData_P1,latTrainingData_P2,vehicleObj);

%% Motor Parameters

Max_Velocity = 86; %mph

%% Inputs

% DataPoints = 10;
% 
% % Velocity Sweep (mph)
% Velocity = linspace(0,Max_Velocity,DataPoints);

Velocity = 10;

KGradient = [];

% for i = 1:numel(Velocity)

    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity,0,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity,0,K_r,vehicleObj);
    
    [Calpha] = CstiffCalc(Fz,totData,vehicleObj);
    
    K = ((-2*vehicleObj.FrontStatic)/sum(Calpha(1,:)))-((-2*vehicleObj.RearStatic)/sum(Calpha(2,:)));

    % KGradient(1,i) = K;

% end

figure(1)
title('Understeer Gradient vs. Velocity (mph)')
hold on
xlabel('Velocity (mph)');
hold on
ylabel('Understeer Gradient');
hold on

plot(Velocity,K);
