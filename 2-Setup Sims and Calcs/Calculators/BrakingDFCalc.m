%% Braking Driver Force Calc (using Fz and mu)

function [F_driver_F, F_driver_R, P_F, P_R] = BrakingDFCalc(Fz_F, Fz_R, mu_F, mu_R, vehicle)
    % Front
    Fb_F = Fz_F*mu_F;
    cap_ratio_F = vehicle.FBrakePadArea*vehicle.FPadCoF/vehicle.FMasterCylArea;
    fric_ratio_F = vehicle.FNumPistons/mu_F;
    diam_ratio_F = vehicle.FRotorDia/(2*vehicle.TireRadius);
    F_driver_F = Fb_F/(cap_ratio_F*fric_ratio_F*diam_ratio_F*vehicle.BrakePedalRatio*vehicle.BrakeBias);
    
    % Rear
    Fb_R = Fz_R*mu_R;
    cap_ratio_R = vehicle.RBrakePadArea*vehicle.RPadCoF/vehicle.RMasterCylArea;
    fric_ratio_R = vehicle.RNumPistons/mu_R;
    diam_ratio_R = vehicle.RRotorDia/(2*vehicle.TireRadius);
    F_driver_R = Fb_R/(cap_ratio_R*fric_ratio_R*diam_ratio_R*vehicle.BrakePedalRatio*(1-vehicle.BrakeBias));

    % Cylinder Pressure
    cyl_d_ratio = (2*vehicle.TireRadius)/mean(vehicle.FPistonDia,vehicle.RPistonDia);
    P_F = Fb_F*cyl_d_ratio/(vehicle.FNumPistons*vehicle.FBrakePadArea);
    P_R = Fb_R*cyl_d_ratio/(vehicle.RNumPistons*vehicle.RBrakePadArea);

end