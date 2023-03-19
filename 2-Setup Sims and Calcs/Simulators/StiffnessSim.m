%% Stiffness Simulator

function [Kw,Kr,Kroll] = StiffnessSim(Kt,vehicle)

    %Kw: lbf/in
    Kw = [(vehicle.K_s(1,1)*(vehicle.MR_s(1,1))^2)+(vehicle.K_ARB(1,:)*(vehicle.MR_ARB(1,:))^2),(vehicle.K_s(1,2)*(vehicle.MR_s(1,2))^2)+(vehicle.K_ARB(1,:)*(vehicle.MR_ARB(1,:))^2);
    (vehicle.K_s(2,1)*(vehicle.MR_s(2,1))^2)+(vehicle.K_ARB(2,:)*(vehicle.MR_ARB(2,:))^2),(vehicle.K_s(2,2)*(vehicle.MR_s(2,2))^2)+(vehicle.K_ARB(2,:)*(vehicle.K_ARB(2,:))^2)];

    %Kr: lbf/in
    Kr = [(Kt(1,1)*Kw(1,1))/(Kt(1,1)+Kw(1,1)) (Kt(1,2)*Kw(1,2))/(Kt(1,2)+Kw(1,2));
    (Kt(2,1)*Kw(2,1))/(Kt(2,1)+Kw(2,1)) (Kt(2,2)*Kw(2,2))/(Kt(2,2)+Kw(2,2))];
    
    %Kroll: lbf-in/deg    
    Kroll = [(mean(Kr(1,:))*((vehicle.FrontTrackWidth^2)/2)); (mean(Kr(2,:))*((vehicle.RearTrackWidth^2)/2))];
    
end