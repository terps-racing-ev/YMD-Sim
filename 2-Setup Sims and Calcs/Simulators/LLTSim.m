%% Lateral Load Transfer Simulator

function [Fz,LLT,LLTD,R_g,Roll_Angle,Z] = LLTSim(Kroll,LatAccel,vehicle)
    % Roll Gradient (deg/g)
    R_g = (vehicle.TotalWeight*vehicle.CoGhRA)./(Kroll(1,:)+Kroll(2,:))*(180/pi);
    
    % LLT (lb)
    DeltaWF = (vehicle.TotalWeight/vehicle.FrontTrackWidth)*(((vehicle.CoGhRA*Kroll(1,:))/(Kroll(1,:)+Kroll(2,:)))+((vehicle.CoGToRearAxle/vehicle.Wheelbase)*vehicle.RollAxisF))*LatAccel;
    DeltaWR = (vehicle.TotalWeight/vehicle.RearTrackWidth)*(((vehicle.CoGhRA*Kroll(2,:))/(Kroll(1,:)+Kroll(2,:)))+((vehicle.FrontAxleToCoG/vehicle.Wheelbase)*vehicle.RollAxisR))*LatAccel;
    
    LLT = [DeltaWF; DeltaWR];
    
    % Aero Effects
    
    % Fz (lb)
    Fz = -[vehicle.FrontStatic+LLT(1,:), vehicle.FrontStatic-LLT(1,:);
    vehicle.RearStatic+LLT(2,:), vehicle.RearStatic-LLT(2,:)];
    
    % LLTD
    LLTDF = DeltaWF / (DeltaWF + DeltaWR);
    LLTDR = DeltaWR / (DeltaWF + DeltaWR);
    
    LLTD = [LLTDF; LLTDR];
    
    if(LatAccel == 0)
        LLTD = [0; 0];
    end
    
    % Roll Angle (deg)
    Roll_Angle = R_g * LatAccel;
    
    % Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))
    Z = [-(tan(deg2rad(Roll_Angle).*(vehicle.FrontTrackWidth/2))), (tan(deg2rad(Roll_Angle).*(vehicle.FrontTrackWidth/2)));
        -(tan(deg2rad(Roll_Angle).*(vehicle.RearTrackWidth/2))), (tan(deg2rad(Roll_Angle).*(vehicle.RearTrackWidth/2)))];

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
