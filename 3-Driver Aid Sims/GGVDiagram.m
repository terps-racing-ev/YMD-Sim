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

filename_P1 = 'A2356run8.mat';
[latTrainingData_P1,tireID,testID] = createLatTrngDataCalc(filename_P1);

filename_P2 = 'A2356run9.mat';
[latTrainingData_P2,tireID,testID] = createLatTrngDataCalc(filename_P2);

totData = cat(1,latTrainingData_P1,latTrainingData_P2);
trainData = latTrainingData_P1;

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

%% Acceleration Sweep

Accel = true;

AccelGs = [];

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity(i),0,K_r,vehicleObj);
    
    if Accel == false
        Fx_max = [mu_F;mu_R].*Fz;
    else
        Fx_max = -([mu_F;mu_R].*Fz);
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
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity(i),g_avg,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    if Accel == false
        Fx_max = [mu_F;mu_R].*Fz;
    else
        Fx_max = -([mu_F;mu_R].*Fz);
    end
    
    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));
    
        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    AccelGs(1,i) = g_avg;
end

%% Deceleration Sweep

Accel = false;

DecelGs = [];

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity(i),0,K_r,vehicleObj);
    
    if Accel == false
        Fx_max = [mu_F;mu_R].*Fz;
    else
        Fx_max = -([mu_F;mu_R].*Fz);
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
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu_R),Velocity(i),g_avg,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    if Accel == false
        Fx_max = [mu_F;mu_R].*Fz;
    else
        Fx_max = -([mu_F;mu_R].*Fz);
    end
    
    if Accel == false
        g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    else
        g_avg = sum(Fx_max(2,:))/(sum(sum(-vehicleObj.staticWeights)));
    
        if (Accelmax_static < g_avg)
            g_avg = Accelmax_static;
        end
    end

    DecelGs(1,i) = g_avg;
end

%% Cornering Sweep

% Right Turn
RightTurn = true;

RightLatGs = [];

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    if RightTurn == true
        Fy_max = -([mu_F;mu_R].*Fz);
    else
        Fy_max = [mu_F;mu_R].*Fz;
    end
    
    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));
    
    mu_drive = g_avg;
    
    % Dynamic Weights (lb) -> Max Fy from Weight Transfer
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity(i),mu_drive,vehicleObj);
    
    mu = [mu_F,mu_R];
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    if RightTurn == true
        Fy_max = -([mu_F;mu_R].*Fz);
    else
        Fy_max = [mu_F;mu_R].*Fz;
    end
    
    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    RightLatGs(1,i) = g_avg;
end


% Left Turn
RightTurn = false;

LeftLatGs = [];

for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    if RightTurn == true
        Fy_max = -([mu_F;mu_R].*Fz);
    else
        Fy_max = [mu_F;mu_R].*Fz;
    end
    
    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));
    
    mu_drive = g_avg;
    
    % Dynamic Weights (lb) -> Max Fy from Weight Transfer
    [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,Velocity(i),mu_drive,vehicleObj);
    
    mu = [mu_F,mu_R];
    
    mu_F = [real(polyval(F_polyCalc,log(Fz(1,1)))), real(polyval(F_polyCalc,log(Fz(1,2))))];
    mu_R = [real(polyval(R_polyCalc,log(Fz(2,1)))), real(polyval(R_polyCalc,log(Fz(2,2))))];
    
    if RightTurn == true
        Fy_max = -([mu_F;mu_R].*Fz);
    else
        Fy_max = [mu_F;mu_R].*Fz;
    end
    
    g_avg = sum(reshape(Fy_max,[1,4]))/(sum(reshape((vehicleObj.staticWeights),[1,4])));

    LeftLatGs(1,i) = g_avg;
end

%% G-G-V Plotting

PlotData = [Velocity; AccelGs; DecelGs; LeftLatGs; RightLatGs];

figure(1)
title('G-G-V Diagram');
hold on
xlabel('Longitudinal Gs');
hold on
ylabel('Lateral Gs');
hold on
zlabel('Velocity (mph)');
hold on
grid on

plot3(AccelGs,zeros(numel(Velocity)),Velocity,'g');
hold on
plot3(DecelGs,zeros(numel(Velocity)),Velocity,'r');
hold on
plot3(zeros(numel(Velocity)),RightLatGs,Velocity,'b');
hold on
plot3(zeros(numel(Velocity)),LeftLatGs,Velocity,'b');
hold off
