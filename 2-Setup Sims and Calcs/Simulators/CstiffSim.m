%% Cornering Stiffness Simulator

function [Calpha] = CstiffSim(Fy)
    Calpha_FL = min(gradient(Fy(1,1)));
    Calpha_FR = min(gradient(Fy(1,2)));
    Calpha_RL = min(gradient(Fy(2,1)));
    Calpha_RR = min(gradient(Fy(2,2)));
    
    Calpha = [Calpha_FL Calpha_FR; Calpha_RL Calpha_RR];
end