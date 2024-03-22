%% Slip Angle Calculator

function [SlipAngles] = SlipAngleCalc(SteerAngles,Beta,Velocity,Radius,vehicle)
    
    % Velocity Calculations
    Velocityin_s = Velocity * 17.6; % in/s
    %YawVelo = (Velocityin_s/Radius); % rad/s
    YawVelo = 0.5;
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

    %Ryan's Attempt
    %r = [LatCompF,LatCompF;LatCompR,LatCompR] + 1i*[LongCompF,LongCompF;LongCompR,LongCompR];
    %v = Velocityin_s*cosd(Beta)/12+1i*Velocityin_s*sind(Beta)/12;
    %SlipAngles = SteerAngles*pi/180 + [0,0;-vehicle.Toe(2),vehicle.Toe(4)]*pi/180 +angle([v,v;v,v]) + r*1i;
    
    
end
