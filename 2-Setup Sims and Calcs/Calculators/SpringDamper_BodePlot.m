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
vehicleObj = TREV1Parameters();

% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs

% Input Car Parameters
Weights = vehicleObj.staticWeights();
TrackWidth = vehicleObj.TrackWidth;

% Tire Stiffness for Fronts and Rears
K_t = [635 635; 635 635]; %lbf/in 

% Input Test Spring Stiffness and Motion Ratios + Damper Settings
K_s = [200 200; 450 450]; %lbf/in
K_ARB = [0; 667]; %lbf/in

MR_s = [0.9 0.9; 0.5 0.5];
MR_ARB = [0.5; 0.5];

DampC_L = [12 12; 14 14];  %(lb-s)/in
DampC_H = [12 12; 14 14]; %(lb-s)/in

%% Calculations

% Stiffnesses (lbf/in)
%Kw
K_w = [(K_s(1,1)*(MR_s(1,1))^2)+(K_ARB(1,:)*(MR_ARB(1,:))^2),(K_s(1,2)*(MR_s(1,2))^2)+(K_ARB(1,:)*(MR_ARB(1,:))^2);
    (K_s(2,1)*(MR_s(2,1))^2)+(K_ARB(2,:)*(MR_ARB(2,:))^2),(K_s(2,2)*(MR_s(2,2))^2)+(K_ARB(2,:)*(MR_ARB(2,:))^2)];

%Kr
K_r = [(K_t(1,1)*K_w(1,1))/(K_t(1,1)+K_w(1,1)) (K_t(1,2)*K_w(1,2))/(K_t(1,2)+K_w(1,2));
    (K_t(2,1)*K_w(2,1))/(K_t(2,1)+K_w(2,1)) (K_t(2,2)*K_w(2,2))/(K_t(2,2)+K_w(2,2))];

% Natural Frequency (Hz)
NF = [(1/(2*pi))*(sqrt((K_r(1,1)*386.4)/Weights(1,1))),(1/(2*pi))*(sqrt((K_r(1,2)*386.4)/Weights(1,2)));
    (1/(2*pi))*(sqrt((K_r(2,1)*386.4)/Weights(2,1))),(1/(2*pi))*(sqrt((K_r(2,2)*386.4)/Weights(2,2)))];
disp('Natural Frequency (Hz) = ');
disp(NF);

% Critical Damping (lb-s)/in
CD = [2*sqrt(K_r(1,1)*Weights(1,1)/386.4),2*sqrt(K_r(1,1)*Weights(1,2)/386.4);
    2*sqrt(K_r(1,1)*Weights(2,1)/386.4),2*sqrt(K_r(1,1)*Weights(2,2)/386.4)];

% Damping Ratio
DR_L = [DampC_L(1,1)/CD(1,1) DampC_L(1,2)/CD(1,2); DampC_L(2,1)/CD(2,1) DampC_L(2,2)/CD(2,2)];
DR_H = [DampC_H(1,1)/CD(1,1) DampC_H(1,2)/CD(1,2); DampC_H(2,1)/CD(2,1) DampC_H(2,2)/CD(2,2)];
disp('Damping Ratio - Low = ');
disp(DR_L);
disp('Damping Ratio - High = ');
disp(DR_H);

% Damped Natural Frequency (Hz)
DNF_L = [(1/(2*pi))*sqrt((K_r(1,1)*386.4)/Weights(1,1))*sqrt(1-DR_L(1,1)^2) (1/(2*pi))*sqrt((K_r(1,2)*386.4)/Weights(1,2))*sqrt(1-DR_L(1,2)^2);
    (1/(2*pi))*sqrt((K_r(2,1)*386.4)/Weights(2,1))*sqrt(1-DR_L(2,1)^2) (1/(2*pi))*sqrt((K_r(2,2)*386.4)/Weights(2,2))*sqrt(1-DR_L(2,2)^2)];
DNF_H = [(1/(2*pi))*sqrt((K_r(1,1)*386.4)/Weights(1,1))*sqrt(1-DR_H(1,1)^2) (1/(2*pi))*sqrt((K_r(1,2)*386.4)/Weights(1,2))*sqrt(1-DR_H(1,2)^2);
    (1/(2*pi))*sqrt((K_r(2,1)*386.4)/Weights(2,1))*sqrt(1-DR_H(2,1)^2) (1/(2*pi))*sqrt((K_r(2,2)*386.4)/Weights(2,2))*sqrt(1-DR_H(2,2)^2)];
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

