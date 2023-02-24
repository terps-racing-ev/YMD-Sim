%% ARB Design Calc

% This calculator helps in the design of the ARB, finding the K_ARB of a
% test design with car parameters

clc

%% Inputs

% Input Car Parameters
Weight = 650; %lb
K_t = [548 548; 548 548];%lbf/in

K_s = [200 200; 250 250]; %lbf/in
K_ARB = [0 0]; %lbf/in

MR_s = [0.5 0.5; 0.5 0.5];
MR_ARB = [0.5 0.5];

CoGh_RCA = 7.03608; %in
Track = [48;44];

% Input Testing Parameters: Desired Roll Gradient
RG = [2.8;3]; %deg/g

%% Calculations

% Stiffnesses (lbf/in)
[K_w,K_r] = StiffnessSim(K_s,K_ARB,K_t,MR_s,MR_ARB);

% Desired Roll Rate (lbf-in/deg roll)
DesRollRate = [(Weight*386.4*CoGh_RCA)/RG(1,1);(Weight*386.4*CoGh_RCA)/RG(2,1)];

% Desired ARB Roll Rate for Desired Roll Gradient
RollARBneeded = [abs(((pi/180)*((DesRollRate(1,:)*K_t(1,1)*(Track(1,:)^2))/((K_t(1,1)*(Track(1,:)^2)*(pi/180))-DesRollRate(1,:)))) - ((pi()*K_w(1,1)*(Track(1,:)^2))/180));
    abs(((pi/180)*((DesRollRate(2,:)*K_t(2,1)*(Track(2,:)^2))/((K_t(2,1)*(Track(2,:)^2)*(pi/180))-DesRollRate(2,:)))) - ((pi()*K_w(2,1)*(Track(2,:)^2))/180))];
