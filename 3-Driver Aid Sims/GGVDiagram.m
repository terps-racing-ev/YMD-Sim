%% G-G-V Diagram

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

Max_Velocity = 86; %mph

%% Inputs

DataPoints = 100;

% Velocity Sweep (mph)
Velocity = linspace(0,Max_Velocity,DataPoints);

%% G-G-V - Grip Limited (No Camber Change)

% Acceleration Sweep

Accel = true;

AccelGsM = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),0,K_r,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    % Dynamic Weights (lb) -> Max Fx from Weight Transfer
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),g_avg,K_r,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    AccelGsM(1,i) = g_avg;
end

% Deceleration Sweep

Accel = false;

DecelGsM = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),0,K_r,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    % Dynamic Weights (lb) -> Max Fx from Weight Transfer
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),g_avg,K_r,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    DecelGsM(1,i) = g_avg;
end

% Cornering Sweep

% Right Turn
RightTurn = true;

RightLatGsM = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    mu_drive = g_avg;

    % Dynamic Weights (lb) -> Max Fy from Weight Transfer
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity(i),mu_drive,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    RightLatGsM(1,i) = g_avg;
end


% Left Turn
RightTurn = false;

LeftLatGsM = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
        % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    mu_drive = g_avg;

    % Dynamic Weights (lb) -> Max Fy from Weight Transfer
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity(i),mu_drive,vehicleObj);

    IA = [0, 0; 0, 0];

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    LeftLatGsM(1,i) = g_avg;
end

%% G-G-V - Suspension Limited (Camber Change)

% Acceleration Sweep

Accel = true;

AccelGsA = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),0,K_r,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    % Dynamic Weights (lb) -> Max Fx from Weight Transfer
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),g_avg,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    AccelGsA(1,i) = g_avg;
end

% Deceleration Sweep

Accel = false;

DecelGsA = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),0,K_r,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    % Dynamic Weights (lb) -> Max Fx from Weight Transfer
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),g_avg,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if Accel == false
        Fx_max = mu.*Fz;
    else
        Fx_max = -(mu.*Fz);
    end

    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));

        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    DecelGsA(1,i) = g_avg;
end

% Cornering Sweep

% Right Turn
RightTurn = true;

RightLatGsA = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    mu_drive = g_avg;

    % Dynamic Weights (lb) -> Max Fy from Weight Transfer
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity(i),mu_drive,vehicleObj);

    [IA] = CamberCalc(Z,Roll_Angle,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    RightLatGsA(1,i) = g_avg;
end


% Left Turn
RightTurn = false;

LeftLatGsA = zeros(1,numel(Velocity));

for i = 1:numel(Velocity)
        % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    mu_drive = g_avg;

    % Dynamic Weights (lb) -> Max Fy from Weight Transfer
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity(i),mu_drive,vehicleObj);

    [IA] = CamberCalc(Z,Roll_Angle,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);

    if RightTurn == true
        Fy_max = -(mu.*Fz);
    else
        Fy_max = mu.*Fz;
    end

    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    LeftLatGsA(1,i) = g_avg;
end


%% G-G-V Plotting

PlotDataM = [Velocity; AccelGsM; DecelGsM; LeftLatGsM; RightLatGsM];
PlotDataA = [Velocity; AccelGsA; DecelGsA; LeftLatGsA; RightLatGsA];

figure('Name','Plot - G-G-V Diagrams');
tiledlayout(1, 2)

nexttile

% G-G-V - Grip Limited (No Camber Change)
title('G-G-V Diagram (Grip Limited)');
hold on
xlabel('Longitudinal Gs');
hold on
ylabel('Lateral Gs');
hold on
zlabel('Velocity (mph)');
hold on
grid on

view([-37.5, 10]);
hold on
plot3(AccelGsM,zeros(numel(Velocity)),Velocity,'g');
hold on
plot3(DecelGsM,zeros(numel(Velocity)),Velocity,'r');
hold on
plot3(zeros(numel(Velocity)),RightLatGsM,Velocity,'b');
hold on
plot3(zeros(numel(Velocity)),LeftLatGsM,Velocity,'b');
hold off

nexttile

% G-G-V - Suspension Limited (Camber Change)
title('G-G-V Diagram (Suspension Limited)');
hold on
xlabel('Longitudinal Gs');
hold on
ylabel('Lateral Gs');
hold on
zlabel('Velocity (mph)');
hold on
grid on

view([-37.5, 10]);
hold on
plot3(AccelGsA,zeros(numel(Velocity)),Velocity,'g');
hold on
plot3(DecelGsA,zeros(numel(Velocity)),Velocity,'r');
hold on
plot3(zeros(numel(Velocity)),RightLatGsA,Velocity,'b');
hold on
plot3(zeros(numel(Velocity)),LeftLatGsA,Velocity,'b');
hold off