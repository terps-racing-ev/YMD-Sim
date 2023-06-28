%% Slip Angle Simulator

function [SlipAngles,AccelG,Betamax,YawVelo,LongVelo,LateralVelo] = SlipAngleSim(SteerAngles,Beta,Velocity,Radius,vehicle)
    % Velocity Calculations
    LongVelo = Velocity * 17.6; %in/s
    % Accel = -Velocityin_s.^2/Radius; %in/s^2
    LateralVelo = -LongVelo*tand(Beta); %in/s
    YawVelo = (LongVelo/cosd(Beta))/-Radius; %rad/s
    AccelG = ((LongVelo/cosd(Beta))*YawVelo)/386.4; %g's
    
    % CoG Slip Angle Calculations
    Betamax = (atan(vehicle.CoGToRearAxle/-Radius))*(180/pi); %deg
    % neg -> Right, pos -> Left
    
    % Steer Angle Conversion (rad)
    SteerAnglesrad = deg2rad(-SteerAngles);
    
    % Slip Angle Calculations
    SlipAnglesF = [((((LateralVelo + (YawVelo*vehicle.FrontAxleToCoG))/(LongVelo-(YawVelo*(vehicle.FrontTrackWidth/2))))-SteerAnglesrad(1,1))),((((LateralVelo + (YawVelo*vehicle.FrontAxleToCoG))/(LongVelo+(YawVelo*(vehicle.FrontTrackWidth/2))))-SteerAnglesrad(1,2)))];
    SlipAnglesR = [((((LateralVelo - (YawVelo*vehicle.CoGToRearAxle))/(LongVelo-(YawVelo*(vehicle.RearTrackWidth/2)))))-SteerAnglesrad(2,1)),((((LateralVelo - (YawVelo*vehicle.CoGToRearAxle))/(LongVelo+(YawVelo*(vehicle.RearTrackWidth/2))))-SteerAnglesrad(2,2)))];
            
    if(Beta == 0)
        SlipAnglesF = [-SteerAnglesrad(1,1),-SteerAnglesrad(1,2)];
        SlipAnglesR = [-SteerAnglesrad(2,1),-SteerAnglesrad(2,2)];
    end
    
    SlipAngles = [SlipAnglesF; SlipAnglesR]*(180/pi);
    
    if(Velocity == 0)
        SlipAngles = [0 0; 0 0];
        Betamax = 0;
        YawVelo = 0;
    end
    
end
