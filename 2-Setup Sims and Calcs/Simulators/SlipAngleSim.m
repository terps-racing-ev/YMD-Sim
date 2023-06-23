%% Slip Angle Simulator

function [SlipAngles,AccelG,Betamax,YawVelo,LateralVelo] = SlipAngleSim(SteerAngles,Beta,Velocity,Accel,Radius,vehicle)
    % Velocity Calculations
    Velocityin_s = Velocity * 17.6; %in/s
    % Accel = -Velocityin_s.^2/Radius; %in/s^2
    AccelG = -Accel/386.4; %g's
    YawVelo = -Accel/Velocityin_s; %rad/s
    LateralVelo = Velocityin_s*(Beta*(pi/180)); %(in-rad)/s
    
    % CoG Slip Angle Calculations
    Betamax = (-AccelG/AccelG)*(atan(vehicle.CoGToRearAxle/Radius))*(180/pi); %deg
    % neg -> Right, pos -> Left
    
    % Steer Angle Conversion (rad)
    SteerAnglesrad = deg2rad(-SteerAngles);
    
    % Slip Angle Calculations
<<<<<<< Updated upstream
    SlipAnglesF = [(-(((LateralVelo + (YawVelo*vehicle.FrontAxleToCoG))/(Velocityin_s-(YawVelo*(vehicle.FrontTrackWidth/2))))-SteerAnglesrad(1,1))),(-(((LateralVelo + (YawVelo*vehicle.FrontAxleToCoG))/(Velocityin_s+(YawVelo*(vehicle.FrontTrackWidth/2))))-SteerAnglesrad(1,2)))];
    SlipAnglesR = [(-(((LateralVelo - (YawVelo*vehicle.CoGToRearAxle))/(Velocityin_s-(YawVelo*(vehicle.RearTrackWidth/2)))))-SteerAnglesrad(2,1)),(-(((LateralVelo - (YawVelo*vehicle.CoGToRearAxle))/(Velocityin_s+(YawVelo*(vehicle.RearTrackWidth/2))))-SteerAnglesrad(2,1)))];
=======
    SlipAnglesF = [((((LateralVelo + (YawVelo*vehicle.FrontAxleToCoG))/(Velocityin_s-(YawVelo*(vehicle.FrontTrackWidth/2))))-SteerAnglesrad(1,1))),((((LateralVelo + (YawVelo*vehicle.FrontAxleToCoG))/(Velocityin_s+(YawVelo*(vehicle.FrontTrackWidth/2))))-SteerAnglesrad(1,2)))];
    SlipAnglesR = [((((LateralVelo - (YawVelo*vehicle.CoGToRearAxle))/(Velocityin_s-(YawVelo*(vehicle.RearTrackWidth/2)))))-SteerAnglesrad(2,1)),((((LateralVelo - (YawVelo*vehicle.CoGToRearAxle))/(Velocityin_s+(YawVelo*(vehicle.RearTrackWidth/2))))-SteerAnglesrad(2,2)))];
>>>>>>> Stashed changes
            
    SlipAngles = [SlipAnglesF; SlipAnglesR]*(180/pi);
    
    if(Velocity == 0)
        SlipAngles = [0 0; 0 0];
        Betamax = 0;
        YawVelo = 0;
    end
end
