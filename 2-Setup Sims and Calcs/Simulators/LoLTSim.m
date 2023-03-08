%% Longitudinal Load Transfer Simulator

function [Fz,LoLT,Accelmax] = LoLTSim(VehicleWeight,StaticWeights,mu_x,LongAccel,Wheelbase,CoGh,a)
    % LoLT
    LoLT = LongAccel*((VehicleWeight*CoGh)/Wheelbase);
    
    % Fz
    Fz = [StaticWeights(1,1)-(LoLT/2), StaticWeights(1,2)-(LoLT/2);
    StaticWeights(2,1)+(LoLT/2), StaticWeights(2,2)+(LoLT/2)];
    
    % Ax_max
    Accelmax = mu_x*(a/(Wheelbase-(CoGh*mu_x)));
end