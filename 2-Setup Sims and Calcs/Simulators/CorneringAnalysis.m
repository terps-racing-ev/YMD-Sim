%% Cornering Analysis
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

% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

% Adding Reference Files
addpath([currentFolder, filesep, 'Reference Files\']);

vehicleObj = TREV2Parameters();

%% Tire Modeling

%Input tire filenames
filename.FrontTire = 'A1965run18.mat';
filename.RearTire = 'A1965run18.mat';
[trainingDataFront,tire.IDfront] = createLatTrngData2(filename.FrontTire);
[trainingDataRear,tire.IDrear] = createLatTrngData2(filename.RearTire);

% Front tires
disp([tire.IDfront, ', Front Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainingDataFront);
[model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainingDataFront);
[model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainingDataFront);
[model.muxFront, validation.RMSE_muxFront] = Trainer_mux(trainingDataFront);
[model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainingDataFront);
toc(t1)

disp('Training completed')

% Rear tires
disp([tire.IDrear, ', Rear Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainingDataRear);
[model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainingDataRear);
[model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainingDataRear);
[model.muxRear, validation.RMSE_muxRear] = Trainer_mux(trainingDataRear);
[model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainingDataRear);
toc(t1)

disp('Training completed')

%% Inputs

K_t = [548 548; 548 548];%lbf/in 

% Number of Iterations
n = 5;

% Input Test Cornering Parameters
Radius = -348; %in (neg -> Left, pos -> Right)
Velocity = 25; %linspace(0,35,4); %mph

%% Entry Analysis - Immediate G's Generated by SW Input

% Input Steering Wheel Angle, CoG Slip Angle
SWAngle = -8; %linspace(-90,90,5); %deg (L = neg, R = pos)
BetaEntry = 0; %CoG slip angle (deg) (neg -> Right, pos -> Left)

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Steering Angles (deg), Slip Angles (deg), Load Transfer (lb), Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))

SteerAngles = SteerAngleSim(SWAngle,vehicleObj);
            
[SlipAngles,LatAccelG,Betamax,YawVelo,LongVelo,LateralVelo] = SlipAngleSim(SteerAngles,BetaEntry,Velocity,Radius,vehicleObj);
             
LatAccelG = 0;

[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_roll,Velocity,LatAccelG,vehicleObj);

[IA] = CamberSim(Roll_Angle,SWAngle,vehicleObj);

[Fx,Fy,Mz,muy] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);

[YM,AccelEntry] = YMSim(SteerAngles,Fx,Fy,Mz,vehicleObj);

[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_roll,Velocity,AccelEntry(1,2),vehicleObj);

[IA] = CamberSim(Roll_Angle,SWAngle,vehicleObj);

mu = [sqrt(((Fx(1,1)/Fz(1,1))^2+((Fy(1,1)/Fz(1,1))^2))), sqrt(((Fx(1,2)/Fz(1,2))^2+((Fy(1,2)/Fz(1,2))^2))); sqrt(((Fx(2,1)/Fz(2,1))^2+((Fy(2,1)/Fz(2,1))^2))), sqrt(((Fx(2,2)/Fz(2,2))^2+((Fy(2,2)/Fz(2,2))^2)))];

disp('Velocity: ');
disp(Velocity);
disp('Radius: ');
disp(Radius);
if(Radius < 0)
    disp('Left');
else
    disp('Right');
end
disp('Gs: ');
disp(AccelEntry);
disp('Steering Wheel Angle: ');
disp(SWAngle);
disp('Beta: ');
disp(BetaEntry);
disp('Slip Angles: ');
disp(SlipAngles);
disp('LLT_D: ');
disp(LLT_D);
disp('Fx: ');
disp(Fx);
disp('Fy: ');
disp(Fy);
disp('Fz: ');
disp(Fz);
disp('muy: ');
disp(muy);
disp('mu: ');
disp(mu);
%disp('mu_max: ');
%disp(muy);
disp('Roll Angle: ');
disp(Roll_Angle);
disp('Camber: ');
disp(IA);
disp('Wheel Displacement: ');
disp(Z);
disp('Tire Pressure: ');
disp(vehicleObj.TirePressure);

%% Apex Analysis - (beta delta w/ steering sweep)

% Input Steering Wheel Angle, CoG Slip Angle
SWAngleApex = [-10, -30, -60, -55, -25]; %deg (L = neg, R = pos)
BetaApex = [0,Betamax/2,Betamax,Betamax/2,0]; %CoG slip angle (deg) (neg -> Right, pos -> Left)

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% How to Interpret:
% For a successful left hand corner (Radius < 0):
% Corner Entry: Beta = 0 -> +++, YM: +++
% Corner Apex: Betamax -> ---, YM: ~0
% Corner Exit: Beta = 0, YM: ---

SteerAngles = SteerAngleSim(SWAngleApex(:,1),vehicleObj);

LatAccelG = 0;
          
[SlipAnglesCurrent,LatAccelG,Betamax,YawVelo,LongVelo,LateralVelo] = SlipAngleSim(SteerAngles,BetaApex(:,1),Velocity,Radius,vehicleObj);

LatAccelG = 0;

[Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_roll,Velocity,LatAccelG,vehicleObj);

[IA] = CamberSim(Roll_Angle,SWAngleApex(:,1),vehicleObj);

[Fx,Fy,Mz,muy] = findTireFM(model,SlipAnglesCurrent,IA,Fz,vehicleObj.TirePressure);

[YM,Accel] = YMSim(SteerAngles,Fx,Fy,Mz,vehicleObj);

mu = [sqrt(((Fx(1,1)/Fz(1,1))^2+((Fy(1,1)/Fz(1,1))^2))), sqrt(((Fx(1,2)/Fz(1,2))^2+((Fy(1,2)/Fz(1,2))^2))); sqrt(((Fx(2,1)/Fz(2,1))^2+((Fy(2,1)/Fz(2,1))^2))), sqrt(((Fx(2,2)/Fz(2,2))^2+((Fy(2,2)/Fz(2,2))^2)))];

YMSum = 0 + YM;

disp('Velocity: ');
disp(Velocity);
disp('Radius: ');
disp(Radius);
if(Radius < 0)
    disp('Left');
else
    disp('Right');
end

disp('----------------------');

disp('Steering Wheel Angle: ');
disp(SWAngleApex(:,1));
disp('Beta: ');
disp(BetaApex(:,1));
disp('Slip Angles: ');
disp(SlipAnglesCurrent);
% disp('LLT_D: ');
% disp(LLT_D);
disp('Fx: ');
disp(Fx);
disp('Fy: ');
disp(Fy);
disp('Fz: ');
disp(Fz);
disp('mu: ');
disp(mu);
% %disp('mu_max: ');
% %disp(muy);
disp('Gs: ');
disp(Accel);
disp('Yaw Moment: ');
disp(YM);
% disp('Roll Angle: ');
% disp(Roll_Angle);
% disp('Camber: ');
% disp(IA);
% disp('Wheel Displacement: ');
% disp(Z);
% disp('Tire Pressure: ');
% disp(vehicleObj.TirePressure);
disp('----------------------');

for k = 2:length(BetaApex)

    SteerAngles = SteerAngleSim(SWAngleApex(:,k),vehicleObj);
    
    [SlipAnglesNew,LatAccelG,Betamax,YawVelo,LongVelo,LateralVelo] = SlipAngleSim(SteerAngles,BetaApex(:,k),Velocity,Radius,vehicleObj);
    
    SlipAngles = SlipAnglesNew - SlipAnglesCurrent;
    
    SlipAnglesCurrent = SlipAngles;
    
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTSim(K_roll,Velocity,Accel(1,2),vehicleObj);
    
    [IA] = CamberSim(Roll_Angle,SWAngleApex(:,k),vehicleObj);
    
    [Fx,Fy,Mz,muy] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);
    
    [YM,Accel] = YMSim(SteerAngles,Fx,Fy,Mz,vehicleObj);
    
    mu = [sqrt(((Fx(1,1)/Fz(1,1))^2+((Fy(1,1)/Fz(1,1))^2))), sqrt(((Fx(1,2)/Fz(1,2))^2+((Fy(1,2)/Fz(1,2))^2))); sqrt(((Fx(2,1)/Fz(2,1))^2+((Fy(2,1)/Fz(2,1))^2))), sqrt(((Fx(2,2)/Fz(2,2))^2+((Fy(2,2)/Fz(2,2))^2)))];
    
    YMSum = YMSum + YM;
    
%     disp('Velocity: ');
%     disp(Velocity);
%     disp('Radius: ');
%     disp(Radius);
%     if(Radius < 0)
%         disp('Left');
%     else
%         disp('Right');
%     end
    disp('Steering Wheel Angle: ');
    disp(SWAngleApex(:,k));
    disp('Beta: ');
    disp(BetaApex(:,k));
    disp('Slip Angles: ');
    disp(SlipAngles);
%     disp('LLT_D: ');
%     disp(LLT_D);
    disp('Fx: ');
    disp(Fx);
    disp('Fy: ');
    disp(Fy);
    disp('Fz: ');
    disp(Fz);
    disp('mu: ');
    disp(mu);
    %disp('mu_max: ');
    %disp(muy);
    disp('Gs: ');
    disp(Accel);
    disp('Yaw Moment: ');
    disp(YM);
%     disp('Roll Angle: ');
%     disp(Roll_Angle);
%     disp('Camber: ');
%     disp(IA);
%     disp('Wheel Displacement: ');
%     disp(Z);
%     disp('Tire Pressure: ');
%     disp(vehicleObj.TirePressure);
    disp('----------------------');

end
