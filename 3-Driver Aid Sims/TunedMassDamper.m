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
FrontStatic = vehicleObj.FrontStatic();
K_sF = [vehicleObj.K_s(1,1) vehicleObj.K_s(1,2)];

% Spring Rates (lbf/in)
K_top = 10;
K_bottom = 10;
K_sTMDeq = K_top + K_bottom;

K_sFeq = sum(K_sF);

% TMD Mass (lb)
TMD_Weight = 5;

F_Weight = FrontStatic;

% Damping Coefficient (lb-s)/in
mu_c = 22*0.00155; %in^2/s
r = 8; %in
A = pi*r^2; %in^2
h = 10; %in

DampC_TMD = (mu_c*A)/h;

DampC_FLow = 20;
DampC_FHigh = 20;

%% Calculations

% Natural Frequency (Hz)
NF_TMD = (1/(2*pi))*(sqrt((K_sTMDeq*386.4)/TMD_Weight));
NF_F = (1/(2*pi))*(sqrt((K_sFeq*386.4)/F_Weight));
disp('Natural Frequency - TMD (Hz) = ');
disp(NF_TMD);
disp('Natural Frequency - Front (Hz) = ');
disp(NF_F);

% Critical Damping (lb-s)/in
CD_TMD = 2*sqrt(K_sTMDeq*TMD_Weight/386.4);
CD_F = 2*sqrt(K_sFeq*F_Weight/386.4);

% Damping Ratio
DR_TMD = DampC_TMD/CD_TMD;
DR_FLow = DampC_FLow/CD_F;
DR_FHigh = DampC_FHigh/CD_F;
disp('Damping Ratio - TMD = ');
disp(DR_TMD);
disp('Damping Ratio - Front (Low) = ');
disp(DR_FLow);
disp('Damping Ratio - Front (High) = ');
disp(DR_FHigh);

% Damped Natural Frequency (Hz)
DNF_TMD = (1/(2*pi))*sqrt((K_sTMDeq*386.4)/TMD_Weight)*sqrt(1-DR_TMD^2);
DNF_FLow = (1/(2*pi))*sqrt((K_sFeq*386.4)/F_Weight)*sqrt(1-DR_FLow^2);
DNF_FHigh = (1/(2*pi))*sqrt((K_sFeq*386.4)/F_Weight)*sqrt(1-DR_FHigh^2);
disp('Damped Natural Frequency - TMD (Hz)= ');
disp(DNF_TMD);
disp('Damped Natural Frequency - Front (Low) (Hz)= ');
disp(DNF_FLow);
disp('Damped Natural Frequency - Front (High) (Hz)= ');
disp(DNF_FHigh);

%% Bode Plots

%TMD
Gs_TMD = tf([1],[1 2*DR_TMD(1,1)*NF_TMD(1,1) NF_TMD(1,1)^2]);
%Front (Low)
Gs_FLow = tf([1],[1 2*DR_FLow(1,1)*NF_F(1,1) NF_F(1,1)^2]);
%Front (High)
Gs_FHigh = tf([1],[1 2*DR_FHigh(1,1)*NF_F(1,1) NF_F(1,1)^2]);

figure('Name','Step Response Plot - TMD Settings');
step(Gs_TMD,'r-.');
figure('Name','Step Response Plot - Front (Low) Settings');
step(Gs_FLow,'r-*');
figure('Name','Step Response Plot - Front (High) Settings');
step(Gs_FHigh,'r-*');
figure('Name','Step Response Plot - Combined (Low) Settings');
step(Gs_FLow-Gs_TMD,'r-*');
figure('Name','Step Response Plot - Combined (High) Settings');
step(Gs_FHigh-Gs_TMD,'r-*');