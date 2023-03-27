% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);
vehicleObj = TREV2Parameters();

%% Uncomment when want to use (command + T or ctrl + T)

% fprintf("Steer Camber LHS initial conditions test: ")
% vehicleObj.steerCamberLHS(0)
% 
% fprintf("Steer Camber LHS extrapolate conditions test: ")
% vehicleObj.steerCamberLHS(-90)
% 
% fprintf("Steer Camber RHS initial conditions test: ")
% vehicleObj.steerCamberRHS(0)
% 
% fprintf("Steer Camber RHS extrapolate conditions test: ")
% vehicleObj.steerCamberRHS(90)
% 
% vehicleObj.graphRolls()