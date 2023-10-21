%% Max Deceleration Sim

function [Decelmax] = MaxDecelCalc(TL,mux,vehicle)    
    for i = 1:2
        if(TL(i,:) >= mux)
            BFmax(i,:) = BF;
        end
    end
    
    % Max Deceleration (g's)
    Decelmax = -(BFmax(1,:)+BFmax(2,:))/vehicle.TotalWeight;
end