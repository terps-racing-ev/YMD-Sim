%% Cornering Stiffness Simulator

function [Calpha] = CstiffCalc(Fz,latTrainingData,vehicle)

    %train Fy model
    tic
        disp('Fy Model is being trained.  Standby...')
        [Model_Fy, validation.RMSE_Fy] = Trainer_Fy(latTrainingData); %creates trained model and root mean square error to evaluate "fit"
        disp('Training completed')
    toc

    SA = [-13:1:13]'; %slip angle vector
    UCV = ones(size(SA));%makes a unit column vector of the same length as the slip angle vector

    Fy_FL = Model_Fy.predictFcn([SA vehicle.Camber(1,1)*UCV Fz(1,1)*UCV vehicle.TirePressure(1,1)*UCV]); %Fy at Fz = FL
    Fy_FR = Model_Fy.predictFcn([SA vehicle.Camber(1,2)*UCV Fz(1,2)*UCV vehicle.TirePressure(1,2)*UCV]); %Fy at Fz = FR
    Fy_RL = Model_Fy.predictFcn([SA vehicle.Camber(2,1)*UCV Fz(2,1)*UCV vehicle.TirePressure(2,1)*UCV]); %Fy at Fz = RL
    Fy_RR = Model_Fy.predictFcn([SA vehicle.Camber(2,2)*UCV Fz(2,2)*UCV vehicle.TirePressure(2,2)*UCV]); %Fy at Fz = RR

    Calpha_FL = min(gradient(Fy_FL));
    Calpha_FR = min(gradient(Fy_FR));
    Calpha_RL = min(gradient(Fy_RL));
    Calpha_RR = min(gradient(Fy_RR));

    Calpha = [Calpha_FL Calpha_FR; Calpha_RL Calpha_RR];
end