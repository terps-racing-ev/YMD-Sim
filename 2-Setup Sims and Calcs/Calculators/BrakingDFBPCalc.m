%% Braking Driver Forces Calc (using Fbrake (for Brake Proportioning))

function [F_driver_F, F_driver_R] = BrakingDFBPCalc(Fb_F, Fb_R, mu_F, mu_R, vehicle)
    % Front
    cap_ratio_F = vehicle.FBrakePadArea*vehicle.FPadCoF/vehicle.FMasterCylArea;
    fric_ratio_F = vehicle.FNumPistons/mu_F;
    diam_ratio_F = vehicle.FRotorDia/(2*vehicle.TireRadius);
    F_driver_F = Fb_F/(cap_ratio_F*fric_ratio_F*diam_ratio_F*vehicle.BrakePedalRatio*vehicle.BrakeBias);
    
    % Rear
    cap_ratio_R = vehicle.RBrakePadArea*vehicle.RPadCoF/vehicle.RMasterCylArea;
    fric_ratio_R = vehicle.RNumPistons/mu_R;
    diam_ratio_R = vehicle.RRotorDia/(2*vehicle.TireRadius);
    F_driver_R = Fb_R/(cap_ratio_R*fric_ratio_R*diam_ratio_R*vehicle.BrakePedalRatio*(1-vehicle.BrakeBias));

end