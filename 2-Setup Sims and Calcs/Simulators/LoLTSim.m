%% Longitudinal Load Transfer Simulator

function [LoLT] = LoLTSim(VehicleWeight,LongAccel,Wheelbase,CoGh)
    % LoLT
    LoLT = LongAccel*((VehicleWeight*CoGh)/Wheelbase);
end