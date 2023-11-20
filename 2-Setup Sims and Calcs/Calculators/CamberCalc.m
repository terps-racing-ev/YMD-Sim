%% Camber Calculator

function [IA] = CamberCalc(Z,RollAngle,SWAngle,vehicle)
    % Calculating the camber change given Bump, Roll, and Steer

    % Bump
    BumpCamber = [vehicle.BumpC(Z)];

    % Roll
    RollCamber = [vehicle.RollC(RollAngle)];

    % Steer
    SteerCamber = [vehicle.SteerC(SWAngle)];

    CamberGain = BumpCamber + RollCamber + SteerCamber;

    % Camber Gain
    IA = [vehicle.Camber(1,1)+CamberGain(1,1), vehicle.Camber(1,2)+CamberGain(1,2);
        vehicle.Camber(2,1)+CamberGain(2,1), vehicle.Camber(2,2)+CamberGain(2,2)];
        
end
