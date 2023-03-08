%% Purojekuto (YM) D (Ryosuke's Mega Sim)

clc
clf

%% Inputs
% 1) Car, Aero, Alignment + Tuning Parameters-c
% 2) Input Tire Files and Train Tire Model - Credit: CAPT Hamilton

%% Part 1: Lap Time Simulator
% a) Acceleration Inputs + LT (Pedal Input->Torque Output->Fx,Fz)
% - Max Accel (G's) & Lap Time Chunk Sim - Credit: PWTR 
% b) Deceleration Inputs + LT (Pedal Input->Brake Force->Fx,Fz)
% - Max Decel (G's) & Lap Time Chunk Sim
% c) Cornering Inputs + LT (Steering Input->Tire Angle->SA->Beta->Fy,Fz,Mz)
% - Max Cornering (G's) & Lap Time Chunk Sim
% d) Steady State Inputs (Fz)
% - Lap Time Chunk Sim

% Ref: Excel 1,2,3,10,11

%% Part 2: YMD
% Christina Integration - Credit: CAPT Hamilton

%% Setup Sims and Calcs
% 1) Geo Points + Forces Sim
% - Tire Load Cases -> SUSP Forces Calcs
% - SUSP Material Calculator
% 2) Steering Angle Sweep Sim
% 3) Spring and Dampers w/ Bode Plot Calc
% 4) ARB Design Calc + Roll Gradient->K_ARB

%% Driver Aid Sims
% - Optimal Steer Angle (Entry & Apex)
% - Throttle Input -> Wheelspin
% - Brake Pedal Input -> Lock Up

