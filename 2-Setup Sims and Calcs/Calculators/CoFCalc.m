%% CoF Calculator

function [mu] = CoFCalc(Fz,Model_muyF,Model_muyR,vehicle)
    
    SA = [-13:1:13]'; %slip angle vector
    UCV = ones(size(SA)); %makes a unit column vector of the same length as the slip angle vector

    FzRange = [-50, -100, -150, -200, -250];
    mu_FLSweep = zeros(1,numel(FzRange));
    mu_FRSweep = zeros(1,numel(FzRange));
    mu_RLSweep = zeros(1,numel(FzRange));
    mu_RRSweep = zeros(1,numel(FzRange));

    % Maximum mu Sweep
    for i = 1:numel(FzRange)
        mu_FL = max(abs(Model_muyF.predictFcn([SA vehicle.Camber(1,1)*UCV FzRange(i)*UCV vehicle.TirePressure(1,1)*UCV])));
        mu_FR = max(abs(Model_muyF.predictFcn([SA vehicle.Camber(1,2)*UCV FzRange(i)*UCV vehicle.TirePressure(1,2)*UCV])));
        mu_RL = max(abs(Model_muyR.predictFcn([SA vehicle.Camber(2,1)*UCV FzRange(i)*UCV vehicle.TirePressure(2,1)*UCV])));
        mu_RR = max(abs(Model_muyR.predictFcn([SA vehicle.Camber(2,2)*UCV FzRange(i)*UCV vehicle.TirePressure(2,2)*UCV])));

        mu_FLSweep(1,i) = mu_FL;
        mu_FRSweep(1,i) = mu_FR;
        mu_RLSweep(1,i) = mu_RL;
        mu_RRSweep(1,i) = mu_RR;
    end

    polyFL = polyfit(log(FzRange),mu_FLSweep,1);
    polyFR = polyfit(log(FzRange),mu_FRSweep,1);
    polyRL = polyfit(log(FzRange),mu_RLSweep,1);
    polyRR = polyfit(log(FzRange),mu_RRSweep,1);

    mu_FLcalc = real(polyval(polyFL,log(Fz(1,1))));
    mu_FRcalc = real(polyval(polyFR,log(Fz(1,2))));
    mu_RLcalc = real(polyval(polyRL,log(Fz(2,1))));
    mu_RRcalc = real(polyval(polyRR,log(Fz(2,2))));

    mu = [mu_FLcalc, mu_FRcalc; mu_RLcalc, mu_RRcalc];

end