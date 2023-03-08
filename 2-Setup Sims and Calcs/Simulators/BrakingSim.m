%% Braking Forces Sim

function [Fx,Ax,BF] = BrakingSim(DriverForce,VehicleWeight,StaticWeights,mu_x,Wheelbase,CoGh,TireRadius,BrakeParameters)
    % Brake Forces (lbf)
    BF_F = (2*DriverForce*BrakeParameters(14,:))*(BrakeParameters(3,:)*(BrakeParameters(4,:)/BrakeParameters(12,:)))*(BrakeParameters(5,:)/mu_x)*(BrakeParameters(13,:)/(2*TireRadius))*BrakeParameters(15,:);
    BF_R = (2*DriverForce*BrakeParameters(14,:))*(BrakeParameters(8,:)*(BrakeParameters(9,:)/BrakeParameters(12,:)))*(BrakeParameters(10,:)/mu_x)*(BrakeParameters(13,:)/(2*TireRadius))*(1-BrakeParameters(15,:));
    
    BF = [BF_F;BF_R];
    
    % Ax (g's)
    Ax = -(BF(1,:)+BF(2,:))/VehicleWeight;
    
    % Fx (g's)
    Fx = [-mu_x*(StaticWeights(1,1)+(BF(1,:)*CoGh)/Wheelbase),-mu_x*(StaticWeights(1,2)+(BF(1,:)*CoGh)/Wheelbase);
        -mu_x*(StaticWeights(2,1)+(BF(2,:)*CoGh)/Wheelbase),-mu_x*(StaticWeights(2,2)+(BF(2,:)*CoGh)/Wheelbase)];
    
    if(DriverForce == 0)
        Fx = [0,0; 0,0];
    end
end