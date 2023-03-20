%% Longitudinal Load Transfer Simulator

function [Fz,LoLT,Accelmax,Z] = LoLTSim(mu_x,LongAccel,K_r,vehicle)
    % LoLT
    LoLT = LongAccel*((vehicle.TotalWeight*vehicle.CoGHeight)/vehicle.Wheelbase);
    
    % Aero Effects
    
    % Fz
    Fz = [vehicle.FrontStatic-(LoLT/2), vehicle.FrontStatic-(LoLT/2);
    vehicle.RearStatic+(LoLT/2), vehicle.RearStatic+(LoLT/2)];
    
    % Ax_max
    Accelmax = mu_x*(vehicle.FrontAxleToCoG/(vehicle.Wheelbase-(vehicle.CoGHeight*mu_x)));
    
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