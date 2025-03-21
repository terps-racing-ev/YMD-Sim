%% Spring and Damper w/ Bode Plot Calc

% This calculator uses the vehicle's parameters to calculate various key
% values to determine the vadility of a given spring/shock setup

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

% Input Test Spring Stiffness and Motion Ratios + Damper Settings
K_s = [200 200; 400 400]; %lbf/in
K_ARB = [250; 0]; %lbf/in

MR_s = [1 1; 1 1];
MR_ARB = [1; 1];

DampC_L = [12 12; 12 12];  %(lb-s)/in
DampC_H = [20 20; 20 20]; %(lb-s)/in

%% Calculations

% Stiffnesses (lbf/in)
%Kw
K_w = [(K_s(1,1)*(MR_s(1,1))^2)+(K_ARB(1,:)*(MR_ARB(1,:))^2),(K_s(1,2)*(MR_s(1,2))^2)+(K_ARB(1,:)*(MR_ARB(1,:))^2);
    (K_s(2,1)*(MR_s(2,1))^2)+(K_ARB(2,:)*(MR_ARB(2,:))^2),(K_s(2,2)*(MR_s(2,2))^2)+(K_ARB(2,:)*(MR_ARB(2,:))^2)];

%Kr
K_r = [(K_t(1,1)*K_w(1,1))/(K_t(1,1)+K_w(1,1)) (K_t(1,2)*K_w(1,2))/(K_t(1,2)+K_w(1,2));
    (K_t(2,1)*K_w(2,1))/(K_t(2,1)+K_w(2,1)) (K_t(2,2)*K_w(2,2))/(K_t(2,2)+K_w(2,2))];

%Kroll
Kroll = [(mean(K_r(1,:))*((vehicleObj.FrontTrackWidth^2)/2)); (mean(K_r(2,:))*((vehicleObj.RearTrackWidth^2)/2))]/57.3;

% Natural Frequency (Hz)
NF = [(1/(2*pi))*(sqrt((K_r(1,1)*386.4)/abs(vehicleObj.FrontStatic))),(1/(2*pi))*(sqrt((K_r(1,2)*386.4)/abs(vehicleObj.FrontStatic)));
    (1/(2*pi))*(sqrt((K_r(2,1)*386.4)/abs(vehicleObj.RearStatic))),(1/(2*pi))*(sqrt((K_r(2,2)*386.4)/abs(vehicleObj.RearStatic)))];
disp('Natural Frequency (Hz) = ');
disp(NF);

% Critical Damping (lb-s)/in
CD = [2*sqrt(K_r(1,1)*abs(vehicleObj.FrontStatic)/386.4),2*sqrt(K_r(1,1)*abs(vehicleObj.FrontStatic)/386.4);
    2*sqrt(K_r(1,1)*abs(vehicleObj.RearStatic)/386.4),2*sqrt(K_r(1,1)*abs(vehicleObj.RearStatic)/386.4)];

% Damping Ratio
DR_L = [DampC_L(1,1)/CD(1,1) DampC_L(1,2)/CD(1,2); DampC_L(2,1)/CD(2,1) DampC_L(2,2)/CD(2,2)];
DR_H = [DampC_H(1,1)/CD(1,1) DampC_H(1,2)/CD(1,2); DampC_H(2,1)/CD(2,1) DampC_H(2,2)/CD(2,2)];
disp('Damping Ratio - Low = ');
disp(DR_L);
disp('Damping Ratio - High = ');
disp(DR_H);

% Damped Natural Frequency (Hz)
DNF_L = [(1/(2*pi))*sqrt((K_r(1,1)*386.4)/abs(vehicleObj.FrontStatic))*sqrt(1-DR_L(1,1)^2) (1/(2*pi))*sqrt((K_r(1,2)*386.4)/abs(vehicleObj.FrontStatic))*sqrt(1-DR_L(1,2)^2);
    (1/(2*pi))*sqrt((K_r(2,1)*386.4)/abs(vehicleObj.RearStatic))*sqrt(1-DR_L(2,1)^2) (1/(2*pi))*sqrt((K_r(2,2)*386.4)/abs(vehicleObj.RearStatic))*sqrt(1-DR_L(2,2)^2)];
DNF_H = [(1/(2*pi))*sqrt((K_r(1,1)*386.4)/abs(vehicleObj.FrontStatic))*sqrt(1-DR_H(1,1)^2) (1/(2*pi))*sqrt((K_r(1,2)*386.4)/abs(vehicleObj.FrontStatic))*sqrt(1-DR_H(1,2)^2);
    (1/(2*pi))*sqrt((K_r(2,1)*386.4)/abs(vehicleObj.RearStatic))*sqrt(1-DR_H(2,1)^2) (1/(2*pi))*sqrt((K_r(2,2)*386.4)/abs(vehicleObj.RearStatic))*sqrt(1-DR_H(2,2)^2)];
disp('Damped Natural Frequency - Low (Hz)= ');
disp(DNF_L);
disp('Damped Natural Frequency - High (Hz)= ');
disp(DNF_H);

% Natural Frequency Range - Rear (Hz)
NF10 = [1.1.*DNF_L(1,:); 1.1.*DNF_H(1,:)];
NF20 = [1.2.*DNF_L(1,:); 1.2.*DNF_H(1,:)];

disp('Rear Damped Natural Frequency F:10% L-H (Hz) = ');
disp(NF10);
disp('Rear Damped Natural Frequency F:20% L-H (Hz) = ');
disp(NF20);


%% Plots for Analysis

%FL
Gs_FLLow = tf(NF(1,1)^2,[1 2*DR_L(1,1)*NF(1,1) NF(1,1)^2]);
Gs_FLHigh = tf(NF(1,1)^2,[1 2*DR_H(1,1)*NF(1,1) NF(1,1)^2]);

%FR
Gs_FRLow = tf(NF(1,2)^2,[1 2*DR_L(1,2)*NF(1,2) NF(1,2)^2]);
Gs_FRHigh = tf(NF(1,2)^2,[1 2*DR_H(1,2)*NF(1,2) NF(1,2)^2]);

%RL
Gs_RLLow = tf(NF(2,1)^2,[1 2*DR_L(2,1)*NF(2,1) NF(2,1)^2]);
Gs_RLHigh = tf(NF(2,1)^2,[1 2*DR_H(2,1)*NF(2,1) NF(2,1)^2]);

%RR
Gs_RRLow = tf(NF(2,2)^2,[1 2*DR_L(2,2)*NF(2,2) NF(2,2)^2]);
Gs_RRHigh = tf(NF(2,2)^2,[1 2*DR_H(2,2)*NF(2,2) NF(2,2)^2]);

figure('Name','Plots - Low Damper Settings');
subplot(2,2,1);
step(Gs_FLLow,'r-*',Gs_FRLow,'r-o',Gs_RLLow,'b-*',Gs_RRLow,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

subplot(2,2,2);
impulse(Gs_FLLow,'r-*',Gs_FRLow,'r-o',Gs_RLLow,'b-*',Gs_RRLow,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

subplot(2,2,3);
rlocus(Gs_FLLow,'r',Gs_FRLow,'r',Gs_RLLow,'b',Gs_RRLow,'b');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

subplot(2,2,4);
bode(Gs_FLLow,'r-*',Gs_FRLow,'r-o',Gs_RLLow,'b-*',Gs_RRLow,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

figure('Name','Plots - High Damper Settings');
subplot(2,2,1);
step(Gs_FLHigh,'r-*',Gs_FRHigh,'r-o',Gs_RLHigh,'b-*',Gs_RRHigh,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

subplot(2,2,2);
impulse(Gs_FLHigh,'r-*',Gs_FRHigh,'r-o',Gs_RLHigh,'b-*',Gs_RRHigh,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

subplot(2,2,3);
rlocus(Gs_FLHigh,'r',Gs_FRHigh,'r',Gs_RLHigh,'b',Gs_RRHigh,'b');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

subplot(2,2,4);
bode(Gs_FLHigh,'r-*',Gs_FRHigh,'r-o',Gs_RLHigh,'b-*',Gs_RRHigh,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

