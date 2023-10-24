%% Longitudinal Load Transfer Simulator

function [Fz,LoLT,Accelmax,Pitch_Angle,Z] = LoLTCalc(mu_x,Velocity,LongAccel,K_r,vehicle)
    % LoLT
    LoLT = LongAccel*((vehicle.TotalWeight*vehicle.CoGHeight)/vehicle.Wheelbase);
    
    % Aero Effects
    Fdown = (0.5*vehicle.air_density*vehicle.Cl*vehicle.Af*(Velocity*17.6).^2)/386.4;
    
    % Fz
    Fz = [-(vehicle.FrontStatic-(LoLT/2)+(-Fdown*vehicle.FrontAeroPercent)), -(vehicle.FrontStatic-(LoLT/2)+(-Fdown*vehicle.FrontAeroPercent));
    -(vehicle.RearStatic+(LoLT/2)+(-Fdown*vehicle.RearAeroPercent)), -(vehicle.RearStatic+(LoLT/2)+(-Fdown*vehicle.RearAeroPercent))];
    
    % Ax_max
    Accelmax = mu_x*(vehicle.FrontAxleToCoG/(vehicle.Wheelbase-(vehicle.CoGHeight*mu_x)));
    
    % Wheel Displacement (in) (pos -> loaded (bump), neg -> unloaded (droop))
    Z = [-(Fz(1,1)+vehicle.FrontStatic)/K_r(1,1), -(Fz(1,2)+vehicle.FrontStatic)/K_r(1,2);
        -(Fz(2,1)+vehicle.RearStatic)/K_r(2,1), -(Fz(2,2)+vehicle.RearStatic)/K_r(2,2)];

    % Pitch Angle (deg)
    Pitch_Angle = -atan((mean(Z(1,:)))/vehicle.FrontAxleToCoG)*(180/pi());

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