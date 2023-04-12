%% Tuned Mass Damper Calculations

% This calculator uses TMD parameters to calculate movement effects of
% such a system on the front or rear of the car

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = TREV2Parameters();

% Adding Tire Models
addpath([currentFolder, filesep, '1-Input Functions', filesep, 'Tire Modeling']);

% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs

% Input Car Parameters
K_sF = [vehicleObj.K_s(1,1) vehicleObj.K_s(1,2)];
MR_sF = [vehicleObj.MR_s(1,1) vehicleObj.MR_s(1,2)];
K_ARBF = vehicleObj.K_ARB(1,:);
MR_ARBF = vehicleObj.MR_ARB(1,:);
Weights = vehicleObj.staticWeights();
DampC_FLow = [vehicleObj.DampC_Low(1,1) vehicleObj.DampC_Low(1,2)];
DampC_FHigh = [vehicleObj.DampC_High(1,1) vehicleObj.DampC_High(1,2)];

K_t = [548 548; 548 548];

% TMD Spring Rates (lbf/in)
K_top = 50;
K_bottom = 50;
K_sTMDeq = K_top + K_bottom;

% TMD Mass (lb)
TMD_Weight = 25;

% Damping Coefficient (lb-s)/in
mu_c = 22*0.00155; %in^2/s
r = 8; %in
A = pi*r^2; %in^2
h = 5; %in

DampC_TMD = (mu_c*A)/h;

%% Calculations

% Stiffnesses (lbf/in)
%Kw
K_w = [(K_sF(1,1)*(MR_sF(1,1))^2)+(K_ARBF(1,:)*(MR_ARBF(1,:))^2),(K_sF(1,2)*(MR_sF(1,2))^2)+(K_ARBF(1,:)*(MR_ARBF(1,:))^2)];

%Kr
K_r = [(K_t(1,1)*K_w(1,1))/(K_t(1,1)+K_w(1,1)) (K_t(1,2)*K_w(1,2))/(K_t(1,2)+K_w(1,2))];

% Natural Frequency (Hz)
NF_TMD = (1/(2*pi))*(sqrt((K_sTMDeq*386.4)/TMD_Weight));
NF_FL = (1/(2*pi))*(sqrt((K_r(1,1)*386.4)/Weights(1,1)));
NF_FR = (1/(2*pi))*(sqrt((K_r(1,2)*386.4)/Weights(1,2)));
disp('Natural Frequency - TMD (Hz) = ');
disp(NF_TMD);
disp('Natural Frequency - FL (Hz) = ');
disp(NF_FL);
disp('Natural Frequency - FR (Hz) = ');
disp(NF_FR);

% Critical Damping (lb-s)/in
CD_TMD = 2*sqrt(K_sTMDeq*TMD_Weight/386.4);
CD_FL = 2*sqrt(K_r(1,1)*Weights(1,1)/386.4);
CD_FR = 2*sqrt(K_r(1,2)*Weights(1,2)/386.4);

% Damping Ratio
DR_TMD = DampC_TMD/CD_TMD;
DR_FLLow = DampC_FLow(1,1)/CD_FL;
DR_FLHigh = DampC_FHigh(1,1)/CD_FL;
DR_FRLow = DampC_FLow(1,2)/CD_FR;
DR_FRHigh = DampC_FHigh(1,2)/CD_FR;
disp('Damping Ratio - TMD = ');
disp(DR_TMD);
disp('Damping Ratio - Low = ');
disp([DR_FLLow DR_FRLow]);
disp('Damping Ratio - High = ');
disp([DR_FLHigh DR_FRHigh]);

% Damped Natural Frequency (Hz)
DNF_TMD = (1/(2*pi))*sqrt((K_sTMDeq*386.4)/TMD_Weight)*sqrt(1-DR_TMD^2);
DNF_FLLow = (1/(2*pi))*sqrt((K_sF(1,1)*386.4)/Weights(1,1))*sqrt(1-DR_FLLow^2);
DNF_FLHigh = (1/(2*pi))*sqrt((K_sF(1,1)*386.4)/Weights(1,1))*sqrt(1-DR_FLHigh^2);
DNF_FRLow = (1/(2*pi))*sqrt((K_sF(1,2)*386.4)/Weights(1,2))*sqrt(1-DR_FRLow^2);
DNF_FRHigh = (1/(2*pi))*sqrt((K_sF(1,2)*386.4)/Weights(1,2))*sqrt(1-DR_FRHigh^2);
disp('Damped Natural Frequency - TMD (Hz)= ');
disp(DNF_TMD);
disp('Damped Natural Frequency - Low (Hz)= ');
disp([DNF_FLLow DNF_FRLow]);
disp('Damped Natural Frequency - High (Hz)= ');
disp([DNF_FLHigh DNF_FRHigh]);

%% Bode Plots

%TMD
Gs_TMD = tf([1],[1 2*DR_TMD(1,1)*NF_TMD(1,1) NF_TMD(1,1)^2]);
%FL (Low)
Gs_FLLow = tf([1],[1 2*DR_FLLow(1,1)*NF_FL(1,1) NF_FL(1,1)^2]);
%FL (High)
Gs_FLHigh = tf([1],[1 2*DR_FLHigh(1,1)*NF_FL(1,1) NF_FL(1,1)^2]);
%FR (Low)
Gs_FRLow = tf([1],[1 2*DR_FRLow(1,1)*NF_FR(1,1) NF_FR(1,1)^2]);
%FR (High)
Gs_FRHigh = tf([1],[1 2*DR_FRHigh(1,1)*NF_FR(1,1) NF_FR(1,1)^2]);

FStepConfig = stepDataOptions('StepAmplitude',(5*Weights(1,1))/386.4);

% Step Response
% figure('Name','Step Response Plot - TMD Settings');
% step(Gs_TMD,'r-.');
figure('Name','Step Response Plot - Low Settings');
step(Gs_FLLow,'r-*',Gs_FRLow,'r-o',FStepConfig);
figure('Name','Step Response Plot - High Settings');
step(Gs_FLHigh,'r-*',Gs_FRHigh,'r-o',FStepConfig);
legend(' FL',' FR','Location','eastoutside')

figure('Name','Step Response Plot - TMD Effects (Low) Settings');
step(Gs_FLLow-Gs_TMD,'r-*',Gs_FRLow-Gs_TMD,'r-o',FStepConfig);
figure('Name','Step Response Plot - TMD Effects (High) Settings');
step(Gs_FLHigh-Gs_TMD,'r-*',Gs_FRHigh-Gs_TMD,'r-o',FStepConfig);
legend(' FL',' FR','Location','eastoutside')

% Impulse Response
figure('Name','Impulse Response Plot - Low Settings');
impulse(Gs_FLLow,'r-*',Gs_FRLow,'r-o');
figure('Name','Impulse Response Plot - High Settings');
impulse(Gs_FLHigh,'r-*',Gs_FRHigh,'r-o');
legend(' FL',' FR','Location','eastoutside')

figure('Name','Impulse Response Plot - TMD Effects (Low) Settings');
impulse(Gs_FLLow-Gs_TMD,'r-*',Gs_FRLow-Gs_TMD,'r-o');
figure('Name','Impulse Response Plot - TMD Effects (High) Settings');
impulse(Gs_FLHigh-Gs_TMD,'r-*',Gs_FRHigh-Gs_TMD,'r-o');
legend(' FL',' FR','Location','eastoutside')