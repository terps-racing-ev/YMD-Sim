%% Ride Modeling - Spring and Damper Setup

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

% Input Test Spring Stiffness and Motion Ratios + Damper Settings
K_s = [300 300; 350 350]; %lbf/in
K_ARB = [0; 0]; %lbf/in

MR_s = [1 1; 1 1];
MR_ARB = [1; 1];

DampC_L = [24 24; 24 24];  %(lb-s)/in
DampC_H = [18 18; 18 18]; %(lb-s)/in

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


%Stiffness Conversion (lbf/ft)
K_uconv = K_t.*12;
K_sconv = K_w.*12;

%Mass Conversion (slugs)
SprungMF = vehicleObj.FrontSprungWeight/32.2;
UnsprungMF = vehicleObj.FrontUnsprungCWeight/32.2;
SprungMR = vehicleObj.RearSprungWeight/32.2;
UnsprungMR = vehicleObj.RearUnsprungCWeight/32.2;
TotalMF = vehicleObj.FrontStatic/32.2;
TotalMR = vehicleObj.RearStatic/32.2;

%Damping Conversion ((lb-s)/ft)
DampC_Lconv = DampC_L.*12;
DampC_Hconv = DampC_H.*12;

% Chassis Natural Frequency (Hz)
CNF = [sqrt(K_sconv(1,1)/SprungMF),sqrt(K_sconv(1,2)/SprungMF);
    sqrt(K_sconv(2,1)/SprungMR),sqrt(K_sconv(2,2)/SprungMR)]./(2*pi);
disp('Body Natural Frequency (Hz) = ');
disp(CNF);

% Wheel Natural Frequency (Hz)
WNF = [sqrt((K_sconv(1,1)+K_uconv(1,1))/UnsprungMF),sqrt((K_sconv(1,2)+K_uconv(1,2))/UnsprungMF);
    sqrt((K_sconv(2,1)+K_uconv(2,1))/UnsprungMR),sqrt((K_sconv(2,2)+K_uconv(2,2))/UnsprungMR)]./(2*pi);
disp('Wheel Natural Frequency (Hz) = ');
disp(WNF);

% Critical Damping (lb-s)/ft
CD = [2*sqrt(K_sconv(1,1)*SprungMF),2*sqrt(K_sconv(1,2)*SprungMF);
    2*sqrt(K_sconv(2,1)*SprungMR),2*sqrt(K_sconv(2,2)*SprungMR)];

% Damping Ratio
DR_L = [DampC_Lconv(1,1)/CD(1,1) DampC_Lconv(1,2)/CD(1,2); DampC_Lconv(2,1)/CD(2,1) DampC_Lconv(2,2)/CD(2,2)];
DR_H = [DampC_Hconv(1,1)/CD(1,1) DampC_Hconv(1,2)/CD(1,2); DampC_Hconv(2,1)/CD(2,1) DampC_Hconv(2,2)/CD(2,2)];
disp('Damping Ratio - Low = ');
disp(DR_L);
disp('Damping Ratio - High = ');
disp(DR_H);

% Damped Ride Natural Frequency
DR_LNF = [sqrt(1-DR_L(1,1)^2)*CNF(1,1),sqrt(1-DR_L(1,2)^2)*CNF(1,2); sqrt(1-DR_L(2,1)^2)*CNF(2,1),sqrt(1-DR_L(2,2)^2)*CNF(2,2)];
DR_HNF = [sqrt(1-DR_H(1,1)^2)*CNF(1,1),sqrt(1-DR_H(1,2)^2)*CNF(1,2); sqrt(1-DR_H(2,1)^2)*CNF(2,1),sqrt(1-DR_H(2,2)^2)*CNF(2,2)];

disp('Damped Natural Frequency (Hz) - Low = ');
disp(DR_LNF);
disp('Damped Natural Frequency (Hz) - High = ');
disp(DR_HNF);

%% Plots for Analysis

%%
% Ride Modeling Bode Plots

%FL
sys_FL_L = tf([K_uconv(1,1)*DampC_Lconv(1,1) K_sconv(1,1)*K_uconv(1,1) 0 0], [SprungMF*UnsprungMF TotalMF*DampC_Lconv(1,1) ((TotalMF*K_sconv(1,1)) + (SprungMF*K_uconv(1,1))) DampC_Lconv(1,1)*K_uconv(1,1) (K_sconv(1,1)*K_uconv(1,1))]); 
sys_FL_H = tf([K_uconv(1,1)*DampC_Hconv(1,1) K_sconv(1,1)*K_uconv(1,1) 0 0], [SprungMF*UnsprungMF TotalMF*DampC_Hconv(1,1) ((TotalMF*K_sconv(1,1)) + (SprungMF*K_uconv(1,1))) DampC_Hconv(1,1)*K_uconv(1,1) (K_sconv(1,1)*K_uconv(1,1))]); 

%FR
sys_FR_L = tf([K_uconv(1,2)*DampC_Lconv(1,2) K_sconv(1,2)*K_uconv(1,2) 0 0], [SprungMF*UnsprungMF TotalMF*DampC_Lconv(1,2) ((TotalMF*K_sconv(1,2)) + (SprungMF*K_uconv(1,2))) DampC_Lconv(1,2)*K_uconv(1,2) (K_sconv(1,2)*K_uconv(1,2))]); 
sys_FR_H = tf([K_uconv(1,2)*DampC_Hconv(1,2) K_sconv(1,2)*K_uconv(1,2) 0 0], [SprungMF*UnsprungMF TotalMF*DampC_Hconv(1,2) ((TotalMF*K_sconv(1,2)) + (SprungMF*K_uconv(1,2))) DampC_Hconv(1,2)*K_uconv(1,2) (K_sconv(1,2)*K_uconv(1,2))]); 

%RL
sys_RL_L = tf([K_uconv(2,1)*DampC_Lconv(2,1) K_sconv(2,1)*K_uconv(2,1) 0 0], [SprungMR*UnsprungMR TotalMR*DampC_Lconv(2,1) ((TotalMR*K_sconv(2,1)) + (SprungMR*K_uconv(2,1))) DampC_Lconv(2,1)*K_uconv(2,1) (K_sconv(2,1)*K_uconv(2,1))]); 
sys_RL_H = tf([K_uconv(2,1)*DampC_Hconv(2,1) K_sconv(2,1)*K_uconv(2,1) 0 0], [SprungMR*UnsprungMR TotalMR*DampC_Hconv(2,1) ((TotalMR*K_sconv(2,1)) + (SprungMR*K_uconv(2,1))) DampC_Hconv(2,1)*K_uconv(2,1) (K_sconv(2,1)*K_uconv(2,1))]); 

%RR
sys_RR_L = tf([K_uconv(2,2)*DampC_Lconv(2,2) K_sconv(2,2)*K_uconv(2,2) 0 0], [SprungMR*UnsprungMR TotalMR*DampC_Lconv(2,2) ((TotalMR*K_sconv(2,2)) + (SprungMR*K_uconv(2,2))) DampC_Lconv(2,2)*K_uconv(2,2) (K_sconv(2,2)*K_uconv(2,2))]); 
sys_RR_H = tf([K_uconv(2,2)*DampC_Hconv(2,2) K_sconv(2,2)*K_uconv(2,2) 0 0], [SprungMR*UnsprungMR TotalMR*DampC_Hconv(2,2) ((TotalMR*K_sconv(2,2)) + (SprungMR*K_uconv(2,2))) DampC_Hconv(2,2)*K_uconv(2,2) (K_sconv(2,2)*K_uconv(2,2))]); 

% At BNF - Body Mode => Tire Stops Bouncing, Only Sprung Mass Bounces
% At WNF - Wheel Hop Mode => Sprung Mass Stops Bouncing, Only Tire Bounces

figure('Name','Plots - Ride Modeling Bode Plot');
subplot(2,2,1);
bode(sys_FL_L,'b')
hold on
bode(sys_FL_H,'r')
hold on
legend(' Low Speed Damper',' High Speed Damper','Location','best')
hold on

subplot(2,2,2);
bode(sys_FR_L,'b')
hold on
bode(sys_FR_H,'r')
hold on
legend(' Low Speed Damper',' High Speed Damper','Location','best')
hold on

subplot(2,2,3);
bode(sys_RL_L,'b')
hold on
bode(sys_RL_H,'r')
hold on
legend(' Low Speed Damper',' High Speed Damper','Location','best')
hold on

subplot(2,2,4);
bode(sys_RR_L,'b')
hold on
bode(sys_RR_H,'r')
hold on
legend(' Low Speed Damper',' High Speed Damper','Location','best')
hold on

%%
% Sprung and Unsprung Mass Response Plots

%Input Parameters
Vstep = 10; %mph
Vstepfts = Vstep * (5280/3600);
tRearOffset = (vehicleObj.Wheelbase/12)/Vstepfts;

ConfigStepF = RespConfig('InputOffset',0,'Amplitude',1/12,'Delay',0);
ConfigStepR = RespConfig('InputOffset',0,'Amplitude',1/12,'Delay',tRearOffset);

%Transfer Functions (input: road displacement, output: sprung/unsprung mass displacement
%FL
sys_FL_Ls = tf([K_uconv(1,1)*DampC_Lconv(1,1) K_sconv(1,1)*K_uconv(1,1)], [SprungMF*UnsprungMF TotalMF*DampC_Lconv(1,1) ((TotalMF*K_sconv(1,1)) + (SprungMF*K_uconv(1,1))) DampC_Lconv(1,1)*K_uconv(1,1) (K_sconv(1,1)*K_uconv(1,1))]); 
sys_FL_Hs = tf([K_uconv(1,1)*DampC_Hconv(1,1) K_sconv(1,1)*K_uconv(1,1)], [SprungMF*UnsprungMF TotalMF*DampC_Hconv(1,1) ((TotalMF*K_sconv(1,1)) + (SprungMF*K_uconv(1,1))) DampC_Hconv(1,1)*K_uconv(1,1) (K_sconv(1,1)*K_uconv(1,1))]); 
sys_FL_Lu = tf([K_uconv(1,1)*SprungMF K_uconv(1,1)*DampC_Lconv(1,1) K_sconv(1,1)*K_uconv(1,1)], [SprungMF*UnsprungMF TotalMF*DampC_Lconv(1,1) ((TotalMF*K_sconv(1,1)) + (SprungMF*K_uconv(1,1))) DampC_Lconv(1,1)*K_uconv(1,1) (K_sconv(1,1)*K_uconv(1,1))]); 
sys_FL_Hu = tf([K_uconv(1,1)*SprungMF K_uconv(1,1)*DampC_Hconv(1,1) K_sconv(1,1)*K_uconv(1,1)], [SprungMF*UnsprungMF TotalMF*DampC_Hconv(1,1) ((TotalMF*K_sconv(1,1)) + (SprungMF*K_uconv(1,1))) DampC_Hconv(1,1)*K_uconv(1,1) (K_sconv(1,1)*K_uconv(1,1))]); 

%FR
sys_FR_Ls = tf([K_uconv(1,2)*DampC_Lconv(1,2) K_sconv(1,2)*K_uconv(1,2)], [SprungMF*UnsprungMF TotalMF*DampC_Lconv(1,2) ((TotalMF*K_sconv(1,2)) + (SprungMF*K_uconv(1,2))) DampC_Lconv(1,2)*K_uconv(1,2) (K_sconv(1,2)*K_uconv(1,2))]); 
sys_FR_Hs = tf([K_uconv(1,2)*DampC_Hconv(1,2) K_sconv(1,2)*K_uconv(1,2)], [SprungMF*UnsprungMF TotalMF*DampC_Hconv(1,2) ((TotalMF*K_sconv(1,2)) + (SprungMF*K_uconv(1,2))) DampC_Hconv(1,2)*K_uconv(1,2) (K_sconv(1,2)*K_uconv(1,2))]);
sys_FR_Lu = tf([K_uconv(1,2)*SprungMF K_uconv(1,2)*DampC_Lconv(1,2) K_sconv(1,2)*K_uconv(1,2)], [SprungMF*UnsprungMF TotalMF*DampC_Lconv(1,2) ((TotalMF*K_sconv(1,2)) + (SprungMF*K_uconv(1,2))) DampC_Lconv(1,2)*K_uconv(1,2) (K_sconv(1,2)*K_uconv(1,2))]); 
sys_FR_Hu = tf([K_uconv(1,2)*SprungMF K_uconv(1,2)*DampC_Hconv(1,2) K_sconv(1,2)*K_uconv(1,2)], [SprungMF*UnsprungMF TotalMF*DampC_Hconv(1,2) ((TotalMF*K_sconv(1,2)) + (SprungMF*K_uconv(1,2))) DampC_Hconv(1,2)*K_uconv(1,2) (K_sconv(1,2)*K_uconv(1,2))]); 

%RL
sys_RL_Ls = tf([K_uconv(2,1)*DampC_Lconv(2,1) K_sconv(2,1)*K_uconv(2,1)], [SprungMR*UnsprungMR TotalMR*DampC_Lconv(2,1) ((TotalMR*K_sconv(2,1)) + (SprungMR*K_uconv(2,1))) DampC_Lconv(2,1)*K_uconv(2,1) (K_sconv(2,1)*K_uconv(2,1))]); 
sys_RL_Hs = tf([K_uconv(2,1)*DampC_Hconv(2,1) K_sconv(2,1)*K_uconv(2,1)], [SprungMR*UnsprungMR TotalMR*DampC_Hconv(2,1) ((TotalMR*K_sconv(2,1)) + (SprungMR*K_uconv(2,1))) DampC_Hconv(2,1)*K_uconv(2,1) (K_sconv(2,1)*K_uconv(2,1))]); 
sys_RL_Lu = tf([K_uconv(2,1)*SprungMR  K_uconv(2,1)*DampC_Lconv(2,1) K_sconv(2,1)*K_uconv(2,1)], [SprungMR*UnsprungMR TotalMR*DampC_Lconv(2,1) ((TotalMR*K_sconv(2,1)) + (SprungMR*K_uconv(2,1))) DampC_Lconv(2,1)*K_uconv(2,1) (K_sconv(2,1)*K_uconv(2,1))]); 
sys_RL_Hu = tf([K_uconv(2,1)*SprungMR  K_uconv(2,1)*DampC_Hconv(2,1) K_sconv(2,1)*K_uconv(2,1)], [SprungMR*UnsprungMR TotalMR*DampC_Hconv(2,1) ((TotalMR*K_sconv(2,1)) + (SprungMR*K_uconv(2,1))) DampC_Hconv(2,1)*K_uconv(2,1) (K_sconv(2,1)*K_uconv(2,1))]);

%RR
sys_RR_Ls = tf([K_uconv(2,2)*DampC_Lconv(2,2) K_sconv(2,2)*K_uconv(2,2)], [SprungMR*UnsprungMR TotalMR*DampC_Lconv(2,2) ((TotalMR*K_sconv(2,2)) + (SprungMR*K_uconv(2,2))) DampC_Lconv(2,2)*K_uconv(2,2) (K_sconv(2,2)*K_uconv(2,2))]); 
sys_RR_Hs = tf([K_uconv(2,2)*DampC_Hconv(2,2) K_sconv(2,2)*K_uconv(2,2)], [SprungMR*UnsprungMR TotalMR*DampC_Hconv(2,2) ((TotalMR*K_sconv(2,2)) + (SprungMR*K_uconv(2,2))) DampC_Hconv(2,2)*K_uconv(2,2) (K_sconv(2,2)*K_uconv(2,2))]); 
sys_RR_Lu = tf([K_uconv(2,2)*SprungMR K_uconv(2,2)*DampC_Lconv(2,2) K_sconv(2,2)*K_uconv(2,2)], [SprungMR*UnsprungMR TotalMR*DampC_Lconv(2,2) ((TotalMR*K_sconv(2,2)) + (SprungMR*K_uconv(2,2))) DampC_Lconv(2,2)*K_uconv(2,2) (K_sconv(2,2)*K_uconv(2,2))]); 
sys_RR_Hu = tf([K_uconv(2,2)*SprungMR K_uconv(2,2)*DampC_Hconv(2,2) K_sconv(2,2)*K_uconv(2,2)], [SprungMR*UnsprungMR TotalMR*DampC_Hconv(2,2) ((TotalMR*K_sconv(2,2)) + (SprungMR*K_uconv(2,2))) DampC_Hconv(2,2)*K_uconv(2,2) (K_sconv(2,2)*K_uconv(2,2))]);

%Sprung Mass Step Response Sweep (Low Speed Damper)
[y_FL_Lsstep , tOut_FL_Lsstep] = step(sys_FL_Ls,ConfigStepF);
[y_FR_Lsstep , tOut_FR_Lsstep] = step(sys_FR_Ls,ConfigStepF);
[y_RL_Lsstep , tOut_RL_Lsstep] = step(sys_RL_Ls,ConfigStepR);
[y_RR_Lsstep , tOut_RR_Lsstep] = step(sys_RR_Ls,ConfigStepR);

%Unsprung Mass Step Response Sweep (Low Speed Damper)
[y_FL_Lustep , tOut_FL_Lustep] = step(sys_FL_Lu,ConfigStepF);
[y_FR_Lustep , tOut_FR_Lustep] = step(sys_FR_Lu,ConfigStepF);
[y_RL_Lustep , tOut_RL_Lustep] = step(sys_RL_Lu,ConfigStepR);
[y_RR_Lustep , tOut_RR_Lustep] = step(sys_RR_Lu,ConfigStepR);

%Sprung Mass Step Response Sweep (High Speed Damper)
[y_FL_Hsstep , tOut_FL_Hsstep] = step(sys_FL_Hs,ConfigStepF);
[y_FR_Hsstep , tOut_FR_Hsstep] = step(sys_FR_Hs,ConfigStepF);
[y_RL_Hsstep , tOut_RL_Hsstep] = step(sys_RL_Hs,ConfigStepR);
[y_RR_Hsstep , tOut_RR_Hsstep] = step(sys_RR_Hs,ConfigStepR);

%Unsprung Mass Step Response Sweep (High Speed Damper)
[y_FL_Hustep , tOut_FL_Hustep] = step(sys_FL_Hu,ConfigStepF);
[y_FR_Hustep , tOut_FR_Hustep] = step(sys_FR_Hu,ConfigStepF);
[y_RL_Hustep , tOut_RL_Hustep] = step(sys_RL_Hu,ConfigStepR);
[y_RR_Hustep , tOut_RR_Hustep] = step(sys_RR_Hu,ConfigStepR);

%Sprung Mass Step Response Sweep (Low Speed Damper)
[y_FL_Lsimpulse , tOut_FL_Lsimpulse] = impulse(sys_FL_Ls,ConfigStepF);
[y_FR_Lsimpulse , tOut_FR_Lsimpulse] = impulse(sys_FR_Ls,ConfigStepF);
[y_RL_Lsimpulse , tOut_RL_Lsimpulse] = impulse(sys_RL_Ls,ConfigStepR);
[y_RR_Lsimpulse , tOut_RR_Lsimpulse] = impulse(sys_RR_Ls,ConfigStepR);

%Unsprung Mass Step Response Sweep (Low Speed Damper)
[y_FL_Luimpulse , tOut_FL_Luimpulse] = impulse(sys_FL_Lu,ConfigStepF);
[y_FR_Luimpulse , tOut_FR_Luimpulse] = impulse(sys_FR_Lu,ConfigStepF);
[y_RL_Luimpulse , tOut_RL_Luimpulse] = impulse(sys_RL_Lu,ConfigStepR);
[y_RR_Luimpulse , tOut_RR_Luimpulse] = impulse(sys_RR_Lu,ConfigStepR);

%Sprung Mass Step Response Sweep (High Speed Damper)
[y_FL_Hsimpulse , tOut_FL_Hsimpulse] = impulse(sys_FL_Hs,ConfigStepF);
[y_FR_Hsimpulse , tOut_FR_Hsimpulse] = impulse(sys_FR_Hs,ConfigStepF);
[y_RL_Hsimpulse , tOut_RL_Hsimpulse] = impulse(sys_RL_Hs,ConfigStepR);
[y_RR_Hsimpulse , tOut_RR_Hsimpulse] = impulse(sys_RR_Hs,ConfigStepR);

%Unsprung Mass Step Response Sweep (High Speed Damper)
[y_FL_Huimpulse , tOut_FL_Huimpulse] = impulse(sys_FL_Hu,ConfigStepF);
[y_FR_Huimpulse , tOut_FR_Huimpulse] = impulse(sys_FR_Hu,ConfigStepF);
[y_RL_Huimpulse , tOut_RL_Huimpulse] = impulse(sys_RL_Hu,ConfigStepR);
[y_RR_Huimpulse , tOut_RR_Huimpulse] = impulse(sys_RR_Hu,ConfigStepR);

figure('Name','Plots - Sprung Mass Step Response Plot');
subplot(2,2,1);
title('Left Side Step Response (Low Speed Damper)')
hold on
plot(tOut_FL_Lsstep,y_FL_Lsstep,'r')
hold on
plot(tOut_RL_Lsstep,y_RL_Lsstep,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FL',' FR','Location','best')
hold on
subplot(2,2,2);
title('Right Side Step Response (Low Speed Damper)')
hold on
plot(tOut_FR_Lsstep,y_FR_Lsstep,'r')
hold on
plot(tOut_RR_Lsstep,y_RR_Lsstep,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FR',' RR','Location','best')
hold on

subplot(2,2,3);
title('Left Side Step Response (High Speed Damper)')
hold on
plot(tOut_FL_Hsstep,y_FL_Hsstep,'r')
hold on
plot(tOut_RL_Hsstep,y_RL_Hsstep,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FL',' FR','Location','best')
hold on
subplot(2,2,4);
title('Right Side Step Response (High Speed Damper)')
hold on
plot(tOut_FR_Hsstep,y_FR_Hsstep,'r')
hold on
plot(tOut_RR_Hsstep,y_RR_Hsstep,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FR',' RR','Location','best')
hold on

figure('Name','Plots - Sprung Mass Impulse Response Plot');
subplot(2,2,1);
title('Left Side Impulse Response (Low Speed Damper)')
hold on
plot(tOut_FL_Lsimpulse,y_FL_Lsimpulse,'r')
hold on
plot(tOut_RL_Lsimpulse,y_RL_Lsimpulse,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FL',' FR','Location','best')
hold on
subplot(2,2,2);
title('Right Side Impulse Response (Low Speed Damper)')
hold on
plot(tOut_FR_Lsimpulse,y_FR_Lsimpulse,'r')
hold on
plot(tOut_RR_Lsimpulse,y_RR_Lsimpulse,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FR',' RR','Location','best')
hold on

subplot(2,2,3);
title('Left Side Impulse Response (High Speed Damper)')
hold on
plot(tOut_FL_Hsimpulse,y_FL_Hsimpulse,'r')
hold on
plot(tOut_RL_Hsimpulse,y_RL_Hsimpulse,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FL',' FR','Location','best')
hold on
subplot(2,2,4);
title('Right Side Impulse Response (High Speed Damper)')
hold on
plot(tOut_FR_Hsimpulse,y_FR_Hsimpulse,'r')
hold on
plot(tOut_RR_Hsimpulse,y_RR_Hsimpulse,'b')
hold on
xlabel('Time (s)')
hold on
ylabel('Displacement (in)')
hold on
legend(' FR',' RR','Location','best')
hold on

% figure('Name','Plots - Sprung Mass Step Response Plot');
% subplot(2,2,1);
% step(sys_FL_Ls,'b')
% hold on
% step(sys_FL_Hs,'r')
% hold on
% legend(' Low Speed Damper',' High Speed Damper','Location','best')
% hold on
% subplot(2,2,2);
% step(sys_FR_Ls,'b')
% hold on
% step(sys_FR_Hs,'r')
% hold on
% legend(' Low Speed Damper',' High Speed Damper','Location','best')
% hold on
% subplot(2,2,3);
% step(sys_RL_Ls,'b')
% hold on
% step(sys_RL_Hs,'r')
% hold on
% legend(' Low Speed Damper',' High Speed Damper','Location','best')
% hold on
% subplot(2,2,4);
% step(sys_RR_Ls,'b')
% hold on
% step(sys_RR_Hs,'r')
% hold on
% legend(' Low Speed Damper',' High Speed Damper','Location','best')
% hold on