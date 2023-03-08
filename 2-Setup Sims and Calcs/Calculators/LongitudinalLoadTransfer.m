%% Longitudinal Load Transfer Test

clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = TREV2Parameters();

% Adding Additional Sims
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

%% Inputs

% Input Car Parameters
Weight = vehicleObj.TotalWeight();
StaticWeights = vehicleObj.staticWeights();
TrackWidth = vehicleObj.TrackWidth();
L = vehicleObj.Wheelbase();
CoGh = vehicleObj.CoGHeight();

K_s = vehicleObj.K_s();
K_ARB = vehicleObj.K_ARB();
MR_s = vehicleObj.MR_s();
MR_ARB = vehicleObj.MR_ARB();

K_t = [548 548; 548 548];%lbf/in 

% Input test G's Pulled (neg -> Left, pos -> Right)

Ax = 1.5;

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessSim(K_s,K_ARB,K_t,MR_s,MR_ARB,TrackWidth);

% Load Transfer (lb)
[LoLT] = LoLTSim(Weight,Ax,L,CoGh);

Fz = [StaticWeights(1,1)-(LoLT/2), StaticWeights(1,2)-(LoLT/2);
    StaticWeights(2,1)+(LoLT/2), StaticWeights(2,2)+(LoLT/2)];

% Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))
Z = [K_r(1,1)*(LoLT/2), K_r(1,2)*(LoLT/2);
    -K_r(2,1)*(LoLT/2), -K_r(2,2)*(LoLT/2)];

for i = 1:2
    for j = 1:2
        if(Z(i,j) < -1)
            Z(i,j) = -1;
        end
        if(Z(i,j) > 1)
            Z(i,j) = 1;
        end
    end
end

disp('Fz: ');
disp(Fz);
disp('Wheel Displacement: ');
disp(Z);