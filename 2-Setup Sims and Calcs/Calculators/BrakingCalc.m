%% Braking Forces Calculator

function [Fx,Ax,BF] = BrakingCalc(DriverForce,mu_x,BrakeParameters,vehicle)
    % Brake Forces (lbf)
    BF_F = (2*DriverForce*BrakeParameters(14,:))*(BrakeParameters(3,:)*(BrakeParameters(4,:)/BrakeParameters(12,:)))*(BrakeParameters(5,:)/mu_x)*(BrakeParameters(13,:)/(2*vehicle.TireRadius))*BrakeParameters(15,:);
    BF_R = (2*DriverForce*BrakeParameters(14,:))*(BrakeParameters(8,:)*(BrakeParameters(9,:)/BrakeParameters(12,:)))*(BrakeParameters(10,:)/mu_x)*(BrakeParameters(13,:)/(2*vehicle.TireRadius))*(1-BrakeParameters(15,:));
    
    BF = [BF_F;BF_R];
    
    % Ax (g's)
    Ax = -(BF(1,:)+BF(2,:))/vehicle.TotalWeight;
    
    % Fx (g's)
    Fx = [-mu_x*(vehicle.FrontStatic+(BF(1,:)*vehicle.CoGHeight)/vehicle.Wheelbase),-mu_x*(vehicle.FrontStatic+(BF(1,:)*vehicle.CoGHeight)/vehicle.Wheelbase);
        -mu_x*(vehicle.RearStatic+(BF(2,:)*vehicle.CoGHeight)/vehicle.Wheelbase),-mu_x*(vehicle.RearStatic+(BF(2,:)*vehicle.CoGHeight)/vehicle.Wheelbase)];
    
    if(DriverForce == 0)
        Fx = [0,0; 0,0];
    end
end