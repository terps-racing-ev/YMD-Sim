%% Max Deceleration Sim

function [Decelmax] = MaxDecelSim(BF,Fz,mux)
    % Tire Limit (g's)
    TL_F = BF(1,:)/(Fz(1,1)+Fz(1,2));
    TL_R = BF(2,:)/(Fz(2,1)+Fz(2,2));

    TL = [TL_F;TL_R];
    
    for i = 1:2
        if(TL(i,:) >= mux)
            BFmax(i,:) = BF;
        end
    end
    
    % Max Deceleration (g's)
    Decelmax = -(BFmax(1,:)+BFmax(2,:))/VehicleWeight;
end