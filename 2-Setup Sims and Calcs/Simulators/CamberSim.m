%% Camber Simulator

function [IA] = CamberSim(Camber,RollAngle,SWAngle,RollGainC,SteerGainC)
    % Calculating the camber change given Steering Wheel Angle and Roll Angle
    RollGain = [RollAngle*RollGainC(1,1), RollAngle*RollGainC(1,2);
        RollAngle*RollGainC(2,1), RollAngle*RollGainC(2,2)];
    
    SteerGain = [SWAngle*SteerGainC(1,1), SWAngle*SteerGainC(1,2);
        SWAngle*SteerGainC(2,1), SWAngle*SteerGainC(2,2)];
    
    CamberGain = [RollGain(1,1)+SteerGain(1,1), RollGain(1,2)+SteerGain(1,2);
        RollGain(2,1)+SteerGain(2,1), RollGain(2,2)+SteerGain(2,2)];
    
    % Camber Gain
    IA = [Camber(1,1)+CamberGain(1,1), Camber(1,2)+CamberGain(1,2);
        Camber(2,1)+CamberGain(2,1), Camber(2,2)+CamberGain(2,2)];
        
end
