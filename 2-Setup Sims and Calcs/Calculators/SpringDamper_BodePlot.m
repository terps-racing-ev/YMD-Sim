%% Spring and Damper w/ Bode Plot Calc

% This calculator uses the car's parameters to calculate various key
% values to determine the vadility of a given spring/shock setup

clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath(pwd + "\1-Input Functions");
vehicleObj = VehicleParameters();

% Adding StiffnessSim
addpath(pwd + "\2-Setup Sims and Calcs\Simulators");

%% Inputs

% Input Car Parameters (Matrix)
Weights = vehicleObj.staticWeights();

% Tire Stiffness for Fronts and Rears
K_t = [548 548; 548 548];%lbf/in 

% Input Test Spring Stiffness and Motion Ratios + Damper Settings
K_s = [200 200; 250 250]; %lbf/in
K_ARB = [0 0]; %lbf/in

MR_s = [0.5 0.5; 0.5 0.5];
MR_ARB = [0.5 0.5];


DampC_L = [8 8; 8 8]; %(lb-s)/in
DampC_H = [8 8; 8 8]; %(lb-s)/in

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r] = StiffnessSim(K_s,K_ARB,K_t,MR_s,MR_ARB);

% Natural Frequency (Hz)
NF = 386.4.*[(1/(2*pi))*(sqrt(K_r(1,1)/Weights(1,1))),(1/(2*pi))*(sqrt(K_r(1,2)/Weights(1,2)));
    (1/(2*pi))*(sqrt(K_r(2,1)/Weights(2,1))),(1/(2*pi))*(sqrt(K_r(2,2)/Weights(2,2)))];
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
DNF_L = 386.4.*[(1/(2*pi))*sqrt(K_r(1,1)/Weights(1,1))*sqrt(1-DR_L(1,1)^2) (1/(2*pi))*sqrt(K_r(1,2)/Weights(1,2))*sqrt(1-DR_L(1,2)^2);
    (1/(2*pi))*sqrt(K_r(2,1)/Weights(2,1))*sqrt(1-DR_L(2,1)^2) (1/(2*pi))*sqrt(K_r(2,2)/Weights(2,2))*sqrt(1-DR_L(2,2)^2)];
DNF_H = 386.4.*[(1/(2*pi))*sqrt(K_r(1,1)/Weights(1,1))*sqrt(1-DR_H(1,1)^2) (1/(2*pi))*sqrt(K_r(1,2)/Weights(1,2))*sqrt(1-DR_H(1,2)^2);
    (1/(2*pi))*sqrt(K_r(2,1)/Weights(2,1))*sqrt(1-DR_H(2,1)^2) (1/(2*pi))*sqrt(K_r(2,2)/Weights(2,2))*sqrt(1-DR_H(2,2)^2)];
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


%% Bode Plots

%FL
Gs_FLLow = tf([1],[1 2*DR_L(1,1)*NF(1,1) NF(1,1)^2]);
Gs_FLHigh = tf([1],[1 2*DR_H(1,1)*NF(1,1) NF(1,1)^2]);

%FR
Gs_FRLow = tf([1],[1 2*DR_L(1,2)*NF(1,2) NF(1,2)^2]);
Gs_FRHigh = tf([1],[1 2*DR_H(1,2)*NF(1,2) NF(1,2)^2]);

%RL
Gs_RLLow = tf([1],[1 2*DR_L(2,1)*NF(2,1) NF(2,1)^2]);
Gs_RLHigh = tf([1],[1 2*DR_H(2,1)*NF(2,1) NF(2,1)^2]);

%RR
Gs_RRLow = tf([1],[1 2*DR_L(2,2)*NF(2,2) NF(2,2)^2]);
Gs_RRHigh = tf([1],[1 2*DR_H(2,2)*NF(2,2) NF(2,2)^2]);

figure('Name','Bode Plot - Low Damper Settings');
bode(Gs_FLLow,'r-*',Gs_FRLow,'r-o',Gs_RLLow,'b-*',Gs_RRLow,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')

figure('Name','Bode Plot - High Damper Settings');
bode(Gs_FLHigh,'r-*',Gs_FRHigh,'r-o',Gs_RLHigh,'b-*',Gs_RRHigh,'b-o');
legend(' FL',' FR',' RL',' RR','Location','eastoutside')
