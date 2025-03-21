%% Braking Setup

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

DataPoints = 87;

% Velocity Sweep (mph)
Velocity = linspace(0,Max_Velocity,DataPoints);

% Brake Proportioning Inputs
% Brake Proportioning Cutoff Pressure Value
brake_cutoff_F = 1200;
brake_cutoff_R = 1500;

% Brake Proportioning Ratio
brake_pressure_ratio_F = 0.3;
brake_pressure_ratio_R = 0.3;

%% Initial Brake Force, Driver Force, and Brake Cylinder Pressure Calculation

% Define Fz and mu Arrays and index
Fz_F = zeros(numel(Velocity),1);
Fz_R = zeros(numel(Velocity),1);
mu_F_arr = zeros(numel(Velocity),1);
mu_R_arr = zeros(numel(Velocity),1);

% Calculate static weight for F (lbf), weight transfer weight for R (lbf), and CoF at each velocity point
for i = 1:numel(Velocity)
    % Static Weights at Velocity (lb) -> Max G's Possible on Entry
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(0,Velocity(i),0,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);
    
    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),0,K_r,vehicleObj);

    Fz_F(i) = mean(-Fz(1,:));
    mu_F_arr(i) = mean(mu(1,:));
    
    Fx_max = mu.*Fz;

    g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));

    [Fz,LoLT,Accelmax_static,Pitch_Angle,Z] = LoLTCalc(mean(mu(2,:)),Velocity(i),g_avg,K_r,vehicleObj);

    [IA] = CamberCalc(Z,0,0,vehicleObj);

    [mu] = CoFCalc(abs(IA),Fz,model.muyFront,model.muyRear,vehicleObj);
   
    Fx_max = mu.*Fz;
    
    g_avg = sum(reshape(Fx_max,[1,4]))/(sum(reshape((-vehicleObj.staticWeights),[1,4])));
    
    Fz_R(i) = mean(-Fz(2,:));
    mu_R_arr(i) = mean(mu(2,:));
end

% Front and rear brake forces arrays
F_br_F = Fz_F.*mu_F_arr;
F_br_R = Fz_R.*mu_R_arr;

% Arrays for driver brake force and cylinder pressure for front/rear
F_driver_F_arr = zeros(numel(Velocity),1);
F_driver_R_arr = zeros(numel(Velocity),1);
P_F_arr = zeros(numel(Velocity),1);
P_R_arr = zeros(numel(Velocity),1);

% Create array for initial brake driver force and cylinder pressure
for i = 1:length(F_br_F)
    [F_driver_F, F_driver_R, P_F, P_R] = BrakingDFCalc(Fz_F(i,1), Fz_R(i,1), mu_F_arr(i,1), mu_R_arr(i,1), vehicleObj);

    F_driver_F_arr(i) = F_driver_F;
    F_driver_R_arr(i) = F_driver_R;
    P_F_arr(i) = P_F;
    P_R_arr(i) = P_R;

end

%% Modified Brake Force, Driver Force, and Brake Cylinder Pressure Calculation w/ Brake Proportioning

% Initialize array for new brake cylinder pressure and brake force
P_F_arr_BP = zeros(numel(Velocity),1);
P_R_arr_BP = zeros(numel(Velocity),1);
F_br_F_BP = zeros(numel(Velocity),1);
F_br_R_BP = zeros(numel(Velocity),1);

% Loop to apply brake proportioning at the correct cutoff pressure
for i = 1:length(P_F_arr)
    % Front brake porportioning
    if P_F_arr(i) > brake_cutoff_F
        P_F_arr_BP(i) = brake_cutoff_F + brake_pressure_ratio_F*(P_F_arr(i)-brake_cutoff_F);
    else
        P_F_arr_BP(i) = P_F_arr(i);
    end
    
    % Rear brake porportioning
    if P_R_arr(i) > brake_cutoff_R
        P_R_arr_BP(i) = brake_cutoff_R + brake_pressure_ratio_R*(P_R_arr(i)-brake_cutoff_R);
    else
        P_R_arr_BP(i) = P_R_arr(i);
    end
    
    % Calculate front and rear brake forces from new pressure values
    [Fb_F, Fb_R] = BrakingForceFromPCalc(P_F_arr_BP(i), P_R_arr_BP(i), vehicleObj);

    F_br_F_BP(i) = Fb_F;
    F_br_R_BP(i) = Fb_R;
end 

% Initialize new brake driver force arrays
F_driver_F_arr_BP = zeros(numel(Velocity),1);
F_driver_R_arr_BP = zeros(numel(Velocity),1);

% Populate new brake driver force arrays with calculated values
for i = 1:length(F_br_F_BP)
    % Use modified brake driver force function to work with F_br instead of Fz
    [F_driver_F_BP, F_driver_R_BP] = BrakingDFBPCalc(F_br_F_BP(i), F_br_R_BP(i), mu_F_arr(i, 1), mu_R_arr(i, 1), vehicleObj);

    F_driver_F_arr_BP(i) = F_driver_F_BP;
    F_driver_R_arr_BP(i) = F_driver_R_BP;
end

%% Brake Force, Driver Force, and Brake Line Pressure data vs. Velocity w/o and w/ Brake Proportioning

% w/o Brake Proportioning
figure('Name','Plot - Braking w/o Brake Proportioning');
tiledlayout(3, 1)

% Plot: brake force vs. velocity graph
nexttile

plot(Velocity, F_br_F)
hold on
plot(Velocity, F_br_R)
title("Brake Force vs. Velocity Graph")
xlabel("Velocity (mph)") 
ylabel("Brake Force (lbf)")
axis([0 Max_Velocity 0 600])
legend({'Front','Rear'},'Location','northwest')

% Plot: brake driver force vs. velocity graph
nexttile

plot(Velocity, F_driver_F_arr)
hold on
plot(Velocity, F_driver_R_arr)
title("Brake Driver Force vs. Velocity Graph")
xlabel("Velocity (mph)") 
ylabel("Brake Driver Force (lbf)")
axis([0 Max_Velocity 0 500])
legend({'Front','Rear'},'Location','northwest')

% Plot: brake cylinder pressure vs. velocity graph
nexttile

plot(Velocity, P_F_arr)
hold on
plot(Velocity, P_R_arr)
title("Brake Line Pressure vs. Velocity Graph")
xlabel("Velocity (mph)") 
ylabel("Brake Cylinder Pressure (psi)")
axis([0 Max_Velocity 0 3000])
legend({'Front','Rear'},'Location','northwest')

% w Brake Proportioning
figure('Name','Plot - Braking w/ Brake Proportioning');
tiledlayout(3, 1)

% Plot: brake force vs. velocity graph
nexttile

plot(Velocity, F_br_F_BP)
hold on
plot(Velocity, F_br_R_BP)
title("Brake Force vs. Velocity Graph")
xlabel("Velocity (mph)") 
ylabel("Brake Force (lbf)")
axis([0 Max_Velocity 0 600])
legend({'Front','Rear'},'Location','northwest')

% Plot: brake driver force vs. velocity graph
nexttile

plot(Velocity, F_driver_F_arr_BP)
hold on
plot(Velocity, F_driver_R_arr_BP)
title("Brake Driver Force vs. Velocity Graph")
xlabel("Velocity (mph)") 
ylabel("Brake Driver Force (lbf)")
axis([0 Max_Velocity 0 500])
legend({'Front','Rear'},'Location','northwest')

% Plot: brake cylinder pressure vs. velocity graph
nexttile

plot(Velocity, P_F_arr_BP)
hold on
plot(Velocity, P_R_arr_BP)
title("Brake Line Pressure vs. Velocity Graph")
xlabel("Velocity (mph)") 
ylabel("Brake Cylinder Pressure (psi)")
axis([0 Max_Velocity 0 3000])
legend({'Front','Rear'},'Location','northwest')

