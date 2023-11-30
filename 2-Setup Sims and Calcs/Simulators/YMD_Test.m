<<<<<<< HEAD
 %% YMD Test
=======
%% YMD Test
>>>>>>> main
% Credit - LJ Hamilton

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
<<<<<<< HEAD
vehicleObj = TREV2Parameters();
=======
>>>>>>> main

% Adding Tire Models
addpath([currentFolder, filesep, '1-Input Functions', filesep, 'Tire Modeling']);

<<<<<<< HEAD
% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

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
=======
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
>>>>>>> main
toc(t1)

disp('Training completed')

% Rear tires
<<<<<<< HEAD
disp([tire.IDrear, ', Rear Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainingDataRear);
[model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainingDataRear);
[model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainingDataRear);
[model.muxRear, validation.RMSE_muxRear] = Trainer_mux(trainingDataRear);
[model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainingDataRear);
=======
disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
[model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
[model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
[model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
>>>>>>> main
toc(t1)

disp('Training completed')

<<<<<<< HEAD
%% Inputs

K_t = [548 548; 548 548];%lbf/in 

% Number of Iterations
m = 19;
n = 13;

% Input Test Cornering Parameters
Radius = linspace(-1000,1000,10); %-348; %in (neg -> Left, pos -> Right)
Velocity = 25; %linspace(0,35,10); %mph

% Input Steering Wheel Angle, CoG Slip Angle
SWAngle = linspace(-90,90,m); %deg (L = neg, R = pos)
Beta = 6; %linspace(6,-6,n); %CoG slip angle (deg) (pos -> Right, neg -> Left)

%% Code

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Entry Analysis
Accel = [0 0];

% Steering Angles (deg), Slip Angles (deg), Load Transfer (lb), Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))
for k = 1:length(Beta)
    for j = 1:length(SWAngle)
        for i = 1:length(Radius)
                           
            SteerAngles(:,:,j) = SteerAngleCalc(SWAngle(:,j),vehicleObj);
            
            [SlipAngles(:,:,i),LatAccelG(:,:,i),Betamax(:,:,i),YawVelo(:,:,i),LongVelo(:,:,i),LateralVelo(:,:,i)] = SlipAngleCalc(SteerAngles(:,:,j),Beta(:,k),Velocity,Radius(:,i),vehicleObj);
            
            [Fz(:,:,i),LLT(:,:,i),LLT_D(:,:,i),R_g(:,:,i),Roll_Angle(:,:,i),Z(:,:,i)] = LLTSim(K_roll,Velocity,Accel(:,2),vehicleObj);
            
            [IA(:,:,i)] = CamberSim(Roll_Angle(:,:,i),SWAngle,vehicleObj);
            
            [Fx(:,:,i),Fy(:,:,i),Mz(:,:,i)] = findTireFM(model,SlipAngles(:,:,i),IA(:,:,i),Fz(:,:,i),vehicleObj.TirePressure);
            
            if(Velocity == 0)
                Fx = [0 0; 0 0];
                Fy = [0 0; 0 0];
                Mz = [0 0; 0 0];
            end
            
            [YM(:,:,i),Accel(:,:,i)] = YMSim(SteerAngles(:,:,j),Fx(:,:,i),Fy(:,:,i),Mz(:,:,i),vehicleObj);
            
            disp('Radius: ');
            disp(Radius(:,i));
            disp('Steering Wheel Angle: ');
            disp(SWAngle(:,j));
%             disp('Beta: ');
%             disp(Beta(:,k));
%             disp('Roll Angle: ');
%             disp(Roll_Angle(:,:,i));
%             disp('Slip Angles: ');
%             disp(SlipAngles(:,:,i));
%             disp('Fx: ');
%             disp(Fx(:,:,i));
%             disp('Fy: ');
%             disp(Fy(:,:,i));
%             disp('Fz: ');
%             disp(Fz(:,:,i));
%             disp('Mz: ');
%             disp(Mz(:,:,i));
            disp('Gs: ');
            disp(Accel(:,:,i));
%             disp('Acceleration: ');
%             disp(LatAccelG(:,:,i));
            disp('Yaw Moment: ');
            disp(YM(:,:,i));
%             disp('Camber: ');
%             disp(IA(:,:,i));
%             disp('Wheel Displacement: ');
%             disp(Z(:,:,i));
%             disp('Tire Pressure: ');
%             disp(vehicleObj.TirePressure);
            disp('----------------------');
       
        end
    end
end

=======
%% Tuned Car Parameters

% Tire Spring Rates (lbf/in)
[K_t] = SpringRateCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicleObj);

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

%% Motor Parameters

Max_Velocity = 86; % mph

%% Inputs

n = 101;

ConstantVelocity = 20; % mph
VelocityInput = 0.1; % mph

SWAngle = linspace(-90,90,n); % deg (pos->Right, neg->Left)

Beta = 0; % deg (pos->Right, neg->Left)

Radius = 329; % in (pos->Right, neg->Left)

converge = false;

%% Calculations

% Constant Radius
% YMGradient = zeros(1,numel(SWAngle));
% AccelGradient = zeros(1,numel(SWAngle));
% 
% for i = 1:numel(SWAngle)
%     while(converge == false)
% 
%         if SWAngle(i) < 0
%             RadiusInput = -Radius;
%         else
%             RadiusInput = Radius;
%         end
% 
%         [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle(i),vehicleObj);
% 
%         [SlipAngles] = SlipAngleCalc(SteerAngles,BetaInput,VelocityInput,RadiusInput,vehicleObj);
% 
%         if max(max(abs(SlipAngles))) > 13 %max slip angle tested by TTC
%             Accel = 0;
%             if Accel == 0
%                 Accel(1,2) = 0;
%             end
%             YM = 0;
%             break %no calculations for conditions outside of testing limits
%         end
% 
%         Accelcalc = -((VelocityInput*17.6)^2/RadiusInput)/386.4; % g's
% 
%         [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,VelocityInput,Accelcalc,vehicleObj);
% 
%         [IA] = CamberCalc(Z,Roll_Angle,SWAngle(i),vehicleObj);
% 
%         [Fx,Fy,Mz] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);
% 
%         [YM,Accel] = YMCalc(SteerAngles,Fx,Fy,Mz,vehicleObj);
% 
%         % [Calpha] = CstiffCalc(Fz,model.FyFront,model.FyRear,vehicleObj);
%         %
%         % MaxBeta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*(((VelocityInput*17.6)^2)/(Radius*386.4))));
%         %
%         % if SWAngle < 0
%         %         MaxBeta = -MaxBeta;
%         % else
%         %         MaxBeta = MaxBeta;
%         % end
% 
%         if (abs(Accelcalc - Accel(1,2))>(0.0001*abs(Accelcalc)))
%             Vcalc = sqrt(abs((Accel(1,2)*386.4))*Radius)./17.6;
%             VelocityInput = Vcalc;
%         else
%             converge = true;
%         end
% 
%     end
% 
%     YMGradient(1,i) = YM;
%     AccelGradient(1,i) = Accel(1,2);
% 
%     converge = false;
% end

% Constant Velocity
YMGradient = zeros(1,numel(SWAngle));
AccelGradient = zeros(1,numel(SWAngle));
VeloGradient = zeros(1,numel(SWAngle));

for i = 1:numel(SWAngle)
    while(converge == false)

        if SWAngle(i) < 0
            RadiusInput = -Radius;
        else
            RadiusInput = Radius;
        end

        [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle(i),vehicleObj);

        [SlipAngles] = SlipAngleCalc(SteerAngles,BetaInput,ConstantVelocity,RadiusInput,vehicleObj);

        if max(max(abs(SlipAngles))) > 13 %max slip angle tested by TTC
            Accel = 0;
            if Accel == 0
                Accel(1,2) = 0;
            end
            YM = 0;
            break %no calculations for conditions outside of testing limits
        end

        Accelcalc = -((ConstantVelocity*17.6)^2/RadiusInput)/386.4; % g's

        [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,ConstantVelocity,Accelcalc,vehicleObj);

        [IA] = CamberCalc(Z,Roll_Angle,SWAngle(i),vehicleObj);

        [Fx,Fy,Mz] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);

        [YM,Accel] = YMCalc(SteerAngles,Fx,Fy,Mz,vehicleObj);

        % [Calpha] = CstiffCalc(Fz,model.FyFront,model.FyRear,vehicleObj);
        %
        % MaxBeta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*(((VelocityInput*17.6)^2)/(Radius*386.4))));
        %
        % if SWAngle < 0
        %         MaxBeta = -MaxBeta;
        % else
        %         MaxBeta = MaxBeta;
        % end

        Vcalc = sqrt(abs((Accel(1,2)*386.4))*Radius)./17.6;

        if (abs(Accelcalc - Accel(1,2))>(0.0001*abs(Accelcalc)))
            RadiusInput = ConstantVelocity^2/Accel(1,2);
        else
            converge = true;
        end

    end

    YMGradient(1,i) = YM;
    AccelGradient(1,i) = Accel(1,2);
    VeloGradient(1,i) = Vcalc;

    converge = false;
end

%% Plot - YMD

% Constant Radius
% PlotData = [SWAngle; AccelGradient; YMGradient];
% 
% figure('Name','Plot - YMD');
% title('Yaw Moment Diagram');
% hold on
% xlabel('Acceleration (Gs)');
% hold on
% ylabel('Yaw Moment (lb-in)');
% hold on
% grid on
% 
% plot(AccelGradient,YMGradient,'r*');
% hold on

% Constant Velocity
PlotData = [SWAngle; AccelGradient; YMGradient; VeloGradient];

figure('Name','Plot - YMD');
title('Yaw Moment Diagram');
hold on
xlabel('Acceleration (Gs)');
hold on
ylabel('Yaw Moment (lb-in)');
hold on
grid on

plot(AccelGradient,YMGradient,'r*');
hold on

% disp('Velocity: ');
% disp(Vcalc);
% disp('Radius: ');
% disp(Radius);
% disp('Steering Wheel Angle: ');
% disp(SWAngle);
% disp('Input Beta: ');
% disp(BetaInput);
% disp('Max Beta: ');
% disp(MaxBeta);
% disp('Roll Angle: ');
% disp(Roll_Angle);
% disp('Slip Angles: ');
% disp(SlipAngles);
% disp('Fx: ');
% disp(Fx);
% disp('Fy: ');
% disp(Fy);
% disp('Fz: ');
% disp(Fz);
% disp('Mz: ');
% disp(Mz);
% disp('Gs: ');
% disp(Accel);
% disp('Acceleration: ');
% disp(LatAccelG);
% disp('Yaw Moment: ');
% disp(YM);
% disp('Camber: ');
% disp(IA);
% disp('Wheel Displacement: ');
% disp(Z);
% disp('Tire Pressure: ');
% disp(vehicleObj.TirePressure);
% disp('----------------------');
>>>>>>> main
