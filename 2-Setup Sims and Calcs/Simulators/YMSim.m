%% Yaw Moment & Acceleration Sim

function [YM,Accel] = YMSim(SteerAngles,Fx,Fy,Mz,vehicle)
    
    SteerAnglesrad = SteerAngles*(180/pi);
    car_Fx = Fx.*cos(SteerAnglesrad) + Fy.*sin(SteerAnglesrad); %tire forces in car coordinate system
    car_Fy = Fx.*sin(SteerAnglesrad) + Fy.*cos(SteerAnglesrad); %tire forces in car coordinate system
    car_totalFx = sum(sum(car_Fx));
    car_totalFy = sum(sum(car_Fy));
    
    % Moment_armsx = [a, a; -b, -b];
    % Moment_armsy = [TrackWidth(1,:)/2,-TrackWidth(1,:)/2; TrackWidth(2,:)/2,-TrackWidth(2,:)/2]/12; %ft
    
    % car_totalMz = sum(car_Fy.*Moment_armsx + car_Fx.*Moment_armsy) + sum(Mz);
    
    % Yaw Moment (lb*in)
    YM = ((Fx(1,1)*(vehicle.FrontTrackWidth/24))+(Fx(2,1)*(vehicle.RearTrackWidth/24)))-((Fx(1,2)*(vehicle.FrontTrackWidth/24))+(Fx(2,2)*(vehicle.RearTrackWidth/24)))+ ((Fy(1,1)+Fy(1,2))*vehicle.FrontAxleToCoG)-((Fy(2,1)+Fy(2,2))*vehicle.CoGToRearAxle)-Mz(1,1)-Mz(1,2)-Mz(2,1)-Mz(2,2);
    
    % Acceleration (g's)
    Accel = [car_totalFx car_totalFy]/vehicle.TotalWeight;
end