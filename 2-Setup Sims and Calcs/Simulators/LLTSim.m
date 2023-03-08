%% Lateral Load Transfer Simulator

function [LLT,LLTD,R_g] = LLTSim(Kroll,VehicleWeight,LatAccel,Track,CoGhRA,Zr,a,b,L)
    % Roll Gradient
    R_g = -(VehicleWeight*CoGhRA)./(Kroll(1,:)+Kroll(2,:))*(180/pi);
    
    % LLT
    DeltaWF = (VehicleWeight/Track(1,:))*(((CoGhRA*Kroll(1,:))/(Kroll(1,:)+Kroll(2,:)))+((b/L)*Zr(1,:)))*LatAccel;
    DeltaWR = (VehicleWeight/Track(2,:))*(((CoGhRA*Kroll(2,:))/(Kroll(1,:)+Kroll(2,:)))+((a/L)*Zr(2,:)))*LatAccel;
    
    LLT = [DeltaWF; DeltaWR];
    
    % LLTD
    LLTDF = DeltaWF / (DeltaWF + DeltaWR);
    LLTDR = DeltaWR / (DeltaWF + DeltaWR);
    
    LLTD = [LLTDF; LLTDR];
end
