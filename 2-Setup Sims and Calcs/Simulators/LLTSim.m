%% Lateral Load Transfer Simulator

function [Fz,LLT,LLTD,R_g,Roll_Angle,Z] = LLTSim(Kroll,Velocity,LatAccel,vehicle)
    % Roll Gradient (deg/g)
    R_g = (vehicle.TotalWeight*vehicle.CoGhRA)./(Kroll(1,:)+Kroll(2,:));
    
    % LLT (lb)
    DeltaWF = (vehicle.TotalWeight/vehicle.FrontTrackWidth)*(((vehicle.CoGhRA*Kroll(1,:))/(Kroll(1,:)+Kroll(2,:)))+((vehicle.CoGToRearAxle/vehicle.Wheelbase)*vehicle.RollAxisF))*LatAccel;
    DeltaWR = (vehicle.TotalWeight/vehicle.RearTrackWidth)*(((vehicle.CoGhRA*Kroll(2,:))/(Kroll(1,:)+Kroll(2,:)))+((vehicle.FrontAxleToCoG/vehicle.Wheelbase)*vehicle.RollAxisR))*LatAccel;
    
    LLT = [DeltaWF; DeltaWR];
    
    % Aero Effects
    Fdown = (0.5*vehicle.air_density*vehicle.Cl*vehicle.Af*(Velocity*17.6).^2)/386.4;
    
    % Fz (lb)
    Fz = -[vehicle.FrontStatic-LLT(1,:)+(-Fdown*vehicle.FrontAeroPercent), vehicle.FrontStatic+LLT(1,:)+(-Fdown*vehicle.FrontAeroPercent);
    vehicle.RearStatic-LLT(2,:)+(-Fdown*vehicle.RearAeroPercent), vehicle.RearStatic+LLT(2,:)+(-Fdown*vehicle.RearAeroPercent)];
    
    % LLTD
    LLTDF = DeltaWF / (DeltaWF + DeltaWR);
    LLTDR = DeltaWR / (DeltaWF + DeltaWR);
    
    LLTD = [LLTDF; LLTDR];
    
    % Roll Angle (deg)
    Roll_Angle = R_g * LatAccel;
    
     if(LatAccel == 0)
        LLTD = [0; 0];
    end
    
    % Wheel Displacement (in) (pos -> loaded (bump), neg -> unloaded (droop))
    Z = [(tan(deg2rad(Roll_Angle).*(vehicle.FrontTrackWidth/2))), -(tan(deg2rad(Roll_Angle).*(vehicle.FrontTrackWidth/2)));
        (tan(deg2rad(Roll_Angle).*(vehicle.RearTrackWidth/2))), -(tan(deg2rad(Roll_Angle).*(vehicle.RearTrackWidth/2)))];

    % Roll Angle (deg)
    Roll_Angle = R_g * -LatAccel;
    
     if(LatAccel == 0)
        LLTD = [0; 0];
    end
    
    % Wheel Displacement (in) (pos -> loaded (bump), neg -> unloaded (droop))
    Z = [-(tan(deg2rad(-Roll_Angle).*(vehicle.FrontTrackWidth/2))), (tan(deg2rad(-Roll_Angle).*(vehicle.FrontTrackWidth/2)));
        -(tan(deg2rad(-Roll_Angle).*(vehicle.RearTrackWidth/2))), (tan(deg2rad(-Roll_Angle).*(vehicle.RearTrackWidth/2)))];

    for j = 1:2
        for k = 1:2
            if(Z(j,k) < -1)
                Z(j,k) = -1;
            end
            if(Z(j,k) > 1)
                Z(j,k) = 1;
            end
        end
    end

end
