%% ARB Stiffness Design Simulator

% This calculator helps in the design of the ARB, finding the K_ARB of a
% test design

close all
clearvars
clc

%% Inputs

% Input ARB Design Parameters

% Shear Modulus (psi)
% 6061 Aluminum: 3.77e6
% 7075 Aluminum: 2.69e7
% 4130 Steel: 1.16e7
% 4340 Steel: 1.16e7

% Young's Modulus (psi)
% 6061 Aluminum: 1.00e7
% 7075 Aluminum: 1.04e7
% 4130 Steel: 2.97e7
% 4340 Steel: 2.90e7

ShearMod = [1.16e7; 1.16e7]; %psi

OuterD_F = 0.5; %in
InnerD_F = 0.402; %in
TorsionL_F = 15; %in
LeverL_F = 2; %in

OuterD_R = 0.25; %in
InnerD_R = 0.12; %in
TorsionL_R = 15; %in
LeverL_R = 2; %in

%% Calculations

KARB_F = (pi*(OuterD_F^4-InnerD_F^4)*ShearMod(1,:))/(32*TorsionL_F*LeverL_F^2);
KARB_R = (pi*(OuterD_R^4-InnerD_R^4)*ShearMod(1,:))/(32*TorsionL_R*LeverL_R^2);

KARB = [KARB_F; KARB_R]
