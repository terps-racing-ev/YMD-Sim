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

%% Inputs

n = 101;

ConstantVelocity = 20; % mph
VelocityInput = 0.1; % mph

SWAngle = linspace(-90,90,n); % deg (pos->Right, neg->Left)

BetaInput = 0; % deg (pos->Right, neg->Left)

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