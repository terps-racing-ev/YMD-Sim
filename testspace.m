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

 %train Fy model
    tic
        disp('Fy Model is being trained.  Standby...')
        [Model_Fy, validation.RMSE_Fy] = Trainer_Fy(totData); %creates trained model and root mean square error to evaluate "fit"
        disp('Training completed')
    toc

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

DataPoints = 100;

% Velocity Sweep (mph)
Velocity = linspace(0,Max_Velocity,DataPoints);

Velocityin_s = Velocity * 17.6;

Radius = 348;

SWAngle = 20;

KGradient = [];
SLGradient = [];
SRGradient = [];
CharSpeedGradient = [];
CritSpeedGradient = [];
BetaGradient = [];

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity(i),0,K_r,vehicleObj);
    
    [Calpha] = CstiffCalc(Fz,Model_Fy,vehicleObj);

    AckL = atand((vehicleObj.Wheelbase/(Radius+(vehicleObj.FrontTrackWidth/2))));

    AckR = atand((vehicleObj.Wheelbase/(Radius-(vehicleObj.FrontTrackWidth/2)))); 

    K = ((-2*vehicleObj.FrontStatic)/sum(Calpha(1,:)))-((-2*vehicleObj.RearStatic)/sum(Calpha(2,:)));

    KGradient(1,i) = K;
    
    SLAngle = atand((vehicleObj.Wheelbase/(Radius+(vehicleObj.FrontTrackWidth/2)))) + (K*((Velocityin_s(i).^2)/(Radius*386.4)));

    SLGradient(1,i) = SLAngle;

    SRAngle = atand((vehicleObj.Wheelbase/(Radius-(vehicleObj.FrontTrackWidth/2)))) + (K*((Velocityin_s(i).^2)/(Radius*386.4)));

    SRGradient(1,i) = SRAngle;

    CharSpeed = sqrt((57.3*((vehicleObj.Wheelbase*32.2)/(12*abs(K))))*(3600/5280)); % Speed at which SAngle = 2 * Ackermann Angle

    CharSpeedGradient(1,i) = CharSpeed;

    CritSpeed = sqrt((57.3*((vehicleObj.Wheelbase*32.2)/(12*abs(K))))*(3600/5280)); % Speed at which SAngle = 0 deg

    CritSpeedGradient(1,i) = CritSpeed;

    Beta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*((Velocityin_s(i).^2)/(Radius*386.4))));

    BetaGradient(1,i) = Beta;

end

SLAngleNS = atand((vehicleObj.Wheelbase/(Radius+(vehicleObj.FrontTrackWidth/2))))*ones(1,numel(Velocity));

SRAngleNS = atand((vehicleObj.Wheelbase/(Radius-(vehicleObj.FrontTrackWidth/2))))*ones(1,numel(Velocity));

CharSAngle = 2 * (57.3*(vehicleObj.Wheelbase/Radius)); % SAngle = 2 * Ackermann Angle

figure('Name','Plots - Handling Characteristics');
subplot(1,3,1);
title('Steer Angle (deg) vs. Velocity (mph)')
hold on
xlabel('Velocity (mph)');
hold on
ylabel('Steer Angle (deg)');
hold on

plot(Velocity,SLGradient,'-r*');
hold on
plot(Velocity,SRGradient,'-ro');
hold on
plot(Velocity, SLAngleNS,'b-');
hold on
plot(Velocity, SRAngleNS,'b-');
hold on
legend(' FL',' FR','Location','eastoutside')
hold on

subplot(1,3,2);
title('Understeer Gradient vs. Velocity (mph)')
hold on
xlabel('Velocity (mph)');
hold on
ylabel('Understeer Gradient');
hold on

plot(Velocity,KGradient,'g');
hold on

subplot(1,3,3);
title('Beta Gradient vs. Velocity (mph)')
hold on
xlabel('Velocity (mph)');
hold on
ylabel('Beta Gradient');
hold on

polyBeta = polyfit(Velocity,BetaGradient,2);

VBeta = roots(polyBeta);

VBetapos = VBeta((find(VBeta>0)),1);

plot(Velocity,BetaGradient,'-b');
hold on
yline(0,'--r');
hold on
str = "Velocity when Beta => 0  = " + VBetapos + " mph";
text(VBetapos + 5,0,str)
hold on

