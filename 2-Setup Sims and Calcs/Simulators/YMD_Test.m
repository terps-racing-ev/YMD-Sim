 %% YMD Test
% Credit - LJ Hamilton

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

