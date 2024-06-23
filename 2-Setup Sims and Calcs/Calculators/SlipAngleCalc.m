%% Slip Angle Calculator

function [SlipAngles] = SlipAngleCalc(SteerAngles,Beta,Velocity,Radius,vehicle, YawVelo)
    
    % Velocity Calculations
    Velocityin_s = Velocity * 17.6; % in/s
    % Slip Angle Calculations
    % Components
    Vy = Velocityin_s*sind(Beta); % in/s 
    Vx = Velocityin_s*cosd(Beta); % in/s
    %confirmed this is good up to here, RPM 6/18/2024
    
    LatCompF = vehicle.FrontAxleToCoG*YawVelo;
    LongCompF = (vehicle.FrontTrackWidth/2)*YawVelo;
    LatCompR = vehicle.CoGToRearAxle*YawVelo;
    LongCompR = (vehicle.RearTrackWidth/2)*YawVelo;
 %{
    % Slip Angles
    SlipAngleFL = SteerAngles(1,1)-atand((Vy+LatCompF)/(Vx+LongCompF));
    SlipAngleFR = SteerAngles(1,2)-atand((Vy+LatCompF)/(Vx-LongCompF));
    SlipAngleRL = atand((Vy-LatCompR)/(Vx+LongCompR));
    SlipAngleRR = atand((Vy-LatCompR)/(Vx-LongCompR));
    SlipAngles = [SlipAngleFL,SlipAngleFR; SlipAngleRL,SlipAngleRR];
    %}
    %Ryan's Attempt
    a = vehicle.FrontAxleToCoG; b = vehicle.CoGToRearAxle;
    moment_armsx = [a,a;-b,-b];
    moment_armsy = [vehicle.FrontTrackWidth/2, vehicle.FrontTrackWidth/2; vehicle.RearTrackWidth/2, -vehicle.RearTrackWidth/2];
    %r = [LatCompF,LatCompF;LatCompR,LatCompR] + 1i*[LongCompF,LongCompF;LongCompR,LongCompR]
    r = moment_armsx+ moment_armsy*1i;
    v = Velocityin_s*cosd(Beta)/12+1i*Velocityin_s*sind(Beta)/12;
    SlipAngles = -SteerAngles*pi/180 - [0,0;-vehicle.Toe(2),vehicle.Toe(4)]*pi/180 + angle([v,v;v,v]) + r*YawVelo*1i/12;
    SlipAngles = real(SlipAngles*180/pi);
    %idk what imag slip angles could mean, but its giving me issues
end
