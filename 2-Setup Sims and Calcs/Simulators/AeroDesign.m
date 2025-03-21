%% Aero Design Simulator
% Credit - LJ Hamilton

close all
clearvars
clc

%% Inputs

% Downforce Total
Downforce_Total = 100;

% Aero Balance (Front Percent);
Aero_Balance = 0.4;

% Tire Data (equate psi -> K_t in excel)
Tire_psi = 8;
K_t = [442 442; 442 442]; %lbf/in 

% Test Corner Radius (in)
Radius = 348;

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

%% Car Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

% Roll Gradient (deg/g)
R_g = (vehicleObj.TotalWeight*vehicleObj.CoGhRA)./(K_roll(1,:)+K_roll(2,:));

%% muy Calculation Setup

[polyfits] = CoFCalc(latTrainingData_P1,latTrainingData_P2);

if (Tire_psi == 8)
    polyCalc = polyfits(1,:);
end

if (Tire_psi == 10)
    polyCalc = polyfits(2,:);
end

if (Tire_psi == 12)
    polyCalc = polyfits(3,:);
end

if (Tire_psi == 14)
    polyCalc = polyfits(5,:);
end

%% w/o DF Calculations

mu = [polyval(polyCalc,-vehicleObj.FrontStatic), polyval(polyCalc,-vehicleObj.RearStatic)];

mu_avg = mean(mu);

Fy_max = -vehicleObj.TotalWeight*mu_avg;

% Velocity (mph)
CornerSpeed = (sqrt((abs(Fy_max)*Radius)/(vehicleObj.TotalWeight/386.4))/17.6);

% Acceleration (G's)
LatAccel = Fy_max/vehicleObj.TotalWeight;

% Weight Transfer
% LLT (lb)
DeltaWF = (vehicleObj.TotalWeight/vehicleObj.FrontTrackWidth)*(((vehicleObj.CoGhRA*K_roll(1,:))/(K_roll(1,:)+K_roll(2,:)))+((vehicleObj.CoGToRearAxle/vehicleObj.Wheelbase)*vehicleObj.RollAxisF))*LatAccel;
DeltaWR = (vehicleObj.TotalWeight/vehicleObj.RearTrackWidth)*(((vehicleObj.CoGhRA*K_roll(2,:))/(K_roll(1,:)+K_roll(2,:)))+((vehicleObj.FrontAxleToCoG/vehicleObj.Wheelbase)*vehicleObj.RollAxisR))*LatAccel;

LLT = [DeltaWF; DeltaWR];

% Fz (lb)
Fz = -[vehicleObj.FrontStatic-LLT(1,:), vehicleObj.FrontStatic+LLT(1,:);
vehicleObj.RearStatic-LLT(2,:), vehicleObj.RearStatic+LLT(2,:)];

disp('w/o DF');
disp(' ');
disp('Fz = ');
disp(Fz);
disp('Velocity = ');
disp(CornerSpeed);
disp('Gs = ');
disp(LatAccel);
disp('----------------------');

%% w/ DF Calculations

FrontDFFz = ((Downforce_Total * Aero_Balance)/2);
RearDFFz = ((Downforce_Total * (1-Aero_Balance))/2);
FrontEffective = -vehicleObj.FrontStatic - FrontDFFz;
RearEffective = -vehicleObj.RearStatic - RearDFFz;

mu = [polyval(polyCalc,FrontEffective), polyval(polyCalc,RearEffective)];

mu_avg = mean(mu);

Fy_max = -(vehicleObj.TotalWeight+(FrontDFFz*2)+(RearDFFz*2))*mu_avg;

% Velocity (mph)
CornerSpeed = (sqrt((abs(Fy_max)*Radius)/(vehicleObj.TotalWeight/386.4))/17.6);

% Acceleration (G's)
LatAccel = Fy_max/vehicleObj.TotalWeight;

% Weight Transfer
% LLT (lb)
DeltaWF = (vehicleObj.TotalWeight/vehicleObj.FrontTrackWidth)*(((vehicleObj.CoGhRA*K_roll(1,:))/(K_roll(1,:)+K_roll(2,:)))+((vehicleObj.CoGToRearAxle/vehicleObj.Wheelbase)*vehicleObj.RollAxisF))*LatAccel;
DeltaWR = (vehicleObj.TotalWeight/vehicleObj.RearTrackWidth)*(((vehicleObj.CoGhRA*K_roll(2,:))/(K_roll(1,:)+K_roll(2,:)))+((vehicleObj.FrontAxleToCoG/vehicleObj.Wheelbase)*vehicleObj.RollAxisR))*LatAccel;

LLT = [DeltaWF; DeltaWR];

% Fz (lb)
Fz = -[vehicleObj.FrontStatic-LLT(1,:)+FrontDFFz, vehicleObj.FrontStatic+LLT(1,:)+FrontDFFz;
vehicleObj.RearStatic-LLT(2,:)+RearDFFz, vehicleObj.RearStatic+LLT(2,:)+RearDFFz];

disp('w/ DF');
disp(' ');
disp('Fz = ');
disp(Fz);
disp('Velocity = ');
disp(CornerSpeed);
disp('Gs = ');
disp(LatAccel);
disp('----------------------');