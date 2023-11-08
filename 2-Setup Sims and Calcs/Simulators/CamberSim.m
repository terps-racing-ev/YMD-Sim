%% Camber Calculator

function [IA] = CamberSim(RollAngle,SWAngle,vehicle)
    % Calculating the camber change given Steering Wheel Angle and Roll Angle
    RollGain = [vehicle.RollCFL(RollAngle),vehicle.RollCFR(RollAngle);
        vehicle.RollCRL(RollAngle), vehicle.RollCRR(RollAngle)];
    
%     SteerGain = [vehicle.SteerCFL(SWAngle), vehicle.SteerCFR(SWAngle);
%         vehicle.SteerCFL(SWAngle), vehicle.SteerCFR(SWAngle)];
%     
%     CamberGain = [RollGain(1,1)+SteerGain(1,1), RollGain(1,2)+SteerGain(1,2);
%         RollGain(2,1)+SteerGain(2,1), RollGain(2,2)+SteerGain(2,2)];
    
    CamberGain = [RollGain(1,1), RollGain(1,2); RollGain(2,1), RollGain(2,2)];

    % Camber Gain
    IA = [vehicle.Camber(1,1)+CamberGain(1,1), vehicle.Camber(1,2)+CamberGain(1,2);
        vehicle.Camber(2,1)+CamberGain(2,1), vehicle.Camber(2,2)+CamberGain(2,2)];
        
end
