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

vehicleObj = TREV2ParametersV2();

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

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

%% Motor Parameters

Max_Velocity = 86; % mph

%% Test Space

%% Inputs

VelocityInput = 0.1; % mph

SWAngle = 0; % deg (pos->Right, neg->Left)

BetaInput = 0; % deg (pos->Right, neg->Left)

Radius = 329; % in (pos->Right, neg->Left)

converge = false;

%% Calculations

while(converge == false)

    if SWAngle < 0
        RadiusInput = -Radius;
    else
        RadiusInput = Radius;
    end

    [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle,vehicleObj);

    [SlipAngles] = SlipAngleCalc(SteerAngles,BetaInput,VelocityInput,RadiusInput,vehicleObj);

    if max(max(abs(SlipAngles))) > 13 %max slip angle tested by TTC
        Accel = 0;
        if Accel == 0
            Accel(1,2) = 0;
        end
        YM = 0;
        break %no calculations for conditions outside of testing limits
    end

    Accelcalc = -((VelocityInput*17.6)^2/RadiusInput)/386.4; % g's

    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,VelocityInput,Accelcalc,vehicleObj);

    [IA] = CamberCalc(Z,Roll_Angle,SWAngle,vehicleObj);

    [Fx,Fy,Mz] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);

    [YM,Accel] = YMCalc(SteerAngles,Fx,Fy,Mz,vehicleObj);

    % [Calpha] = CstiffCalc(Fz,model.FyFront,model.FyRear,vehicleObj);
    % 
    % MaxBeta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*(((VelocityInput*17.6)^2)/(Radius*386.4))));

    % if SWAngle < 0
    %     MaxBeta = -MaxBeta;
    % else
    %     MaxBeta = MaxBeta;
    % end

    if (abs(Accelcalc - Accel(1,2))>(0.0001*abs(Accelcalc)))
        Vcalc = sqrt(abs((Accel(1,2)*386.4))*Radius)./17.6;
        VelocityInput = Vcalc;
    else
        converge = true;
    end

end

% % Static Weights at Velocity (lb) -> Max G's Possible on Entry
% [Fz,LoLT,Accelmax,Pitch_Angle,Z] = LoLTCalc(0,Velocity,0,K_r,vehicleObj);
% 
% [IA] = CamberCalc(Z,0,0,vehicleObj);
% 
% [mu] = CoFCalc(Fz,IA,model.muyFront,model.muyRear,vehicleObj);
% 
% if RightTurn == true
%     Fy_max = -(mu.*Fz);
% else
%     Fy_max = mu.*Fz;
% end
% 
% g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));
% 
% mu_drive = g_avg;
% 
% if Velocity == 0 && RightTurn == true
%     mu_drive = -1.7;
% end
% 
% % disp('Fz (lb): ');
% % disp(Fz);
% % disp('Max Fy (lb): ');
% % disp(Fy_max);
% % % disp('Yaw Moment (lb*in):');
% % % disp(Yaw);
% % disp('Max Lateral Acceleration (Gs): ');
% % disp(g_avg);
% % disp('Wheel Displacement (in): ');
% % disp(Z);
% 
% % Maximum Cornering Velocity (mph)
% % CornerSpeed = sqrt(((abs(sum(reshape(Fy_max,[1,4]))))/(vehicleObj.TotalWeight/32.2))*(Radius/12))/1.467;
% 
% % Dynamic Weights (lb) -> Max Fy from Weight Transfer
% [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity,mu_drive,vehicleObj);
% 
% [IA] = CamberCalc(Z,Roll_Angle,0,vehicleObj);
% 
% [mu] = CoFCalc(Fz,IA,model.muyFront,model.muyRear,vehicleObj);
% 
% if RightTurn == true
%     Fy_max = -(mu.*Fz);
% else
%     Fy_max = mu.*Fz;
% end
% 
% g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));
% 
% % Maximum Cornering Velocity (mph)
% CornerSpeed = sqrt(((abs(sum(reshape(Fy_max,[1,4]))))/(vehicleObj.TotalWeight/32.2))*(Radius/12))/1.467;
% 
% % Rough Yaw Calculator
% % Yaw_Wheel = Fy_max.*[vehicleObj.FrontAxleToCoG,vehicleObj.FrontAxleToCoG;vehicleObj.CoGToRearAxle,vehicleObj.CoGToRearAxle];
% % 
% % Yaw = sum(Yaw_Wheel(1,:))-sum(Yaw_Wheel(2,:));
% 
% % disp('----------');
% disp('Fz (lb): ');
% disp(round(Fz,4,"decimals"));
% disp('Max Fy (lb): ');
% disp(round(Fy_max,4,"decimals"));
% disp('Camber (deg):');
% disp(round(IA,4,"decimals"));
% disp('Max Lateral Acceleration (Gs): ');
% disp(round(g_avg,4,"decimals"));
% disp('Max Cornering Velocity (mph): ');
% disp(round(CornerSpeed,4,"decimals"));
% disp('LLT_D: ');
% disp(round(LLT_D,4,"decimals"));
% disp('Roll Sensitivity (deg/g): ');
% disp(round(R_g,4,"decimals"));
% disp('Roll Angle (deg): ');
% disp(round(Roll_Angle,4,"decimals"));
% disp('Wheel Displacement (in): ');
% disp(round(Z,4,"decimals"));