%% ARB Design Calc

% This calculator helps in the design of the ARB, finding the K_ARB of a
% test design with car parameters

clc

%% Inputs

% Input Car Parameters
Weight = 650; %lb
CoGh_RCA = 7.03608; %in
Track = [48;44];

% Input Testing Parameters
RG = [2.8;3]; %deg/g

% Calculations

% 
RollRate = [(Weight*CoGh_RCA)/RG(1,1);(Weight*CoGh_RCA)/RG(2,1)]; %lb-in/deg
