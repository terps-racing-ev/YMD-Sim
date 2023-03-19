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
filename.FrontTire = 'A1965run17.mat';
filename.RearTire = 'A1965run17.mat';
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
n = 1;

% Input Test Cornering Parameters
Radius = 348; %in (neg -> Left, pos -> Right)
Velocity = 10; %linspace(0,35,4); %mph

% Input Steering Wheel Angle, CoG Slip Angle
SWAngle = 0; %linspace(-90,90,5); %deg (L = neg, R = pos)
Beta = 0; %linspace(-10,10,5); %CoG slip angle (deg) (neg -> Right, pos -> Left)

%% Code

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_t,vehicleObj);

% Steering Angles (deg), Slip Angles (deg), Load Transfer (lb), Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))
for j = 1:length(SWAngle)
    for k = 1:length(Beta)
        for i = 1:length(Velocity)
            
            SteerAngles(:,:,j) = SteerAngleSim(SWAngle(:,j),vehicleObj);
            
            [SlipAngles(:,:,i),LatAccelG(:,:,i),Betamax(:,:,i),YawVelo(:,:,i),LateralVelo(:,:,i)] = SlipAngleSim(SteerAngles(:,:,j),Beta(:,k),Velocity(:,i),Radius,vehicleObj);
            
            [Fz(:,:,i),LLT(:,:,i),LLT_D(:,:,i),R_g(:,:,i),Roll_Angle(:,:,i),Z(:,:,i)] = LLTSim(K_roll,LatAccelG(:,:,i),vehicleObj);
            
            [IA(:,:,i)] = CamberSim(Roll_Angle(:,:,i),SWAngle,vehicleObj);
            
            [Fx(:,:,i),Fy(:,:,i),Mz(:,:,i)] = findTireFM(model,SlipAngles(:,:,i),IA(:,:,i),Fz(:,:,i),vehicleObj.TirePressure);
            
            if(Velocity(:,i) == 0)
                Fx = [0 0; 0 0];
                Fy = [0 0; 0 0];
                Mz = [0 0; 0 0];
            end
            
            [YM(:,:,i),Accel(:,:,i)] = YMSim(SteerAngles(:,:,j),Fx(:,:,i),Fy(:,:,i),Mz(:,:,i),vehicleObj);
            
            disp('Velocity: ');
            disp(Velocity(:,i));
            disp('Gs: ');
            disp(LatAccelG(:,:,i));
            disp('Steering Wheel Angle: ');
            disp(SWAngle(:,j));
            disp('Beta: ');
            disp(Beta(:,k));
            disp('Roll Angle: ');
            disp(Roll_Angle(:,:,i));
            disp('Slip Angles: ');
            disp(SlipAngles(:,:,i));
            disp('Fx: ');
            disp(Fx(:,:,i));
            disp('Fy: ');
            disp(Fy(:,:,i));
            disp('Fz: ');
            disp(Fz(:,:,i));
            disp('Mz: ');
            disp(Mz(:,:,i));
            disp('Yaw Moment: ');
            disp(YM(:,:,i));
            disp('Acceleration: ');
            disp(Accel(:,:,i));
            disp('Camber: ');
            disp(IA(:,:,i));
            disp('Wheel Displacement: ');
            disp(Z(:,:,i));
            disp('Tire Pressure: ');
            disp(vehicleObj.TirePressure);
        end
    end
end

