%% Steering Angle Calculator
% Credit: CAPT Hamilton

function [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle,vehicle)
    % Unit Conversions
    Wheelbaseft = vehicle.Wheelbase/12; %ft
    FTrackWidthft = vehicle.FrontTrackWidth/12; %ft

    % Turning Radius (ft)
    TurnRadius = Wheelbaseft./tand(SWAngle);
    
    % R&L Steering Angle for 100% Ackermann 
    AckSteerAngleR = atand(Wheelbaseft./(TurnRadius - FTrackWidthft/2));
    AckSteerAngleL = atand(Wheelbaseft./(TurnRadius + FTrackWidthft/2));
    
    %IDK WHAT THE ISSUE WAS HERE BUT NOW IT MATCHES HAMILTON
    % Differences
    DiffL = AckSteerAngleR - SWAngle; 
    DiffR = SWAngle - AckSteerAngleL;
    
    % Final Steering Angles
    SteerAngleR = SWAngle - vehicle.Ackermann*DiffR - vehicle.Toe(1,2);
    SteerAngleL = SWAngle + vehicle.Ackermann*DiffL + vehicle.Toe(1,1);
    
    SteerAnglesF = [SteerAngleR, SteerAngleL];
    SteerAnglesR = [vehicle.Toe(2,1), -vehicle.Toe(2,2)];
    
    SteerAngles = [SteerAnglesF; SteerAnglesR];
end
