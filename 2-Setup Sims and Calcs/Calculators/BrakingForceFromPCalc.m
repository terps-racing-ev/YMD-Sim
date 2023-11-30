%% Braking Force from Brake Pressure

% Function to calculate brake forces from provided brake cylinder pressures
function [Fb_F, Fb_R] = BrakingForceFromPCalc(P_F, P_R, vehicle)
    % Cylinder Pressure
    cyl_d_ratio = (2*vehicle.TireRadius)/mean(vehicle.FPistonDia,vehicle.RPistonDia);
    Fb_F = P_F/(cyl_d_ratio/(vehicle.FNumPistons*vehicle.FBrakePadArea));
    Fb_R = P_R/(cyl_d_ratio/(vehicle.RNumPistons*vehicle.RBrakePadArea));

end