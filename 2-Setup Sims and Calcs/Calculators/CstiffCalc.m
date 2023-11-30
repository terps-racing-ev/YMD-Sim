<<<<<<< HEAD
%% Cornering Stiffness Simulator

function [Calpha] = CstiffCalc(Fy)
    Calpha_FL = min(gradient(Fy(1,1)));
    Calpha_FR = min(gradient(Fy(1,2)));
    Calpha_RL = min(gradient(Fy(2,1)));
    Calpha_RR = min(gradient(Fy(2,2)));
    
    Calpha = [Calpha_FL Calpha_FR; Calpha_RL Calpha_RR];
=======
%% Cornering Stiffness Calculator

function [Calpha] = CstiffCalc(Fz,Model_FyF,Model_FyR,vehicle)

    SA = [-13:1:13]'; %slip angle vector
    UCV = ones(size(SA));%makes a unit column vector of the same length as the slip angle vector

    FzRange = [-50, -100, -150, -200, -250];

    % FL Sweep
    Fy_50FL = Model_FyF.predictFcn([SA vehicle.Camber(1,1)*UCV -50*UCV vehicle.TirePressure(1,1)*UCV]); %Fy at Fz = -50
    Fy_100FL = Model_FyF.predictFcn([SA vehicle.Camber(1,1)*UCV -100*UCV vehicle.TirePressure(1,1)*UCV]); %Fy at Fz = -100
    Fy_150FL = Model_FyF.predictFcn([SA vehicle.Camber(1,1)*UCV -150*UCV vehicle.TirePressure(1,1)*UCV]); %Fy at Fz = -150
    Fy_200FL = Model_FyF.predictFcn([SA vehicle.Camber(1,1)*UCV -200*UCV vehicle.TirePressure(1,1)*UCV]); %Fy at Fz = -200
    Fy_250FL = Model_FyF.predictFcn([SA vehicle.Camber(1,1)*UCV -250*UCV vehicle.TirePressure(1,1)*UCV]); %Fy at Fz = -250

    Calpha_50FL = min(gradient(Fy_50FL));
    Calpha_100FL = min(gradient(Fy_100FL));
    Calpha_150FL = min(gradient(Fy_150FL));
    Calpha_200FL = min(gradient(Fy_200FL));
    Calpha_250FL = min(gradient(Fy_250FL));

    CalphaFL = [Calpha_50FL Calpha_100FL Calpha_150FL Calpha_200FL Calpha_250FL];

    polyFL = polyfit(log(FzRange),CalphaFL,1);
    
    % FR Sweep
    Fy_50FR = Model_FyF.predictFcn([SA vehicle.Camber(1,2)*UCV -50*UCV vehicle.TirePressure(1,2)*UCV]); %Fy at Fz = -50
    Fy_100FR = Model_FyF.predictFcn([SA vehicle.Camber(1,2)*UCV -100*UCV vehicle.TirePressure(1,2)*UCV]); %Fy at Fz = -100
    Fy_150FR = Model_FyF.predictFcn([SA vehicle.Camber(1,2)*UCV -150*UCV vehicle.TirePressure(1,2)*UCV]); %Fy at Fz = -150
    Fy_200FR = Model_FyF.predictFcn([SA vehicle.Camber(1,2)*UCV -200*UCV vehicle.TirePressure(1,2)*UCV]); %Fy at Fz = -200
    Fy_250FR = Model_FyF.predictFcn([SA vehicle.Camber(1,2)*UCV -250*UCV vehicle.TirePressure(1,2)*UCV]); %Fy at Fz = -250

    Calpha_50FR = min(gradient(Fy_50FR));
    Calpha_100FR = min(gradient(Fy_100FR));
    Calpha_150FR = min(gradient(Fy_150FR));
    Calpha_200FR = min(gradient(Fy_200FR));
    Calpha_250FR = min(gradient(Fy_250FR));

    CalphaFR = [Calpha_50FR Calpha_100FR Calpha_150FR Calpha_200FR Calpha_250FR];

    polyFR = polyfit(log(FzRange),CalphaFR,1);

    % RL Sweep
    Fy_50RL = Model_FyR.predictFcn([SA vehicle.Camber(2,1)*UCV -50*UCV vehicle.TirePressure(2,1)*UCV]); %Fy at Fz = -50
    Fy_100RL = Model_FyR.predictFcn([SA vehicle.Camber(2,1)*UCV -100*UCV vehicle.TirePressure(2,1)*UCV]); %Fy at Fz = -100
    Fy_150RL = Model_FyR.predictFcn([SA vehicle.Camber(2,1)*UCV -150*UCV vehicle.TirePressure(2,1)*UCV]); %Fy at Fz = -150
    Fy_200RL = Model_FyR.predictFcn([SA vehicle.Camber(2,1)*UCV -200*UCV vehicle.TirePressure(2,1)*UCV]); %Fy at Fz = -200
    Fy_250RL = Model_FyR.predictFcn([SA vehicle.Camber(2,1)*UCV -250*UCV vehicle.TirePressure(2,1)*UCV]); %Fy at Fz = -250

    Calpha_50RL = min(gradient(Fy_50RL));
    Calpha_100RL = min(gradient(Fy_100RL));
    Calpha_150RL = min(gradient(Fy_150RL));
    Calpha_200RL = min(gradient(Fy_200RL));
    Calpha_250RL = min(gradient(Fy_250RL));

    CalphaRL = [Calpha_50RL Calpha_100RL Calpha_150RL Calpha_200RL Calpha_250RL];

    polyRL = polyfit(log(FzRange),CalphaRL,1);

    % RR Sweep
    Fy_50RR = Model_FyR.predictFcn([SA vehicle.Camber(2,2)*UCV -50*UCV vehicle.TirePressure(2,2)*UCV]); %Fy at Fz = -50
    Fy_100RR = Model_FyR.predictFcn([SA vehicle.Camber(2,2)*UCV -100*UCV vehicle.TirePressure(2,2)*UCV]); %Fy at Fz = -100
    Fy_150RR = Model_FyR.predictFcn([SA vehicle.Camber(2,2)*UCV -150*UCV vehicle.TirePressure(2,2)*UCV]); %Fy at Fz = -150
    Fy_200RR = Model_FyR.predictFcn([SA vehicle.Camber(2,2)*UCV -200*UCV vehicle.TirePressure(2,2)*UCV]); %Fy at Fz = -200
    Fy_250RR = Model_FyR.predictFcn([SA vehicle.Camber(2,2)*UCV -250*UCV vehicle.TirePressure(2,2)*UCV]); %Fy at Fz = -250

    Calpha_50RR = min(gradient(Fy_50RR));
    Calpha_100RR = min(gradient(Fy_100RR));
    Calpha_150RR = min(gradient(Fy_150RR));
    Calpha_200RR = min(gradient(Fy_200RR));
    Calpha_250RR = min(gradient(Fy_250RR));

    CalphaRR = [Calpha_50RR Calpha_100RR Calpha_150RR Calpha_200RR Calpha_250RR];

    polyRR = polyfit(log(FzRange),CalphaRR,1);
    
    polyfits = [polyFL, polyFR; polyRL, polyRR];

    Calpha_F = [real(polyval(polyFL,log(Fz(1,1)))), real(polyval(polyFR,log(Fz(1,2))))];
    Calpha_R = [real(polyval(polyRL,log(Fz(2,1)))), real(polyval(polyRR,log(Fz(2,2))))];

    Calpha = [Calpha_F; Calpha_R];

>>>>>>> main
end