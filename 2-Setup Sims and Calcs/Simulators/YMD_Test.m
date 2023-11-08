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
[F_polyCalc_Kt,R_polyCalc_Kt] = SpringRateCalc(latTrainingData_P1F,latTrainingData_P2F,vehicleObj);

K_t = [F_polyCalc_Kt, F_polyCalc_Kt; R_polyCalc_Kt, R_polyCalc_Kt];

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

[F_polyCalc,R_polyCalc] = LateralCoFCalc(latTrainingData_P1F,latTrainingData_P2F,vehicleObj);

%% Motor Parameters

Max_Velocity = 86; % mph

%% Inputs

VelocityInput = 0; % mph

SWAngle = -2; % deg (pos->Right, neg->Left)

BetaInput = 1; % deg (pos->Right, neg->Left)

Radius = 329; % in (pos->Right, neg->Left)

converge = false;

%% Calculations

while(converge == false)

    [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle,vehicleObj);
    
    [SlipAngles] = SlipAngleCalc(SteerAngles,BetaInput,VelocityInput,Radius,vehicleObj);
    
    Accelcalc = -((VelocityInput*17.6)^2/Radius)/386.4; % g's
    
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,VelocityInput,Accelcalc,vehicleObj);
                
    [IA] = CamberCalc(Roll_Angle,SWAngle,vehicleObj);
                
    [Fx,Fy,Mz] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);
    
    [YM,Accel] = YMCalc(SteerAngles,Fx,Fy,Mz,vehicleObj);

    % Acceltot = sqrt(Accel(1,1)^2 + Accel(1,2)^2);
    
    % NextBeta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*(((Velocity*17.6)^2)/(Radius*386.4))));
    % Vcalc = sqrt(abs((Acceltot*386.4))*Radius)./17.6;

    if (abs(Accelcalc - Accel(1,2))>(0.0001*abs(Accelcalc)))
        Vcalc = sqrt(abs((Accel(1,2)*386.4))*Radius)./17.6;
        VelocityInput = Vcalc;
    else
        converge = true;
    end

end

disp('Velocity: ');
disp(Vcalc);
disp('Radius: ');
disp(Radius);
disp('Steering Wheel Angle: ');
disp(SWAngle);
disp('Input Beta: ');
disp(BetaInput);
% disp('Next Beta: ');
% disp(NextBeta);
disp('Roll Angle: ');
disp(Roll_Angle);
disp('Slip Angles: ');
disp(SlipAngles);
disp('Fx: ');
disp(Fx);
disp('Fy: ');
disp(Fy);
disp('Fz: ');
disp(Fz);
disp('Mz: ');
disp(Mz);
disp('Gs: ');
disp(Accel);
% disp('Acceleration: ');
% disp(LatAccelG);
disp('Yaw Moment: ');
disp(YM);
disp('Camber: ');
disp(IA);
disp('Wheel Displacement: ');
disp(Z);
disp('Tire Pressure: ');
disp(vehicleObj.TirePressure);
disp('----------------------');
