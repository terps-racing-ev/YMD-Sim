%% Slip Angle Calculator

function [SlipAngles] = SlipAngleCalc(SteerAngles,Beta,Velocity,Radius,vehicle)
    
    % Velocity Calculations
    Velocityin_s = Velocity * 17.6; % in/s
    YawVelo = (Velocityin_s/Radius); % rad/s

    % Slip Angle Calculations
    % Components
    Vy = Velocityin_s*sind(Beta); % in/s
    Vx = Velocityin_s*cosd(Beta); % in/s
    LatCompF = vehicle.FrontAxleToCoG*YawVelo;
    LongCompF = (vehicle.FrontTrackWidth/2)*YawVelo;
    LatCompR = vehicle.CoGToRearAxle*YawVelo;
    LongCompR = (vehicle.RearTrackWidth/2)*YawVelo;
    
    % Slip Angles
    SlipAngleFL = SteerAngles(1,1)-atand((Vy+LatCompF)/(Vx+LongCompF));
    SlipAngleFR = SteerAngles(1,2)-atand((Vy+LatCompF)/(Vx-LongCompF));
    SlipAngleRL = atand((Vy-LatCompR)/(Vx+LongCompR));
    SlipAngleRR = atand((Vy-LatCompR)/(Vx-LongCompR));

    SlipAngles = [SlipAngleFL,SlipAngleFR; SlipAngleRL,SlipAngleRR];
    
end
