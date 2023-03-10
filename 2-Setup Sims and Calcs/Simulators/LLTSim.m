%% Lateral Load Transfer Simulator

function [Fz,LLT,LLTD,R_g,Roll_Angle] = LLTSim(Kroll,VehicleWeight,StaticWeights,LatAccel,Track,CoGhRA,Zr,a,b,L)
    % Roll Gradient (deg/g)
    R_g = (VehicleWeight*CoGhRA)./(Kroll(1,:)+Kroll(2,:))*(180/pi);
    
    % LLT (lb)
    DeltaWF = (VehicleWeight/Track(1,:))*(((CoGhRA*Kroll(1,:))/(Kroll(1,:)+Kroll(2,:)))+((b/L)*Zr(1,:)))*LatAccel;
    DeltaWR = (VehicleWeight/Track(2,:))*(((CoGhRA*Kroll(2,:))/(Kroll(1,:)+Kroll(2,:)))+((a/L)*Zr(2,:)))*LatAccel;
    
    LLT = [DeltaWF; DeltaWR];
    
    % Fz (lb)
    Fz = [StaticWeights(1,1)+LLT(1,:), StaticWeights(1,2)-LLT(1,:);
    StaticWeights(2,1)+LLT(2,:), StaticWeights(2,2)-LLT(2,:)];
    
    % LLTD
    LLTDF = DeltaWF / (DeltaWF + DeltaWR);
    LLTDR = DeltaWR / (DeltaWF + DeltaWR);
    
    LLTD = [LLTDF; LLTDR];
    
    if(LatAccel == 0)
        LLTD = [0; 0];
    end
    
    % Roll Angle (deg)
    Roll_Angle = R_g * LatAccel;
end
