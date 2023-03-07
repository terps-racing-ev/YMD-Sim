%% Optimal Steering Angle

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
Wheelbase = vehicleObj.Wheelbase();
TrackWidth = vehicleObj.TrackWidth();
FTrackWidth = TrackWidth(1,:);
Ackermann = vehicleObj.Ackermann();
Toe = vehicleObj.Toe();
FToe = Toe(1,:);
a = vehicleObj.FrontAxleToCoG();
b = vehicleObj.CoGToRearAxle();
CoGh_RA = vehicleObj.CoGhRA();

K_s = vehicleObj.K_s();
K_ARB = vehicleObj.K_ARB();
MR_s = vehicleObj.MR_s();
MR_ARB = vehicleObj.MR_ARB();

K_t = [548 548; 548 548];%lbf/in 

% Input Steering Wheel Angle
SWAngle = 0; %deg (L = neg, R = pos)

% Input Test Cornering Parameters
Velocity = 27.1656; %mph
Radius = 348; %in
Beta = linspace(-4.8094,4.8094,25); %CoG slip angle (deg) (neg -> Right, pos -> Left)

SlipCarParameters = [a; b; TrackWidth(1,:); TrackWidth(2,:)];
    
%% Code

SteerAngles = SteerAngleSim(SWAngle,Wheelbase,FTrackWidth,Ackermann,FToe);

% figure('Name','Optimal Steering Angle');
% plot(SWAngle,SteerAngles(:,1),'-r*');
% hold on
% plot(SWAngle,SteerAngles(:,2),'-ro');
% hold on
% title('Steering Angle Sweep');
% xlim([-90 90]);
% legend(' FL',' FR','Location','eastoutside')

i = 1;
count = 1:1:25;
for j = 1:2:50
    [SlipAngles,AccelG,Betamax] = SlipAngleSim(SteerAngles,Beta(:,count),Velocity,Radius,SlipCarParameters);
    OptSA = [(Wheelbase/Radius) + SlipAngles(i,j) - SlipAngles(i,j+1), (Wheelbase/Radius) + SlipAngles(i+1,j) - SlipAngles(i+1,j+1)]
end