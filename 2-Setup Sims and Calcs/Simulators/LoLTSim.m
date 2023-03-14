%% Longitudinal Load Transfer Simulator

function [Fz,LoLT,Accelmax,Z] = LoLTSim(VehicleWeight,StaticWeights,mu_x,LongAccel,Wheelbase,CoGh,a,K_r)
    % LoLT
    LoLT = LongAccel*((VehicleWeight*CoGh)/Wheelbase);
    
    % Fz
    Fz = [StaticWeights(1,1)-(LoLT/2), StaticWeights(1,2)-(LoLT/2);
    StaticWeights(2,1)+(LoLT/2), StaticWeights(2,2)+(LoLT/2)];
    
    % Ax_max
    Accelmax = mu_x*(a/(Wheelbase-(CoGh*mu_x)));
    
    % Wheel Displacement (in) (neg -> loaded (bump), pos -> unloaded (droop))
    Z = [K_r(1,1)*(LoLT/2), K_r(1,2)*(LoLT/2);
        -K_r(2,1)*(LoLT/2), -K_r(2,2)*(LoLT/2)];

    for i = 1:2
        for j = 1:2
            if(Z(i,j) < -1)
                Z(i,j) = -1;
            end
            if(Z(i,j) > 1)
                Z(i,j) = 1;
            end
        end
    end
end