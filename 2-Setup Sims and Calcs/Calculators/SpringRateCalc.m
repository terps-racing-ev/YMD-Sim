<<<<<<< HEAD
%% Spring Rate Simulator

function [polyfits0I,polyfits2I,polyfits4I] = SpringRateCalc(latTrainingData_P1,latTrainingData_P2)

    % "Traditional" Plots - Data Stratification
    
    Num8psi_P1 =  find(latTrainingData_P1(:,4) <= 9);
    Num10psi_P1 =  find(latTrainingData_P1(:,4) > 9 & latTrainingData_P1(:,4) <= 11);
    Num12psi_P1 =  find(latTrainingData_P1(:,4) > 11 & latTrainingData_P1(:,4) <= 13);
    Num14psi_P1 =  find(latTrainingData_P1(:,4) > 13);
    
    Num8psi_P2 =  find(latTrainingData_P2(:,4) <= 9);
    Num10psi_P2 =  find(latTrainingData_P2(:,4) > 9 & latTrainingData_P2(:,4) <= 11);
    Num12psi_P2 =  find(latTrainingData_P2(:,4) > 11 & latTrainingData_P2(:,4) <= 13);
    Num14psi_P2 =  find(latTrainingData_P2(:,4) > 13);
    
    Num0IA_P1 = find(latTrainingData_P1(:,2) <= 0.5);
    Num2IA_P1 = find(latTrainingData_P1(:,2) > 1.5 & latTrainingData_P1(:,2) <= 2.5);
    Num4IA_P1 = find(latTrainingData_P1(:,2) > 3.5 & latTrainingData_P1(:,2) <= 4.5);
    
    Num0IA_P2 = find(latTrainingData_P2(:,2) <= 0.5);
    Num2IA_P2 = find(latTrainingData_P2(:,2) > 1.5 & latTrainingData_P2(:,2) <= 2.5);
    Num4IA_P2 = find(latTrainingData_P2(:,2) > 3.5 & latTrainingData_P2(:,2) <= 4.5);
    
    Num8P0I_P1 = intersect(Num8psi_P1,Num0IA_P1);
    Num8P2I_P1 = intersect(Num8psi_P1,Num2IA_P1);
    Num8P4I_P1 = intersect(Num8psi_P1,Num4IA_P1);
    
    Num8P0I_P2 = intersect(Num8psi_P2,Num0IA_P2);
    Num8P2I_P2 = intersect(Num8psi_P2,Num2IA_P2);
    Num8P4I_P2 = intersect(Num8psi_P2,Num4IA_P2);
    
    Num10P0I_P1 = intersect(Num10psi_P1,Num0IA_P1);
    Num10P2I_P1 = intersect(Num10psi_P1,Num2IA_P1);
    Num10P4I_P1 = intersect(Num10psi_P1,Num4IA_P1);
    
    Num10P0I_P2 = intersect(Num10psi_P2,Num0IA_P2);
    Num10P2I_P2 = intersect(Num10psi_P2,Num2IA_P2);
    Num10P4I_P2 = intersect(Num10psi_P2,Num4IA_P2);
    
    Num12P0I_P1 = intersect(Num12psi_P1,Num0IA_P1);
    Num12P2I_P1 = intersect(Num12psi_P1,Num2IA_P1);
    Num12P4I_P1 = intersect(Num12psi_P1,Num4IA_P1);
    
    Num12P0I_P2 = intersect(Num12psi_P2,Num0IA_P2);
    Num12P2I_P2 = intersect(Num12psi_P2,Num2IA_P2);
    Num12P4I_P2 = intersect(Num12psi_P2,Num4IA_P2);
    
    Num14P0I_P1 = intersect(Num14psi_P1,Num0IA_P1);
    Num14P2I_P1 = intersect(Num14psi_P1,Num2IA_P1);
    Num14P4I_P1 = intersect(Num14psi_P1,Num4IA_P1);
    
    Num14P0I_P2 = intersect(Num14psi_P2,Num0IA_P2);
    Num14P2I_P2 = intersect(Num14psi_P2,Num2IA_P2);
    Num14P4I_P2 = intersect(Num14psi_P2,Num4IA_P2);
    
    Num50Fz_P1 =  find(latTrainingData_P1(:,3) > -75);
    Num100Fz_P1 =  find(latTrainingData_P1(:,3) <= -75 & latTrainingData_P1(:,3) > -125);
    Num150Fz_P1 =  find(latTrainingData_P1(:,3) <= -125 & latTrainingData_P1(:,3) > -175);
    Num200Fz_P1 =  find(latTrainingData_P1(:,3) <= -175 & latTrainingData_P1(:,3) > -225);
    Num250Fz_P1 = find(latTrainingData_P1(:,3) <= -225);
    
    Num50Fz_P2 =  find(latTrainingData_P2(:,3) > -75);
    Num100Fz_P2 =  find(latTrainingData_P2(:,3) <= -75 & latTrainingData_P2(:,3) > -125);
    Num150Fz_P2 =  find(latTrainingData_P2(:,3) <= -125 & latTrainingData_P2(:,3) > -175);
    Num200Fz_P2 =  find(latTrainingData_P2(:,3) <= -175 & latTrainingData_P2(:,3) > -225);
    Num250Fz_P2 = find(latTrainingData_P2(:,3) <= -225);
    
    NumRL_P1 = find(latTrainingData_P1(:,8));
    NumRL_P2 = find(latTrainingData_P2(:,8));
    
    % 0 deg Camber Stratification
    Num8P0IRL_P2 = intersect(Num8P0I_P2,NumRL_P2);
    Num10P0IRL_P1 = intersect(Num10P0I_P1,NumRL_P1);
    Num12iP0IRL_P1 = intersect(Num12P0I_P1,NumRL_P1);
    Num12fP0IRL_P2 = intersect(Num12P0I_P2,NumRL_P2);
    Num14P0IRL_P1 = intersect(Num14P0I_P1,NumRL_P1);

    Num8P0IRL50Fz_P2 = intersect(Num8P0IRL_P2,Num50Fz_P2);
    Num10P0IRL50Fz_P1 = intersect(Num10P0IRL_P1,Num50Fz_P1);
    Num12iP0IRL50Fz_P1 = intersect(Num12iP0IRL_P1,Num50Fz_P1);
    Num12fP0IRL50Fz_P2 = intersect(Num12fP0IRL_P2,Num50Fz_P2);
    Num14P0IRL50Fz_P1 = intersect(Num14P0IRL_P1,Num50Fz_P1);

    Num8P0IRL100Fz_P2 = intersect(Num8P0IRL_P2,Num100Fz_P2);
    Num10P0IRL100Fz_P1 = intersect(Num10P0IRL_P1,Num100Fz_P1);
    Num12iP0IRL100Fz_P1 = intersect(Num12iP0IRL_P1,Num100Fz_P1);
    Num12fP0IRL100Fz_P2 = intersect(Num12fP0IRL_P2,Num100Fz_P2);
    Num14P0IRL100Fz_P1 = intersect(Num14P0IRL_P1,Num100Fz_P1);

    Num8P0IRL150Fz_P2 = intersect(Num8P0IRL_P2,Num150Fz_P2);
    Num10P0IRL150Fz_P1 = intersect(Num10P0IRL_P1,Num150Fz_P1);
    Num12iP0IRL150Fz_P1 = intersect(Num12iP0IRL_P1,Num150Fz_P1);
    Num12fP0IRL150Fz_P2 = intersect(Num12fP0IRL_P2,Num150Fz_P2);
    Num14P0IRL150Fz_P1 = intersect(Num14P0IRL_P1,Num150Fz_P1);

    Num8P0IRL200Fz_P2 = intersect(Num8P0IRL_P2,Num200Fz_P2);
    Num10P0IRL200Fz_P1 = intersect(Num10P0IRL_P1,Num200Fz_P1);
    Num12iP0IRL200Fz_P1 = intersect(Num12iP0IRL_P1,Num200Fz_P1);
    Num12fP0IRL200Fz_P2 = intersect(Num12fP0IRL_P2,Num200Fz_P2);
    Num14P0IRL200Fz_P1 = intersect(Num14P0IRL_P1,Num200Fz_P1);

    Num8P0IRL250Fz_P2 = intersect(Num8P0IRL_P2,Num250Fz_P2);
    Num10P0IRL250Fz_P1 = intersect(Num10P0IRL_P1,Num250Fz_P1);
    Num12iP0IRL250Fz_P1 = intersect(Num12iP0IRL_P1,Num250Fz_P1);
    Num12fP0IRL250Fz_P2 = intersect(Num12fP0IRL_P2,Num250Fz_P2);
    Num14P0IRL250Fz_P1 = intersect(Num14P0IRL_P1,Num250Fz_P1);

    RL8P0IMax50 = max(abs(latTrainingData_P2(Num8P0IRL50Fz_P2,8)));
    RL10P0IMax50 = max(abs(latTrainingData_P1(Num10P0IRL50Fz_P1,8)));
    RL12iP0IMax50 = max(abs(latTrainingData_P1(Num12iP0IRL50Fz_P1,8)));
    RL12fP0IMax50 = max(abs(latTrainingData_P2(Num12fP0IRL50Fz_P2,8)));
    RL14P0IMax50 = max(abs(latTrainingData_P1(Num14P0IRL50Fz_P1,8)));

    RL8P0IMax100 = max(abs(latTrainingData_P2(Num8P0IRL100Fz_P2,8)));
    RL10P0IMax100 = max(abs(latTrainingData_P1(Num10P0IRL100Fz_P1,8)));
    RL12iP0IMax100 = max(abs(latTrainingData_P1(Num12iP0IRL100Fz_P1,8)));
    RL12fP0IMax100 = max(abs(latTrainingData_P2(Num12fP0IRL100Fz_P2,8)));
    RL14P0IMax100 = max(abs(latTrainingData_P1(Num14P0IRL100Fz_P1,8)));

    RL8P0IMax150 = max(abs(latTrainingData_P2(Num8P0IRL150Fz_P2,8)));
    RL10P0IMax150 = max(abs(latTrainingData_P1(Num10P0IRL150Fz_P1,8)));
    RL12iP0IMax150 = max(abs(latTrainingData_P1(Num12iP0IRL150Fz_P1,8)));
    RL12fP0IMax150 = max(abs(latTrainingData_P2(Num12fP0IRL150Fz_P2,8)));
    RL14P0IMax150 = max(abs(latTrainingData_P1(Num14P0IRL150Fz_P1,8)));

    RL8P0IMax200 = max(abs(latTrainingData_P2(Num8P0IRL200Fz_P2,8)));
    RL10P0IMax200 = max(abs(latTrainingData_P1(Num10P0IRL200Fz_P1,8)));
    RL12iP0IMax200 = max(abs(latTrainingData_P1(Num12iP0IRL200Fz_P1,8)));
    RL12fP0IMax200 = max(abs(latTrainingData_P2(Num12fP0IRL200Fz_P2,8)));
    RL14P0IMax200 = max(abs(latTrainingData_P1(Num14P0IRL200Fz_P1,8)));

    RL8P0IMax250 = max(abs(latTrainingData_P2(Num8P0IRL250Fz_P2,8)));
    RL10P0IMax250 = max(abs(latTrainingData_P1(Num10P0IRL250Fz_P1,8)));
    RL12iP0IMax250 = max(abs(latTrainingData_P1(Num12iP0IRL250Fz_P1,8)));
    RL12fP0IMax250 = max(abs(latTrainingData_P2(Num12fP0IRL250Fz_P2,8)));
    RL14P0IMax250 = max(abs(latTrainingData_P1(Num14P0IRL250Fz_P1,8)));

    % 2 deg Camber Stratification
    Num8P2IRL_P2 = intersect(Num8P2I_P2,NumRL_P2);
    Num10P2IRL_P1 = intersect(Num10P2I_P1,NumRL_P1);
    Num12iP2IRL_P1 = intersect(Num12P2I_P1,NumRL_P1);
    Num12fP2IRL_P2 = intersect(Num12P2I_P2,NumRL_P2);
    Num14P2IRL_P1 = intersect(Num14P2I_P1,NumRL_P1);

    Num8P2IRL50Fz_P2 = intersect(Num8P2IRL_P2,Num50Fz_P2);
    Num10P2IRL50Fz_P1 = intersect(Num10P2IRL_P1,Num50Fz_P1);
    Num12iP2IRL50Fz_P1 = intersect(Num12iP2IRL_P1,Num50Fz_P1);
    Num12fP2IRL50Fz_P2 = intersect(Num12fP2IRL_P2,Num50Fz_P2);
    Num14P2IRL50Fz_P1 = intersect(Num14P2IRL_P1,Num50Fz_P1);

    Num8P2IRL100Fz_P2 = intersect(Num8P2IRL_P2,Num100Fz_P2);
    Num10P2IRL100Fz_P1 = intersect(Num10P2IRL_P1,Num100Fz_P1);
    Num12iP2IRL100Fz_P1 = intersect(Num12iP2IRL_P1,Num100Fz_P1);
    Num12fP2IRL100Fz_P2 = intersect(Num12fP2IRL_P2,Num100Fz_P2);
    Num14P2IRL100Fz_P1 = intersect(Num14P2IRL_P1,Num100Fz_P1);

    Num8P2IRL150Fz_P2 = intersect(Num8P2IRL_P2,Num150Fz_P2);
    Num10P2IRL150Fz_P1 = intersect(Num10P2IRL_P1,Num150Fz_P1);
    Num12iP2IRL150Fz_P1 = intersect(Num12iP2IRL_P1,Num150Fz_P1);
    Num12fP2IRL150Fz_P2 = intersect(Num12fP2IRL_P2,Num150Fz_P2);
    Num14P2IRL150Fz_P1 = intersect(Num14P2IRL_P1,Num150Fz_P1);

    Num8P2IRL200Fz_P2 = intersect(Num8P2IRL_P2,Num200Fz_P2);
    Num10P2IRL200Fz_P1 = intersect(Num10P2IRL_P1,Num200Fz_P1);
    Num12iP2IRL200Fz_P1 = intersect(Num12iP2IRL_P1,Num200Fz_P1);
    Num12fP2IRL200Fz_P2 = intersect(Num12fP2IRL_P2,Num200Fz_P2);
    Num14P2IRL200Fz_P1 = intersect(Num14P2IRL_P1,Num200Fz_P1);

    Num8P2IRL250Fz_P2 = intersect(Num8P2IRL_P2,Num250Fz_P2);
    Num10P2IRL250Fz_P1 = intersect(Num10P2IRL_P1,Num250Fz_P1);
    Num12iP2IRL250Fz_P1 = intersect(Num12iP2IRL_P1,Num250Fz_P1);
    Num12fP2IRL250Fz_P2 = intersect(Num12fP2IRL_P2,Num250Fz_P2);
    Num14P2IRL250Fz_P1 = intersect(Num14P2IRL_P1,Num250Fz_P1);

    RL8P2IMax50 = max(abs(latTrainingData_P2(Num8P2IRL50Fz_P2,8)));
    RL10P2IMax50 = max(abs(latTrainingData_P1(Num10P2IRL50Fz_P1,8)));
    RL12iP2IMax50 = max(abs(latTrainingData_P1(Num12iP2IRL50Fz_P1,8)));
    RL12fP2IMax50 = max(abs(latTrainingData_P2(Num12fP2IRL50Fz_P2,8)));
    RL14P2IMax50 = max(abs(latTrainingData_P1(Num14P2IRL50Fz_P1,8)));

    RL8P2IMax100 = max(abs(latTrainingData_P2(Num8P2IRL100Fz_P2,8)));
    RL10P2IMax100 = max(abs(latTrainingData_P1(Num10P2IRL100Fz_P1,8)));
    RL12iP2IMax100 = max(abs(latTrainingData_P1(Num12iP2IRL100Fz_P1,8)));
    RL12fP2IMax100 = max(abs(latTrainingData_P2(Num12fP2IRL100Fz_P2,8)));
    RL14P2IMax100 = max(abs(latTrainingData_P1(Num14P2IRL100Fz_P1,8)));

    RL8P2IMax150 = max(abs(latTrainingData_P2(Num8P2IRL150Fz_P2,8)));
    RL10P2IMax150 = max(abs(latTrainingData_P1(Num10P2IRL150Fz_P1,8)));
    RL12iP2IMax150 = max(abs(latTrainingData_P1(Num12iP2IRL150Fz_P1,8)));
    RL12fP2IMax150 = max(abs(latTrainingData_P2(Num12fP2IRL150Fz_P2,8)));
    RL14P2IMax150 = max(abs(latTrainingData_P1(Num14P2IRL150Fz_P1,8)));

    RL8P2IMax200 = max(abs(latTrainingData_P2(Num8P2IRL200Fz_P2,8)));
    RL10P2IMax200 = max(abs(latTrainingData_P1(Num10P2IRL200Fz_P1,8)));
    RL12iP2IMax200 = max(abs(latTrainingData_P1(Num12iP2IRL200Fz_P1,8)));
    RL12fP2IMax200 = max(abs(latTrainingData_P2(Num12fP2IRL200Fz_P2,8)));
    RL14P2IMax200 = max(abs(latTrainingData_P1(Num14P2IRL200Fz_P1,8)));

    RL8P2IMax250 = max(abs(latTrainingData_P2(Num8P2IRL250Fz_P2,8)));
    RL10P2IMax250 = max(abs(latTrainingData_P1(Num10P2IRL250Fz_P1,8)));
    RL12iP2IMax250 = max(abs(latTrainingData_P1(Num12iP2IRL250Fz_P1,8)));
    RL12fP2IMax250 = max(abs(latTrainingData_P2(Num12fP2IRL250Fz_P2,8)));
    RL14P2IMax250 = max(abs(latTrainingData_P1(Num14P2IRL250Fz_P1,8)));

    % 4 deg Camber Stratification
    Num8P4IRL_P2 = intersect(Num8P4I_P2,NumRL_P2);
    Num10P4IRL_P1 = intersect(Num10P4I_P1,NumRL_P1);
    Num12iP4IRL_P1 = intersect(Num12P4I_P1,NumRL_P1);
    Num12fP4IRL_P2 = intersect(Num12P4I_P2,NumRL_P2);
    Num14P4IRL_P1 = intersect(Num14P4I_P1,NumRL_P1);

    Num8P4IRL50Fz_P2 = intersect(Num8P4IRL_P2,Num50Fz_P2);
    Num10P4IRL50Fz_P1 = intersect(Num10P4IRL_P1,Num50Fz_P1);
    Num12iP4IRL50Fz_P1 = intersect(Num12iP4IRL_P1,Num50Fz_P1);
    Num12fP4IRL50Fz_P2 = intersect(Num12fP4IRL_P2,Num50Fz_P2);
    Num14P4IRL50Fz_P1 = intersect(Num14P4IRL_P1,Num50Fz_P1);

    Num8P4IRL100Fz_P2 = intersect(Num8P4IRL_P2,Num100Fz_P2);
    Num10P4IRL100Fz_P1 = intersect(Num10P4IRL_P1,Num100Fz_P1);
    Num12iP4IRL100Fz_P1 = intersect(Num12iP4IRL_P1,Num100Fz_P1);
    Num12fP4IRL100Fz_P2 = intersect(Num12fP4IRL_P2,Num100Fz_P2);
    Num14P4IRL100Fz_P1 = intersect(Num14P4IRL_P1,Num100Fz_P1);

    Num8P4IRL150Fz_P2 = intersect(Num8P4IRL_P2,Num150Fz_P2);
    Num10P4IRL150Fz_P1 = intersect(Num10P4IRL_P1,Num150Fz_P1);
    Num12iP4IRL150Fz_P1 = intersect(Num12iP4IRL_P1,Num150Fz_P1);
    Num12fP4IRL150Fz_P2 = intersect(Num12fP4IRL_P2,Num150Fz_P2);
    Num14P4IRL150Fz_P1 = intersect(Num14P4IRL_P1,Num150Fz_P1);

    Num8P4IRL200Fz_P2 = intersect(Num8P4IRL_P2,Num200Fz_P2);
    Num10P4IRL200Fz_P1 = intersect(Num10P4IRL_P1,Num200Fz_P1);
    Num12iP4IRL200Fz_P1 = intersect(Num12iP4IRL_P1,Num200Fz_P1);
    Num12fP4IRL200Fz_P2 = intersect(Num12fP4IRL_P2,Num200Fz_P2);
    Num14P4IRL200Fz_P1 = intersect(Num14P4IRL_P1,Num200Fz_P1);

    Num8P4IRL250Fz_P2 = intersect(Num8P4I_P2,Num250Fz_P2);
    Num10P4IRL250Fz_P1 = intersect(Num10P4I_P1,Num250Fz_P1);
    Num12iP4IRL250Fz_P1 = intersect(Num12P4I_P1,Num250Fz_P1);
    Num12fP4IRL250Fz_P2 = intersect(Num12P4I_P2,Num250Fz_P2);
    Num14P4IRL250Fz_P1 = intersect(Num14P4I_P1,Num250Fz_P1);

    RL8P4IMax50 = max(abs(latTrainingData_P2(Num8P4IRL50Fz_P2,8)));
    RL10P4IMax50 = max(abs(latTrainingData_P1(Num10P4IRL50Fz_P1,8)));
    RL12iP4IMax50 = max(abs(latTrainingData_P1(Num12iP4IRL50Fz_P1,8)));
    RL12fP4IMax50 = max(abs(latTrainingData_P2(Num12fP4IRL50Fz_P2,8)));
    RL14P4IMax50 = max(abs(latTrainingData_P1(Num14P4IRL50Fz_P1,8)));

    RL8P4IMax100 = max(abs(latTrainingData_P2(Num8P4IRL100Fz_P2,8)));
    RL10P4IMax100 = max(abs(latTrainingData_P1(Num10P4IRL100Fz_P1,8)));
    RL12iP4IMax100 = max(abs(latTrainingData_P1(Num12iP4IRL100Fz_P1,8)));
    RL12fP4IMax100 = max(abs(latTrainingData_P2(Num12fP4IRL100Fz_P2,8)));
    RL14P4IMax100 = max(abs(latTrainingData_P1(Num14P4IRL100Fz_P1,8)));

    RL8P4IMax150 = max(abs(latTrainingData_P2(Num8P4IRL150Fz_P2,8)));
    RL10P4IMax150 = max(abs(latTrainingData_P1(Num10P4IRL150Fz_P1,8)));
    RL12iP4IMax150 = max(abs(latTrainingData_P1(Num12iP4IRL150Fz_P1,8)));
    RL12fP4IMax150 = max(abs(latTrainingData_P2(Num12fP4IRL150Fz_P2,8)));
    RL14P4IMax150 = max(abs(latTrainingData_P1(Num14P4IRL150Fz_P1,8)));

    RL8P4IMax200 = max(abs(latTrainingData_P2(Num8P4IRL200Fz_P2,8)));
    RL10P4IMax200 = max(abs(latTrainingData_P1(Num10P4IRL200Fz_P1,8)));
    RL12iP4IMax200 = max(abs(latTrainingData_P1(Num12iP4IRL200Fz_P1,8)));
    RL12fP4IMax200 = max(abs(latTrainingData_P2(Num12fP4IRL200Fz_P2,8)));
    RL14P4IMax200 = max(abs(latTrainingData_P1(Num14P4IRL200Fz_P1,8)));

    RL8P4IMax250 = max(abs(latTrainingData_P2(Num8P4IRL250Fz_P2,8)));
    RL10P4IMax250 = max(abs(latTrainingData_P1(Num10P4IRL250Fz_P1,8)));
    RL12iP4IMax250 = max(abs(latTrainingData_P1(Num12iP4IRL250Fz_P1,8)));
    RL12fP4IMax250 = max(abs(latTrainingData_P2(Num12fP4IRL250Fz_P2,8)));
    RL14P4IMax250 = max(abs(latTrainingData_P1(Num14P4IRL250Fz_P1,8)));

    FzRange = [-50,-100,-150,-200,-250];

    RL8P0ISweep = [RL8P0IMax50,RL8P0IMax100,RL8P0IMax150,RL8P0IMax200,RL8P0IMax250];
    RL10P0ISweep = [RL10P0IMax50,RL10P0IMax100,RL10P0IMax150,RL10P0IMax200,RL10P0IMax250];
    RL12iP0ISweep = [RL12iP0IMax50,RL12iP0IMax100,RL12iP0IMax150,RL12iP0IMax200,RL12iP0IMax250];
    RL12fP0ISweep = [RL12fP0IMax50,RL12fP0IMax100,RL12fP0IMax150,RL12fP0IMax200,RL12fP0IMax250];
    RL14P0ISweep = [RL14P0IMax50,RL14P0IMax100,RL14P0IMax150,RL14P0IMax200,RL14P0IMax250];

    RL8P2ISweep = [RL8P2IMax50,RL8P2IMax100,RL8P2IMax150,RL8P2IMax200,RL8P2IMax250];
    RL10P2ISweep = [RL10P2IMax50,RL10P2IMax100,RL10P2IMax150,RL10P2IMax200,RL10P2IMax250];
    RL12iP2ISweep = [RL12iP2IMax50,RL12iP2IMax100,RL12iP2IMax150,RL12iP2IMax200,RL12iP2IMax250];
    RL12fP2ISweep = [RL12fP2IMax50,RL12fP2IMax100,RL12fP2IMax150,RL12fP2IMax200,RL12fP2IMax250];
    RL14P2ISweep = [RL14P2IMax50,RL14P2IMax100,RL14P2IMax150,RL14P2IMax200,RL14P2IMax250];

    RL8P4ISweep = [RL8P4IMax50,RL8P4IMax100,RL8P4IMax150,RL8P4IMax200,RL8P4IMax250];
    RL10P4ISweep = [RL10P4IMax50,RL10P4IMax100,RL10P4IMax150,RL10P4IMax200,RL10P4IMax250];
    RL12iP4ISweep = [RL12iP4IMax50,RL12iP4IMax100,RL12iP4IMax150,RL12iP4IMax200,RL12iP4IMax250];
    RL12fP4ISweep = [RL12fP4IMax50,RL12fP4IMax100,RL12fP4IMax150,RL12fP4IMax200,RL12fP4IMax250];
    RL14P4ISweep = [RL14P4IMax50,RL14P4IMax100,RL14P4IMax150,RL14P4IMax200,RL14P4IMax250];

    poly8P0I = polyfit(RL8P0ISweep,FzRange,1);
    poly10P0I = polyfit(RL10P0ISweep,FzRange,1);
    poly12iP0I = polyfit(RL12iP0ISweep,FzRange,1);
    poly12fP0I = polyfit(RL12fP0ISweep,FzRange,1);
    poly14P0I = polyfit(RL14P0ISweep,FzRange,1);

    poly8P2I = polyfit(RL8P2ISweep,FzRange,1);
    poly10P2I = polyfit(RL10P2ISweep,FzRange,1);
    poly12iP2I = polyfit(RL12iP2ISweep,FzRange,1);
    poly12fP2I = polyfit(RL12fP2ISweep,FzRange,1);
    poly14P2I = polyfit(RL14P2ISweep,FzRange,1);

    poly8P4I = polyfit(RL8P4ISweep,FzRange,1);
    poly10P4I = polyfit(RL10P4ISweep,FzRange,1);
    poly12iP4I = polyfit(RL12iP4ISweep,FzRange,1);
    poly12fP4I = polyfit(RL12fP4ISweep,FzRange,1);
    poly14P4I = polyfit(RL14P4ISweep,FzRange,1);

    polyfits0I = [poly8P0I(1,1); poly10P0I(1,1); poly12iP0I(1,1); poly12fP0I(1,1); poly14P0I(1,1)];

    polyfits2I = [poly8P2I(1,1); poly10P2I(1,1); poly12iP2I(1,1); poly12fP2I(1,1); poly14P2I(1,1)];

    polyfits4I = [poly8P4I(1,1); poly10P4I(1,1); poly12iP4I(1,1); poly12fP4I(1,1); poly14P4I(1,1)];
=======
%% Spring Rate Calculator

function [K_t] = SpringRateCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicle)

    %% Fronts 
    % "Traditional" Plots - Data Stratification
    
    Num8psi_P1F =  find(latTrainingData_P1F(:,4) <= 9);
    Num10psi_P1F =  find(latTrainingData_P1F(:,4) > 9 & latTrainingData_P1F(:,4) <= 11);
    Num12psi_P1F =  find(latTrainingData_P1F(:,4) > 11 & latTrainingData_P1F(:,4) <= 13);
    Num14psi_P1F =  find(latTrainingData_P1F(:,4) > 13);
    
    Num8psi_P2F =  find(latTrainingData_P2F(:,4) <= 9);
    Num10psi_P2F =  find(latTrainingData_P2F(:,4) > 9 & latTrainingData_P2F(:,4) <= 11);
    Num12psi_P2F =  find(latTrainingData_P2F(:,4) > 11 & latTrainingData_P2F(:,4) <= 13);
    Num14psi_P2F =  find(latTrainingData_P2F(:,4) > 13);
    
    Num0IA_P1F = find(latTrainingData_P1F(:,2) <= 0.5);
    Num2IA_P1F = find(latTrainingData_P1F(:,2) > 1.5 & latTrainingData_P1F(:,2) <= 2.5);
    Num4IA_P1F = find(latTrainingData_P1F(:,2) > 3.5 & latTrainingData_P1F(:,2) <= 4.5);
    
    Num0IA_P2F = find(latTrainingData_P2F(:,2) <= 0.5);
    Num2IA_P2F = find(latTrainingData_P2F(:,2) > 1.5 & latTrainingData_P2F(:,2) <= 2.5);
    Num4IA_P2F = find(latTrainingData_P2F(:,2) > 3.5 & latTrainingData_P2F(:,2) <= 4.5);
    
    Num8P0I_P1F = intersect(Num8psi_P1F,Num0IA_P1F);
    Num8P2FI_P1F = intersect(Num8psi_P1F,Num2IA_P1F);
    Num8P4I_P1F = intersect(Num8psi_P1F,Num4IA_P1F);
    
    Num8P0I_P2F = intersect(Num8psi_P2F,Num0IA_P2F);
    Num8P2FI_P2F = intersect(Num8psi_P2F,Num2IA_P2F);
    Num8P4I_P2F = intersect(Num8psi_P2F,Num4IA_P2F);
    
    Num10P0I_P1F = intersect(Num10psi_P1F,Num0IA_P1F);
    Num10P2FI_P1F = intersect(Num10psi_P1F,Num2IA_P1F);
    Num10P4I_P1F = intersect(Num10psi_P1F,Num4IA_P1F);
    
    Num10P0I_P2F = intersect(Num10psi_P2F,Num0IA_P2F);
    Num10P2FI_P2F = intersect(Num10psi_P2F,Num2IA_P2F);
    Num10P4I_P2F = intersect(Num10psi_P2F,Num4IA_P2F);
    
    Num12P0I_P1F = intersect(Num12psi_P1F,Num0IA_P1F);
    Num12P2FI_P1F = intersect(Num12psi_P1F,Num2IA_P1F);
    Num12P4I_P1F = intersect(Num12psi_P1F,Num4IA_P1F);
    
    Num12P0I_P2F = intersect(Num12psi_P2F,Num0IA_P2F);
    Num12P2FI_P2F = intersect(Num12psi_P2F,Num2IA_P2F);
    Num12P4I_P2F = intersect(Num12psi_P2F,Num4IA_P2F);
    
    Num14P0I_P1F = intersect(Num14psi_P1F,Num0IA_P1F);
    Num14P2FI_P1F = intersect(Num14psi_P1F,Num2IA_P1F);
    Num14P4I_P1F = intersect(Num14psi_P1F,Num4IA_P1F);
    
    Num14P0I_P2F = intersect(Num14psi_P2F,Num0IA_P2F);
    Num14P2FI_P2F = intersect(Num14psi_P2F,Num2IA_P2F);
    Num14P4I_P2F = intersect(Num14psi_P2F,Num4IA_P2F);
    
    Num50Fz_P1F =  find(latTrainingData_P1F(:,3) > -75);
    Num100Fz_P1F =  find(latTrainingData_P1F(:,3) <= -75 & latTrainingData_P1F(:,3) > -125);
    Num150Fz_P1F =  find(latTrainingData_P1F(:,3) <= -125 & latTrainingData_P1F(:,3) > -175);
    Num200Fz_P1F =  find(latTrainingData_P1F(:,3) <= -175 & latTrainingData_P1F(:,3) > -225);
    Num250Fz_P1F = find(latTrainingData_P1F(:,3) <= -225);
    
    Num50Fz_P2F =  find(latTrainingData_P2F(:,3) > -75);
    Num100Fz_P2F =  find(latTrainingData_P2F(:,3) <= -75 & latTrainingData_P2F(:,3) > -125);
    Num150Fz_P2F =  find(latTrainingData_P2F(:,3) <= -125 & latTrainingData_P2F(:,3) > -175);
    Num200Fz_P2F =  find(latTrainingData_P2F(:,3) <= -175 & latTrainingData_P2F(:,3) > -225);
    Num250Fz_P2F = find(latTrainingData_P2F(:,3) <= -225);
    
    NumRL_P1F = find(latTrainingData_P1F(:,8));
    NumRL_P2F = find(latTrainingData_P2F(:,8));
    
    % 0 deg Camber Stratification
    Num8P0IRL_P2F = intersect(Num8P0I_P2F,NumRL_P2F);
    Num10P0IRL_P1F = intersect(Num10P0I_P1F,NumRL_P1F);
    Num12iP0IRL_P1F = intersect(Num12P0I_P1F,NumRL_P1F);
    Num12fP0IRL_P2F = intersect(Num12P0I_P2F,NumRL_P2F);
    Num14P0IRL_P1F = intersect(Num14P0I_P1F,NumRL_P1F);

    Num8P0IRL50Fz_P2F = intersect(Num8P0IRL_P2F,Num50Fz_P2F);
    Num10P0IRL50Fz_P1F = intersect(Num10P0IRL_P1F,Num50Fz_P1F);
    Num12iP0IRL50Fz_P1F = intersect(Num12iP0IRL_P1F,Num50Fz_P1F);
    Num12fP0IRL50Fz_P2F = intersect(Num12fP0IRL_P2F,Num50Fz_P2F);
    Num14P0IRL50Fz_P1F = intersect(Num14P0IRL_P1F,Num50Fz_P1F);

    Num8P0IRL100Fz_P2F = intersect(Num8P0IRL_P2F,Num100Fz_P2F);
    Num10P0IRL100Fz_P1F = intersect(Num10P0IRL_P1F,Num100Fz_P1F);
    Num12iP0IRL100Fz_P1F = intersect(Num12iP0IRL_P1F,Num100Fz_P1F);
    Num12fP0IRL100Fz_P2F = intersect(Num12fP0IRL_P2F,Num100Fz_P2F);
    Num14P0IRL100Fz_P1F = intersect(Num14P0IRL_P1F,Num100Fz_P1F);

    Num8P0IRL150Fz_P2F = intersect(Num8P0IRL_P2F,Num150Fz_P2F);
    Num10P0IRL150Fz_P1F = intersect(Num10P0IRL_P1F,Num150Fz_P1F);
    Num12iP0IRL150Fz_P1F = intersect(Num12iP0IRL_P1F,Num150Fz_P1F);
    Num12fP0IRL150Fz_P2F = intersect(Num12fP0IRL_P2F,Num150Fz_P2F);
    Num14P0IRL150Fz_P1F = intersect(Num14P0IRL_P1F,Num150Fz_P1F);

    Num8P0IRL200Fz_P2F = intersect(Num8P0IRL_P2F,Num200Fz_P2F);
    Num10P0IRL200Fz_P1F = intersect(Num10P0IRL_P1F,Num200Fz_P1F);
    Num12iP0IRL200Fz_P1F = intersect(Num12iP0IRL_P1F,Num200Fz_P1F);
    Num12fP0IRL200Fz_P2F = intersect(Num12fP0IRL_P2F,Num200Fz_P2F);
    Num14P0IRL200Fz_P1F = intersect(Num14P0IRL_P1F,Num200Fz_P1F);

    Num8P0IRL250Fz_P2F = intersect(Num8P0IRL_P2F,Num250Fz_P2F);
    Num10P0IRL250Fz_P1F = intersect(Num10P0IRL_P1F,Num250Fz_P1F);
    Num12iP0IRL250Fz_P1F = intersect(Num12iP0IRL_P1F,Num250Fz_P1F);
    Num12fP0IRL250Fz_P2F = intersect(Num12fP0IRL_P2F,Num250Fz_P2F);
    Num14P0IRL250Fz_P1F = intersect(Num14P0IRL_P1F,Num250Fz_P1F);

    RL8P0IMax50F = max(abs(latTrainingData_P2F(Num8P0IRL50Fz_P2F,8)));
    RL10P0IMax50F = max(abs(latTrainingData_P1F(Num10P0IRL50Fz_P1F,8)));
    RL12iP0IMax50F = max(abs(latTrainingData_P1F(Num12iP0IRL50Fz_P1F,8)));
    RL12fP0IMax50F = max(abs(latTrainingData_P2F(Num12fP0IRL50Fz_P2F,8)));
    RL14P0IMax50F = max(abs(latTrainingData_P1F(Num14P0IRL50Fz_P1F,8)));

    RL8P0IMax100F = max(abs(latTrainingData_P2F(Num8P0IRL100Fz_P2F,8)));
    RL10P0IMax100F = max(abs(latTrainingData_P1F(Num10P0IRL100Fz_P1F,8)));
    RL12iP0IMax100F = max(abs(latTrainingData_P1F(Num12iP0IRL100Fz_P1F,8)));
    RL12fP0IMax100F = max(abs(latTrainingData_P2F(Num12fP0IRL100Fz_P2F,8)));
    RL14P0IMax100F = max(abs(latTrainingData_P1F(Num14P0IRL100Fz_P1F,8)));

    RL8P0IMax150F = max(abs(latTrainingData_P2F(Num8P0IRL150Fz_P2F,8)));
    RL10P0IMax150F = max(abs(latTrainingData_P1F(Num10P0IRL150Fz_P1F,8)));
    RL12iP0IMax150F = max(abs(latTrainingData_P1F(Num12iP0IRL150Fz_P1F,8)));
    RL12fP0IMax150F = max(abs(latTrainingData_P2F(Num12fP0IRL150Fz_P2F,8)));
    RL14P0IMax150F = max(abs(latTrainingData_P1F(Num14P0IRL150Fz_P1F,8)));

    RL8P0IMax200F = max(abs(latTrainingData_P2F(Num8P0IRL200Fz_P2F,8)));
    RL10P0IMax200F = max(abs(latTrainingData_P1F(Num10P0IRL200Fz_P1F,8)));
    RL12iP0IMax200F = max(abs(latTrainingData_P1F(Num12iP0IRL200Fz_P1F,8)));
    RL12fP0IMax200F = max(abs(latTrainingData_P2F(Num12fP0IRL200Fz_P2F,8)));
    RL14P0IMax200F = max(abs(latTrainingData_P1F(Num14P0IRL200Fz_P1F,8)));

    RL8P0IMax250F = max(abs(latTrainingData_P2F(Num8P0IRL250Fz_P2F,8)));
    RL10P0IMax250F = max(abs(latTrainingData_P1F(Num10P0IRL250Fz_P1F,8)));
    RL12iP0IMax250F = max(abs(latTrainingData_P1F(Num12iP0IRL250Fz_P1F,8)));
    RL12fP0IMax250F = max(abs(latTrainingData_P2F(Num12fP0IRL250Fz_P2F,8)));
    RL14P0IMax250F = max(abs(latTrainingData_P1F(Num14P0IRL250Fz_P1F,8)));

    % 2 deg Camber Stratification
    Num8P2FIRL_P2F = intersect(Num8P2FI_P2F,NumRL_P2F);
    Num10P2FIRL_P1F = intersect(Num10P2FI_P1F,NumRL_P1F);
    Num12iP2FIRL_P1F = intersect(Num12P2FI_P1F,NumRL_P1F);
    Num12fP2FIRL_P2F = intersect(Num12P2FI_P2F,NumRL_P2F);
    Num14P2FIRL_P1F = intersect(Num14P2FI_P1F,NumRL_P1F);

    Num8P2FIRL50Fz_P2F = intersect(Num8P2FIRL_P2F,Num50Fz_P2F);
    Num10P2FIRL50Fz_P1F = intersect(Num10P2FIRL_P1F,Num50Fz_P1F);
    Num12iP2FIRL50Fz_P1F = intersect(Num12iP2FIRL_P1F,Num50Fz_P1F);
    Num12fP2FIRL50Fz_P2F = intersect(Num12fP2FIRL_P2F,Num50Fz_P2F);
    Num14P2FIRL50Fz_P1F = intersect(Num14P2FIRL_P1F,Num50Fz_P1F);

    Num8P2FIRL100Fz_P2F = intersect(Num8P2FIRL_P2F,Num100Fz_P2F);
    Num10P2FIRL100Fz_P1F = intersect(Num10P2FIRL_P1F,Num100Fz_P1F);
    Num12iP2FIRL100Fz_P1F = intersect(Num12iP2FIRL_P1F,Num100Fz_P1F);
    Num12fP2FIRL100Fz_P2F = intersect(Num12fP2FIRL_P2F,Num100Fz_P2F);
    Num14P2FIRL100Fz_P1F = intersect(Num14P2FIRL_P1F,Num100Fz_P1F);

    Num8P2FIRL150Fz_P2F = intersect(Num8P2FIRL_P2F,Num150Fz_P2F);
    Num10P2FIRL150Fz_P1F = intersect(Num10P2FIRL_P1F,Num150Fz_P1F);
    Num12iP2FIRL150Fz_P1F = intersect(Num12iP2FIRL_P1F,Num150Fz_P1F);
    Num12fP2FIRL150Fz_P2F = intersect(Num12fP2FIRL_P2F,Num150Fz_P2F);
    Num14P2FIRL150Fz_P1F = intersect(Num14P2FIRL_P1F,Num150Fz_P1F);

    Num8P2FIRL200Fz_P2F = intersect(Num8P2FIRL_P2F,Num200Fz_P2F);
    Num10P2FIRL200Fz_P1F = intersect(Num10P2FIRL_P1F,Num200Fz_P1F);
    Num12iP2FIRL200Fz_P1F = intersect(Num12iP2FIRL_P1F,Num200Fz_P1F);
    Num12fP2FIRL200Fz_P2F = intersect(Num12fP2FIRL_P2F,Num200Fz_P2F);
    Num14P2FIRL200Fz_P1F = intersect(Num14P2FIRL_P1F,Num200Fz_P1F);

    Num8P2FIRL250Fz_P2F = intersect(Num8P2FIRL_P2F,Num250Fz_P2F);
    Num10P2FIRL250Fz_P1F = intersect(Num10P2FIRL_P1F,Num250Fz_P1F);
    Num12iP2FIRL250Fz_P1F = intersect(Num12iP2FIRL_P1F,Num250Fz_P1F);
    Num12fP2FIRL250Fz_P2F = intersect(Num12fP2FIRL_P2F,Num250Fz_P2F);
    Num14P2FIRL250Fz_P1F = intersect(Num14P2FIRL_P1F,Num250Fz_P1F);

    RL8P2FIMax50F = max(abs(latTrainingData_P2F(Num8P2FIRL50Fz_P2F,8)));
    RL10P2FIMax50F = max(abs(latTrainingData_P1F(Num10P2FIRL50Fz_P1F,8)));
    RL12iP2FIMax50F = max(abs(latTrainingData_P1F(Num12iP2FIRL50Fz_P1F,8)));
    RL12fP2FIMax50F = max(abs(latTrainingData_P2F(Num12fP2FIRL50Fz_P2F,8)));
    RL14P2FIMax50F = max(abs(latTrainingData_P1F(Num14P2FIRL50Fz_P1F,8)));

    RL8P2FIMax100F = max(abs(latTrainingData_P2F(Num8P2FIRL100Fz_P2F,8)));
    RL10P2FIMax100F = max(abs(latTrainingData_P1F(Num10P2FIRL100Fz_P1F,8)));
    RL12iP2FIMax100F = max(abs(latTrainingData_P1F(Num12iP2FIRL100Fz_P1F,8)));
    RL12fP2FIMax100F = max(abs(latTrainingData_P2F(Num12fP2FIRL100Fz_P2F,8)));
    RL14P2FIMax100F = max(abs(latTrainingData_P1F(Num14P2FIRL100Fz_P1F,8)));

    RL8P2FIMax150F = max(abs(latTrainingData_P2F(Num8P2FIRL150Fz_P2F,8)));
    RL10P2FIMax150F = max(abs(latTrainingData_P1F(Num10P2FIRL150Fz_P1F,8)));
    RL12iP2FIMax150F = max(abs(latTrainingData_P1F(Num12iP2FIRL150Fz_P1F,8)));
    RL12fP2FIMax150F = max(abs(latTrainingData_P2F(Num12fP2FIRL150Fz_P2F,8)));
    RL14P2FIMax150F = max(abs(latTrainingData_P1F(Num14P2FIRL150Fz_P1F,8)));

    RL8P2FIMax200F = max(abs(latTrainingData_P2F(Num8P2FIRL200Fz_P2F,8)));
    RL10P2FIMax200F = max(abs(latTrainingData_P1F(Num10P2FIRL200Fz_P1F,8)));
    RL12iP2FIMax200F = max(abs(latTrainingData_P1F(Num12iP2FIRL200Fz_P1F,8)));
    RL12fP2FIMax200F = max(abs(latTrainingData_P2F(Num12fP2FIRL200Fz_P2F,8)));
    RL14P2FIMax200F = max(abs(latTrainingData_P1F(Num14P2FIRL200Fz_P1F,8)));

    RL8P2FIMax250F = max(abs(latTrainingData_P2F(Num8P2FIRL250Fz_P2F,8)));
    RL10P2FIMax250F = max(abs(latTrainingData_P1F(Num10P2FIRL250Fz_P1F,8)));
    RL12iP2FIMax250F = max(abs(latTrainingData_P1F(Num12iP2FIRL250Fz_P1F,8)));
    RL12fP2FIMax250F = max(abs(latTrainingData_P2F(Num12fP2FIRL250Fz_P2F,8)));
    RL14P2FIMax250F = max(abs(latTrainingData_P1F(Num14P2FIRL250Fz_P1F,8)));

    % 4 deg Camber Stratification
    Num8P4IRL_P2F = intersect(Num8P4I_P2F,NumRL_P2F);
    Num10P4IRL_P1F = intersect(Num10P4I_P1F,NumRL_P1F);
    Num12iP4IRL_P1F = intersect(Num12P4I_P1F,NumRL_P1F);
    Num12fP4IRL_P2F = intersect(Num12P4I_P2F,NumRL_P2F);
    Num14P4IRL_P1F = intersect(Num14P4I_P1F,NumRL_P1F);

    Num8P4IRL50Fz_P2F = intersect(Num8P4IRL_P2F,Num50Fz_P2F);
    Num10P4IRL50Fz_P1F = intersect(Num10P4IRL_P1F,Num50Fz_P1F);
    Num12iP4IRL50Fz_P1F = intersect(Num12iP4IRL_P1F,Num50Fz_P1F);
    Num12fP4IRL50Fz_P2F = intersect(Num12fP4IRL_P2F,Num50Fz_P2F);
    Num14P4IRL50Fz_P1F = intersect(Num14P4IRL_P1F,Num50Fz_P1F);

    Num8P4IRL100Fz_P2F = intersect(Num8P4IRL_P2F,Num100Fz_P2F);
    Num10P4IRL100Fz_P1F = intersect(Num10P4IRL_P1F,Num100Fz_P1F);
    Num12iP4IRL100Fz_P1F = intersect(Num12iP4IRL_P1F,Num100Fz_P1F);
    Num12fP4IRL100Fz_P2F = intersect(Num12fP4IRL_P2F,Num100Fz_P2F);
    Num14P4IRL100Fz_P1F = intersect(Num14P4IRL_P1F,Num100Fz_P1F);

    Num8P4IRL150Fz_P2F = intersect(Num8P4IRL_P2F,Num150Fz_P2F);
    Num10P4IRL150Fz_P1F = intersect(Num10P4IRL_P1F,Num150Fz_P1F);
    Num12iP4IRL150Fz_P1F = intersect(Num12iP4IRL_P1F,Num150Fz_P1F);
    Num12fP4IRL150Fz_P2F = intersect(Num12fP4IRL_P2F,Num150Fz_P2F);
    Num14P4IRL150Fz_P1F = intersect(Num14P4IRL_P1F,Num150Fz_P1F);

    Num8P4IRL200Fz_P2F = intersect(Num8P4IRL_P2F,Num200Fz_P2F);
    Num10P4IRL200Fz_P1F = intersect(Num10P4IRL_P1F,Num200Fz_P1F);
    Num12iP4IRL200Fz_P1F = intersect(Num12iP4IRL_P1F,Num200Fz_P1F);
    Num12fP4IRL200Fz_P2F = intersect(Num12fP4IRL_P2F,Num200Fz_P2F);
    Num14P4IRL200Fz_P1F = intersect(Num14P4IRL_P1F,Num200Fz_P1F);

    Num8P4IRL250Fz_P2F = intersect(Num8P4I_P2F,Num250Fz_P2F);
    Num10P4IRL250Fz_P1F = intersect(Num10P4I_P1F,Num250Fz_P1F);
    Num12iP4IRL250Fz_P1F = intersect(Num12P4I_P1F,Num250Fz_P1F);
    Num12fP4IRL250Fz_P2F = intersect(Num12P4I_P2F,Num250Fz_P2F);
    Num14P4IRL250Fz_P1F = intersect(Num14P4I_P1F,Num250Fz_P1F);

    RL8P4IMax50F = max(abs(latTrainingData_P2F(Num8P4IRL50Fz_P2F,8)));
    RL10P4IMax50F = max(abs(latTrainingData_P1F(Num10P4IRL50Fz_P1F,8)));
    RL12iP4IMax50F = max(abs(latTrainingData_P1F(Num12iP4IRL50Fz_P1F,8)));
    RL12fP4IMax50F = max(abs(latTrainingData_P2F(Num12fP4IRL50Fz_P2F,8)));
    RL14P4IMax50F = max(abs(latTrainingData_P1F(Num14P4IRL50Fz_P1F,8)));

    RL8P4IMax100F = max(abs(latTrainingData_P2F(Num8P4IRL100Fz_P2F,8)));
    RL10P4IMax100F = max(abs(latTrainingData_P1F(Num10P4IRL100Fz_P1F,8)));
    RL12iP4IMax100F = max(abs(latTrainingData_P1F(Num12iP4IRL100Fz_P1F,8)));
    RL12fP4IMax100F = max(abs(latTrainingData_P2F(Num12fP4IRL100Fz_P2F,8)));
    RL14P4IMax100F = max(abs(latTrainingData_P1F(Num14P4IRL100Fz_P1F,8)));

    RL8P4IMax150F = max(abs(latTrainingData_P2F(Num8P4IRL150Fz_P2F,8)));
    RL10P4IMax150F = max(abs(latTrainingData_P1F(Num10P4IRL150Fz_P1F,8)));
    RL12iP4IMax150F = max(abs(latTrainingData_P1F(Num12iP4IRL150Fz_P1F,8)));
    RL12fP4IMax150F = max(abs(latTrainingData_P2F(Num12fP4IRL150Fz_P2F,8)));
    RL14P4IMax150F = max(abs(latTrainingData_P1F(Num14P4IRL150Fz_P1F,8)));

    RL8P4IMax200F = max(abs(latTrainingData_P2F(Num8P4IRL200Fz_P2F,8)));
    RL10P4IMax200F = max(abs(latTrainingData_P1F(Num10P4IRL200Fz_P1F,8)));
    RL12iP4IMax200F = max(abs(latTrainingData_P1F(Num12iP4IRL200Fz_P1F,8)));
    RL12fP4IMax200F = max(abs(latTrainingData_P2F(Num12fP4IRL200Fz_P2F,8)));
    RL14P4IMax200F = max(abs(latTrainingData_P1F(Num14P4IRL200Fz_P1F,8)));

    RL8P4IMax250F = max(abs(latTrainingData_P2F(Num8P4IRL250Fz_P2F,8)));
    RL10P4IMax250F = max(abs(latTrainingData_P1F(Num10P4IRL250Fz_P1F,8)));
    RL12iP4IMax250F = max(abs(latTrainingData_P1F(Num12iP4IRL250Fz_P1F,8)));
    RL12fP4IMax250F = max(abs(latTrainingData_P2F(Num12fP4IRL250Fz_P2F,8)));
    RL14P4IMax250F = max(abs(latTrainingData_P1F(Num14P4IRL250Fz_P1F,8)));

    FzRange = [-50,-100,-150,-200,-250];

    % Spring Rate Sweeps

    RL8P0ISweepF = [RL8P0IMax50F,RL8P0IMax100F,RL8P0IMax150F,RL8P0IMax200F,RL8P0IMax250F];
    RL10P0ISweepF = [RL10P0IMax50F,RL10P0IMax100F,RL10P0IMax150F,RL10P0IMax200F,RL10P0IMax250F];
    RL12iP0ISweepF = [RL12iP0IMax50F,RL12iP0IMax100F,RL12iP0IMax150F,RL12iP0IMax200F,RL12iP0IMax250F];
    RL12fP0ISweepF = [RL12fP0IMax50F,RL12fP0IMax100F,RL12fP0IMax150F,RL12fP0IMax200F,RL12fP0IMax250F];
    RL14P0ISweepF = [RL14P0IMax50F,RL14P0IMax100F,RL14P0IMax150F,RL14P0IMax200F,RL14P0IMax250F];

    RL8P2FISweepF = [RL8P2FIMax50F,RL8P2FIMax100F,RL8P2FIMax150F,RL8P2FIMax200F,RL8P2FIMax250F];
    RL10P2FISweepF = [RL10P2FIMax50F,RL10P2FIMax100F,RL10P2FIMax150F,RL10P2FIMax200F,RL10P2FIMax250F];
    RL12iP2FISweepF = [RL12iP2FIMax50F,RL12iP2FIMax100F,RL12iP2FIMax150F,RL12iP2FIMax200F,RL12iP2FIMax250F];
    RL12fP2FISweepF = [RL12fP2FIMax50F,RL12fP2FIMax100F,RL12fP2FIMax150F,RL12fP2FIMax200F,RL12fP2FIMax250F];
    RL14P2FISweepF = [RL14P2FIMax50F,RL14P2FIMax100F,RL14P2FIMax150F,RL14P2FIMax200F,RL14P2FIMax250F];

    RL8P4ISweepF = [RL8P4IMax50F,RL8P4IMax100F,RL8P4IMax150F,RL8P4IMax200F,RL8P4IMax250F];
    RL10P4ISweepF = [RL10P4IMax50F,RL10P4IMax100F,RL10P4IMax150F,RL10P4IMax200F,RL10P4IMax250F];
    RL12iP4ISweepF = [RL12iP4IMax50F,RL12iP4IMax100F,RL12iP4IMax150F,RL12iP4IMax200F,RL12iP4IMax250F];
    RL12fP4ISweepF = [RL12fP4IMax50F,RL12fP4IMax100F,RL12fP4IMax150F,RL12fP4IMax200F,RL12fP4IMax250F];
    RL14P4ISweepF = [RL14P4IMax50F,RL14P4IMax100F,RL14P4IMax150F,RL14P4IMax200F,RL14P4IMax250F];

    poly8P0IF = polyfit(RL8P0ISweepF,FzRange,1);
    poly10P0IF = polyfit(RL10P0ISweepF,FzRange,1);
    poly12iP0IF = polyfit(RL12iP0ISweepF,FzRange,1);
    poly12fP0IF = polyfit(RL12fP0ISweepF,FzRange,1);
    poly14P0IF = polyfit(RL14P0ISweepF,FzRange,1);

    poly8P2FIF = polyfit(RL8P2FISweepF,FzRange,1);
    poly10P2FIF = polyfit(RL10P2FISweepF,FzRange,1);
    poly12iP2FIF = polyfit(RL12iP2FISweepF,FzRange,1);
    poly12fP2FIF = polyfit(RL12fP2FISweepF,FzRange,1);
    poly14P2FIF = polyfit(RL14P2FISweepF,FzRange,1);

    poly8P4IF = polyfit(RL8P4ISweepF,FzRange,1);
    poly10P4IF = polyfit(RL10P4ISweepF,FzRange,1);
    poly12iP4IF = polyfit(RL12iP4ISweepF,FzRange,1);
    poly12fP4IF = polyfit(RL12fP4ISweepF,FzRange,1);
    poly14P4IF = polyfit(RL14P4ISweepF,FzRange,1);

    polyfits0IF = [poly8P0IF(1,1); poly10P0IF(1,1); poly12iP0IF(1,1); poly12fP0IF(1,1); poly14P0IF(1,1)];

    polyfits2IF = [poly8P2FIF(1,1); poly10P2FIF(1,1); poly12iP2FIF(1,1); poly12fP2FIF(1,1); poly14P2FIF(1,1)];

    polyfits4IF = [poly8P4IF(1,1); poly10P4IF(1,1); poly12iP4IF(1,1); poly12fP4IF(1,1); poly14P4IF(1,1)];

    %% Rears
    % "Traditional" Plots - Data Stratification
    
    Num8psi_P1R =  find(latTrainingData_P1R(:,4) <= 9);
    Num10psi_P1R =  find(latTrainingData_P1R(:,4) > 9 & latTrainingData_P1R(:,4) <= 11);
    Num12psi_P1R =  find(latTrainingData_P1R(:,4) > 11 & latTrainingData_P1R(:,4) <= 13);
    Num14psi_P1R =  find(latTrainingData_P1R(:,4) > 13);
    
    Num8psi_P2R =  find(latTrainingData_P2R(:,4) <= 9);
    Num10psi_P2R =  find(latTrainingData_P2R(:,4) > 9 & latTrainingData_P2R(:,4) <= 11);
    Num12psi_P2R =  find(latTrainingData_P2R(:,4) > 11 & latTrainingData_P2R(:,4) <= 13);
    Num14psi_P2R =  find(latTrainingData_P2R(:,4) > 13);
    
    Num0IA_P1R = find(latTrainingData_P1R(:,2) <= 0.5);
    Num2IA_P1R = find(latTrainingData_P1R(:,2) > 1.5 & latTrainingData_P1R(:,2) <= 2.5);
    Num4IA_P1R = find(latTrainingData_P1R(:,2) > 3.5 & latTrainingData_P1R(:,2) <= 4.5);
    
    Num0IA_P2R = find(latTrainingData_P2R(:,2) <= 0.5);
    Num2IA_P2R = find(latTrainingData_P2R(:,2) > 1.5 & latTrainingData_P2R(:,2) <= 2.5);
    Num4IA_P2R = find(latTrainingData_P2R(:,2) > 3.5 & latTrainingData_P2R(:,2) <= 4.5);
    
    Num8P0I_P1R = intersect(Num8psi_P1R,Num0IA_P1R);
    Num8P2RI_P1R = intersect(Num8psi_P1R,Num2IA_P1R);
    Num8P4I_P1R = intersect(Num8psi_P1R,Num4IA_P1R);
    
    Num8P0I_P2R = intersect(Num8psi_P2R,Num0IA_P2R);
    Num8P2RI_P2R = intersect(Num8psi_P2R,Num2IA_P2R);
    Num8P4I_P2R = intersect(Num8psi_P2R,Num4IA_P2R);
    
    Num10P0I_P1R = intersect(Num10psi_P1R,Num0IA_P1R);
    Num10P2RI_P1R = intersect(Num10psi_P1R,Num2IA_P1R);
    Num10P4I_P1R = intersect(Num10psi_P1R,Num4IA_P1R);
    
    Num10P0I_P2R = intersect(Num10psi_P2R,Num0IA_P2R);
    Num10P2RI_P2R = intersect(Num10psi_P2R,Num2IA_P2R);
    Num10P4I_P2R = intersect(Num10psi_P2R,Num4IA_P2R);
    
    Num12P0I_P1R = intersect(Num12psi_P1R,Num0IA_P1R);
    Num12P2RI_P1R = intersect(Num12psi_P1R,Num2IA_P1R);
    Num12P4I_P1R = intersect(Num12psi_P1R,Num4IA_P1R);
    
    Num12P0I_P2R = intersect(Num12psi_P2R,Num0IA_P2R);
    Num12P2RI_P2R = intersect(Num12psi_P2R,Num2IA_P2R);
    Num12P4I_P2R = intersect(Num12psi_P2R,Num4IA_P2R);
    
    Num14P0I_P1R = intersect(Num14psi_P1R,Num0IA_P1R);
    Num14P2RI_P1R = intersect(Num14psi_P1R,Num2IA_P1R);
    Num14P4I_P1R = intersect(Num14psi_P1R,Num4IA_P1R);
    
    Num14P0I_P2R = intersect(Num14psi_P2R,Num0IA_P2R);
    Num14P2RI_P2R = intersect(Num14psi_P2R,Num2IA_P2R);
    Num14P4I_P2R = intersect(Num14psi_P2R,Num4IA_P2R);
    
    Num50Rz_P1R =  find(latTrainingData_P1R(:,3) > -75);
    Num100Rz_P1R =  find(latTrainingData_P1R(:,3) <= -75 & latTrainingData_P1R(:,3) > -125);
    Num150Rz_P1R =  find(latTrainingData_P1R(:,3) <= -125 & latTrainingData_P1R(:,3) > -175);
    Num200Rz_P1R =  find(latTrainingData_P1R(:,3) <= -175 & latTrainingData_P1R(:,3) > -225);
    Num250Rz_P1R = find(latTrainingData_P1R(:,3) <= -225);
    
    Num50Rz_P2R =  find(latTrainingData_P2R(:,3) > -75);
    Num100Rz_P2R =  find(latTrainingData_P2R(:,3) <= -75 & latTrainingData_P2R(:,3) > -125);
    Num150Rz_P2R =  find(latTrainingData_P2R(:,3) <= -125 & latTrainingData_P2R(:,3) > -175);
    Num200Rz_P2R =  find(latTrainingData_P2R(:,3) <= -175 & latTrainingData_P2R(:,3) > -225);
    Num250Rz_P2R = find(latTrainingData_P2R(:,3) <= -225);
    
    NumRL_P1R = find(latTrainingData_P1R(:,8));
    NumRL_P2R = find(latTrainingData_P2R(:,8));
    
    % 0 deg Camber Stratification
    Num8P0IRL_P2R = intersect(Num8P0I_P2R,NumRL_P2R);
    Num10P0IRL_P1R = intersect(Num10P0I_P1R,NumRL_P1R);
    Num12iP0IRL_P1R = intersect(Num12P0I_P1R,NumRL_P1R);
    Num12RP0IRL_P2R = intersect(Num12P0I_P2R,NumRL_P2R);
    Num14P0IRL_P1R = intersect(Num14P0I_P1R,NumRL_P1R);

    Num8P0IRL50Rz_P2R = intersect(Num8P0IRL_P2R,Num50Rz_P2R);
    Num10P0IRL50Rz_P1R = intersect(Num10P0IRL_P1R,Num50Rz_P1R);
    Num12iP0IRL50Rz_P1R = intersect(Num12iP0IRL_P1R,Num50Rz_P1R);
    Num12RP0IRL50Rz_P2R = intersect(Num12RP0IRL_P2R,Num50Rz_P2R);
    Num14P0IRL50Rz_P1R = intersect(Num14P0IRL_P1R,Num50Rz_P1R);

    Num8P0IRL100Rz_P2R = intersect(Num8P0IRL_P2R,Num100Rz_P2R);
    Num10P0IRL100Rz_P1R = intersect(Num10P0IRL_P1R,Num100Rz_P1R);
    Num12iP0IRL100Rz_P1R = intersect(Num12iP0IRL_P1R,Num100Rz_P1R);
    Num12RP0IRL100Rz_P2R = intersect(Num12RP0IRL_P2R,Num100Rz_P2R);
    Num14P0IRL100Rz_P1R = intersect(Num14P0IRL_P1R,Num100Rz_P1R);

    Num8P0IRL150Rz_P2R = intersect(Num8P0IRL_P2R,Num150Rz_P2R);
    Num10P0IRL150Rz_P1R = intersect(Num10P0IRL_P1R,Num150Rz_P1R);
    Num12iP0IRL150Rz_P1R = intersect(Num12iP0IRL_P1R,Num150Rz_P1R);
    Num12RP0IRL150Rz_P2R = intersect(Num12RP0IRL_P2R,Num150Rz_P2R);
    Num14P0IRL150Rz_P1R = intersect(Num14P0IRL_P1R,Num150Rz_P1R);

    Num8P0IRL200Rz_P2R = intersect(Num8P0IRL_P2R,Num200Rz_P2R);
    Num10P0IRL200Rz_P1R = intersect(Num10P0IRL_P1R,Num200Rz_P1R);
    Num12iP0IRL200Rz_P1R = intersect(Num12iP0IRL_P1R,Num200Rz_P1R);
    Num12RP0IRL200Rz_P2R = intersect(Num12RP0IRL_P2R,Num200Rz_P2R);
    Num14P0IRL200Rz_P1R = intersect(Num14P0IRL_P1R,Num200Rz_P1R);

    Num8P0IRL250Rz_P2R = intersect(Num8P0IRL_P2R,Num250Rz_P2R);
    Num10P0IRL250Rz_P1R = intersect(Num10P0IRL_P1R,Num250Rz_P1R);
    Num12iP0IRL250Rz_P1R = intersect(Num12iP0IRL_P1R,Num250Rz_P1R);
    Num12RP0IRL250Rz_P2R = intersect(Num12RP0IRL_P2R,Num250Rz_P2R);
    Num14P0IRL250Rz_P1R = intersect(Num14P0IRL_P1R,Num250Rz_P1R);

    RL8P0IMax50R = max(abs(latTrainingData_P2R(Num8P0IRL50Rz_P2R,8)));
    RL10P0IMax50R = max(abs(latTrainingData_P1R(Num10P0IRL50Rz_P1R,8)));
    RL12iP0IMax50R = max(abs(latTrainingData_P1R(Num12iP0IRL50Rz_P1R,8)));
    RL12RP0IMax50R = max(abs(latTrainingData_P2R(Num12RP0IRL50Rz_P2R,8)));
    RL14P0IMax50R = max(abs(latTrainingData_P1R(Num14P0IRL50Rz_P1R,8)));

    RL8P0IMax100R = max(abs(latTrainingData_P2R(Num8P0IRL100Rz_P2R,8)));
    RL10P0IMax100R = max(abs(latTrainingData_P1R(Num10P0IRL100Rz_P1R,8)));
    RL12iP0IMax100R = max(abs(latTrainingData_P1R(Num12iP0IRL100Rz_P1R,8)));
    RL12RP0IMax100R = max(abs(latTrainingData_P2R(Num12RP0IRL100Rz_P2R,8)));
    RL14P0IMax100R = max(abs(latTrainingData_P1R(Num14P0IRL100Rz_P1R,8)));

    RL8P0IMax150R = max(abs(latTrainingData_P2R(Num8P0IRL150Rz_P2R,8)));
    RL10P0IMax150R = max(abs(latTrainingData_P1R(Num10P0IRL150Rz_P1R,8)));
    RL12iP0IMax150R = max(abs(latTrainingData_P1R(Num12iP0IRL150Rz_P1R,8)));
    RL12RP0IMax150R = max(abs(latTrainingData_P2R(Num12RP0IRL150Rz_P2R,8)));
    RL14P0IMax150R = max(abs(latTrainingData_P1R(Num14P0IRL150Rz_P1R,8)));

    RL8P0IMax200R = max(abs(latTrainingData_P2R(Num8P0IRL200Rz_P2R,8)));
    RL10P0IMax200R = max(abs(latTrainingData_P1R(Num10P0IRL200Rz_P1R,8)));
    RL12iP0IMax200R = max(abs(latTrainingData_P1R(Num12iP0IRL200Rz_P1R,8)));
    RL12RP0IMax200R = max(abs(latTrainingData_P2R(Num12RP0IRL200Rz_P2R,8)));
    RL14P0IMax200R = max(abs(latTrainingData_P1R(Num14P0IRL200Rz_P1R,8)));

    RL8P0IMax250R = max(abs(latTrainingData_P2R(Num8P0IRL250Rz_P2R,8)));
    RL10P0IMax250R = max(abs(latTrainingData_P1R(Num10P0IRL250Rz_P1R,8)));
    RL12iP0IMax250R = max(abs(latTrainingData_P1R(Num12iP0IRL250Rz_P1R,8)));
    RL12RP0IMax250R = max(abs(latTrainingData_P2R(Num12RP0IRL250Rz_P2R,8)));
    RL14P0IMax250R = max(abs(latTrainingData_P1R(Num14P0IRL250Rz_P1R,8)));

    % 2 deg Camber StratiRication
    Num8P2RIRL_P2R = intersect(Num8P2RI_P2R,NumRL_P2R);
    Num10P2RIRL_P1R = intersect(Num10P2RI_P1R,NumRL_P1R);
    Num12iP2RIRL_P1R = intersect(Num12P2RI_P1R,NumRL_P1R);
    Num12RP2RIRL_P2R = intersect(Num12P2RI_P2R,NumRL_P2R);
    Num14P2RIRL_P1R = intersect(Num14P2RI_P1R,NumRL_P1R);

    Num8P2RIRL50Rz_P2R = intersect(Num8P2RIRL_P2R,Num50Rz_P2R);
    Num10P2RIRL50Rz_P1R = intersect(Num10P2RIRL_P1R,Num50Rz_P1R);
    Num12iP2RIRL50Rz_P1R = intersect(Num12iP2RIRL_P1R,Num50Rz_P1R);
    Num12RP2RIRL50Rz_P2R = intersect(Num12RP2RIRL_P2R,Num50Rz_P2R);
    Num14P2RIRL50Rz_P1R = intersect(Num14P2RIRL_P1R,Num50Rz_P1R);

    Num8P2RIRL100Rz_P2R = intersect(Num8P2RIRL_P2R,Num100Rz_P2R);
    Num10P2RIRL100Rz_P1R = intersect(Num10P2RIRL_P1R,Num100Rz_P1R);
    Num12iP2RIRL100Rz_P1R = intersect(Num12iP2RIRL_P1R,Num100Rz_P1R);
    Num12RP2RIRL100Rz_P2R = intersect(Num12RP2RIRL_P2R,Num100Rz_P2R);
    Num14P2RIRL100Rz_P1R = intersect(Num14P2RIRL_P1R,Num100Rz_P1R);

    Num8P2RIRL150Rz_P2R = intersect(Num8P2RIRL_P2R,Num150Rz_P2R);
    Num10P2RIRL150Rz_P1R = intersect(Num10P2RIRL_P1R,Num150Rz_P1R);
    Num12iP2RIRL150Rz_P1R = intersect(Num12iP2RIRL_P1R,Num150Rz_P1R);
    Num12RP2RIRL150Rz_P2R = intersect(Num12RP2RIRL_P2R,Num150Rz_P2R);
    Num14P2RIRL150Rz_P1R = intersect(Num14P2RIRL_P1R,Num150Rz_P1R);

    Num8P2RIRL200Rz_P2R = intersect(Num8P2RIRL_P2R,Num200Rz_P2R);
    Num10P2RIRL200Rz_P1R = intersect(Num10P2RIRL_P1R,Num200Rz_P1R);
    Num12iP2RIRL200Rz_P1R = intersect(Num12iP2RIRL_P1R,Num200Rz_P1R);
    Num12RP2RIRL200Rz_P2R = intersect(Num12RP2RIRL_P2R,Num200Rz_P2R);
    Num14P2RIRL200Rz_P1R = intersect(Num14P2RIRL_P1R,Num200Rz_P1R);

    Num8P2RIRL250Rz_P2R = intersect(Num8P2RIRL_P2R,Num250Rz_P2R);
    Num10P2RIRL250Rz_P1R = intersect(Num10P2RIRL_P1R,Num250Rz_P1R);
    Num12iP2RIRL250Rz_P1R = intersect(Num12iP2RIRL_P1R,Num250Rz_P1R);
    Num12RP2RIRL250Rz_P2R = intersect(Num12RP2RIRL_P2R,Num250Rz_P2R);
    Num14P2RIRL250Rz_P1R = intersect(Num14P2RIRL_P1R,Num250Rz_P1R);

    RL8P2RIMax50R = max(abs(latTrainingData_P2R(Num8P2RIRL50Rz_P2R,8)));
    RL10P2RIMax50R = max(abs(latTrainingData_P1R(Num10P2RIRL50Rz_P1R,8)));
    RL12iP2RIMax50R = max(abs(latTrainingData_P1R(Num12iP2RIRL50Rz_P1R,8)));
    RL12RP2RIMax50R = max(abs(latTrainingData_P2R(Num12RP2RIRL50Rz_P2R,8)));
    RL14P2RIMax50R = max(abs(latTrainingData_P1R(Num14P2RIRL50Rz_P1R,8)));

    RL8P2RIMax100R = max(abs(latTrainingData_P2R(Num8P2RIRL100Rz_P2R,8)));
    RL10P2RIMax100R = max(abs(latTrainingData_P1R(Num10P2RIRL100Rz_P1R,8)));
    RL12iP2RIMax100R = max(abs(latTrainingData_P1R(Num12iP2RIRL100Rz_P1R,8)));
    RL12RP2RIMax100R = max(abs(latTrainingData_P2R(Num12RP2RIRL100Rz_P2R,8)));
    RL14P2RIMax100R = max(abs(latTrainingData_P1R(Num14P2RIRL100Rz_P1R,8)));

    RL8P2RIMax150R = max(abs(latTrainingData_P2R(Num8P2RIRL150Rz_P2R,8)));
    RL10P2RIMax150R = max(abs(latTrainingData_P1R(Num10P2RIRL150Rz_P1R,8)));
    RL12iP2RIMax150R = max(abs(latTrainingData_P1R(Num12iP2RIRL150Rz_P1R,8)));
    RL12RP2RIMax150R = max(abs(latTrainingData_P2R(Num12RP2RIRL150Rz_P2R,8)));
    RL14P2RIMax150R = max(abs(latTrainingData_P1R(Num14P2RIRL150Rz_P1R,8)));

    RL8P2RIMax200R = max(abs(latTrainingData_P2R(Num8P2RIRL200Rz_P2R,8)));
    RL10P2RIMax200R = max(abs(latTrainingData_P1R(Num10P2RIRL200Rz_P1R,8)));
    RL12iP2RIMax200R = max(abs(latTrainingData_P1R(Num12iP2RIRL200Rz_P1R,8)));
    RL12RP2RIMax200R = max(abs(latTrainingData_P2R(Num12RP2RIRL200Rz_P2R,8)));
    RL14P2RIMax200R = max(abs(latTrainingData_P1R(Num14P2RIRL200Rz_P1R,8)));

    RL8P2RIMax250R = max(abs(latTrainingData_P2R(Num8P2RIRL250Rz_P2R,8)));
    RL10P2RIMax250R = max(abs(latTrainingData_P1R(Num10P2RIRL250Rz_P1R,8)));
    RL12iP2RIMax250R = max(abs(latTrainingData_P1R(Num12iP2RIRL250Rz_P1R,8)));
    RL12RP2RIMax250R = max(abs(latTrainingData_P2R(Num12RP2RIRL250Rz_P2R,8)));
    RL14P2RIMax250R = max(abs(latTrainingData_P1R(Num14P2RIRL250Rz_P1R,8)));

    % 4 deg Camber Stratification
    Num8P4IRL_P2R = intersect(Num8P4I_P2R,NumRL_P2R);
    Num10P4IRL_P1R = intersect(Num10P4I_P1R,NumRL_P1R);
    Num12iP4IRL_P1R = intersect(Num12P4I_P1R,NumRL_P1R);
    Num12RP4IRL_P2R = intersect(Num12P4I_P2R,NumRL_P2R);
    Num14P4IRL_P1R = intersect(Num14P4I_P1R,NumRL_P1R);

    Num8P4IRL50Rz_P2R = intersect(Num8P4IRL_P2R,Num50Rz_P2R);
    Num10P4IRL50Rz_P1R = intersect(Num10P4IRL_P1R,Num50Rz_P1R);
    Num12iP4IRL50Rz_P1R = intersect(Num12iP4IRL_P1R,Num50Rz_P1R);
    Num12RP4IRL50Rz_P2R = intersect(Num12RP4IRL_P2R,Num50Rz_P2R);
    Num14P4IRL50Rz_P1R = intersect(Num14P4IRL_P1R,Num50Rz_P1R);

    Num8P4IRL100Rz_P2R = intersect(Num8P4IRL_P2R,Num100Rz_P2R);
    Num10P4IRL100Rz_P1R = intersect(Num10P4IRL_P1R,Num100Rz_P1R);
    Num12iP4IRL100Rz_P1R = intersect(Num12iP4IRL_P1R,Num100Rz_P1R);
    Num12RP4IRL100Rz_P2R = intersect(Num12RP4IRL_P2R,Num100Rz_P2R);
    Num14P4IRL100Rz_P1R = intersect(Num14P4IRL_P1R,Num100Rz_P1R);

    Num8P4IRL150Rz_P2R = intersect(Num8P4IRL_P2R,Num150Rz_P2R);
    Num10P4IRL150Rz_P1R = intersect(Num10P4IRL_P1R,Num150Rz_P1R);
    Num12iP4IRL150Rz_P1R = intersect(Num12iP4IRL_P1R,Num150Rz_P1R);
    Num12RP4IRL150Rz_P2R = intersect(Num12RP4IRL_P2R,Num150Rz_P2R);
    Num14P4IRL150Rz_P1R = intersect(Num14P4IRL_P1R,Num150Rz_P1R);

    Num8P4IRL200Rz_P2R = intersect(Num8P4IRL_P2R,Num200Rz_P2R);
    Num10P4IRL200Rz_P1R = intersect(Num10P4IRL_P1R,Num200Rz_P1R);
    Num12iP4IRL200Rz_P1R = intersect(Num12iP4IRL_P1R,Num200Rz_P1R);
    Num12RP4IRL200Rz_P2R = intersect(Num12RP4IRL_P2R,Num200Rz_P2R);
    Num14P4IRL200Rz_P1R = intersect(Num14P4IRL_P1R,Num200Rz_P1R);

    Num8P4IRL250Rz_P2R = intersect(Num8P4I_P2R,Num250Rz_P2R);
    Num10P4IRL250Rz_P1R = intersect(Num10P4I_P1R,Num250Rz_P1R);
    Num12iP4IRL250Rz_P1R = intersect(Num12P4I_P1R,Num250Rz_P1R);
    Num12RP4IRL250Rz_P2R = intersect(Num12P4I_P2R,Num250Rz_P2R);
    Num14P4IRL250Rz_P1R = intersect(Num14P4I_P1R,Num250Rz_P1R);

    RL8P4IMax50R = max(abs(latTrainingData_P2R(Num8P4IRL50Rz_P2R,8)));
    RL10P4IMax50R = max(abs(latTrainingData_P1R(Num10P4IRL50Rz_P1R,8)));
    RL12iP4IMax50R = max(abs(latTrainingData_P1R(Num12iP4IRL50Rz_P1R,8)));
    RL12RP4IMax50R = max(abs(latTrainingData_P2R(Num12RP4IRL50Rz_P2R,8)));
    RL14P4IMax50R = max(abs(latTrainingData_P1R(Num14P4IRL50Rz_P1R,8)));

    RL8P4IMax100R = max(abs(latTrainingData_P2R(Num8P4IRL100Rz_P2R,8)));
    RL10P4IMax100R = max(abs(latTrainingData_P1R(Num10P4IRL100Rz_P1R,8)));
    RL12iP4IMax100R = max(abs(latTrainingData_P1R(Num12iP4IRL100Rz_P1R,8)));
    RL12RP4IMax100R = max(abs(latTrainingData_P2R(Num12RP4IRL100Rz_P2R,8)));
    RL14P4IMax100R = max(abs(latTrainingData_P1R(Num14P4IRL100Rz_P1R,8)));

    RL8P4IMax150R = max(abs(latTrainingData_P2R(Num8P4IRL150Rz_P2R,8)));
    RL10P4IMax150R = max(abs(latTrainingData_P1R(Num10P4IRL150Rz_P1R,8)));
    RL12iP4IMax150R = max(abs(latTrainingData_P1R(Num12iP4IRL150Rz_P1R,8)));
    RL12RP4IMax150R = max(abs(latTrainingData_P2R(Num12RP4IRL150Rz_P2R,8)));
    RL14P4IMax150R = max(abs(latTrainingData_P1R(Num14P4IRL150Rz_P1R,8)));

    RL8P4IMax200R = max(abs(latTrainingData_P2R(Num8P4IRL200Rz_P2R,8)));
    RL10P4IMax200R = max(abs(latTrainingData_P1R(Num10P4IRL200Rz_P1R,8)));
    RL12iP4IMax200R = max(abs(latTrainingData_P1R(Num12iP4IRL200Rz_P1R,8)));
    RL12RP4IMax200R = max(abs(latTrainingData_P2R(Num12RP4IRL200Rz_P2R,8)));
    RL14P4IMax200R = max(abs(latTrainingData_P1R(Num14P4IRL200Rz_P1R,8)));

    RL8P4IMax250R = max(abs(latTrainingData_P2R(Num8P4IRL250Rz_P2R,8)));
    RL10P4IMax250R = max(abs(latTrainingData_P1R(Num10P4IRL250Rz_P1R,8)));
    RL12iP4IMax250R = max(abs(latTrainingData_P1R(Num12iP4IRL250Rz_P1R,8)));
    RL12RP4IMax250R = max(abs(latTrainingData_P2R(Num12RP4IRL250Rz_P2R,8)));
    RL14P4IMax250R = max(abs(latTrainingData_P1R(Num14P4IRL250Rz_P1R,8)));

    FzRange = [-50,-100,-150,-200,-250];

    % Spring Rate Sweeps

    RL8P0ISweepR = [RL8P0IMax50R,RL8P0IMax100R,RL8P0IMax150R,RL8P0IMax200R,RL8P0IMax250R];
    RL10P0ISweepR = [RL10P0IMax50R,RL10P0IMax100R,RL10P0IMax150R,RL10P0IMax200R,RL10P0IMax250R];
    RL12iP0ISweepR = [RL12iP0IMax50R,RL12iP0IMax100R,RL12iP0IMax150R,RL12iP0IMax200R,RL12iP0IMax250R];
    RL12RP0ISweepR = [RL12RP0IMax50R,RL12RP0IMax100R,RL12RP0IMax150R,RL12RP0IMax200R,RL12RP0IMax250R];
    RL14P0ISweepR = [RL14P0IMax50R,RL14P0IMax100R,RL14P0IMax150R,RL14P0IMax200R,RL14P0IMax250R];

    RL8P2RISweepR = [RL8P2RIMax50R,RL8P2RIMax100R,RL8P2RIMax150R,RL8P2RIMax200R,RL8P2RIMax250R];
    RL10P2RISweepR = [RL10P2RIMax50R,RL10P2RIMax100R,RL10P2RIMax150R,RL10P2RIMax200R,RL10P2RIMax250R];
    RL12iP2RISweepR = [RL12iP2RIMax50R,RL12iP2RIMax100R,RL12iP2RIMax150R,RL12iP2RIMax200R,RL12iP2RIMax250R];
    RL12RP2RISweepR = [RL12RP2RIMax50R,RL12RP2RIMax100R,RL12RP2RIMax150R,RL12RP2RIMax200R,RL12RP2RIMax250R];
    RL14P2RISweepR = [RL14P2RIMax50R,RL14P2RIMax100R,RL14P2RIMax150R,RL14P2RIMax200R,RL14P2RIMax250R];

    RL8P4ISweepR = [RL8P4IMax50R,RL8P4IMax100R,RL8P4IMax150R,RL8P4IMax200R,RL8P4IMax250R];
    RL10P4ISweepR = [RL10P4IMax50R,RL10P4IMax100R,RL10P4IMax150R,RL10P4IMax200R,RL10P4IMax250R];
    RL12iP4ISweepR = [RL12iP4IMax50R,RL12iP4IMax100R,RL12iP4IMax150R,RL12iP4IMax200R,RL12iP4IMax250R];
    RL12RP4ISweepR = [RL12RP4IMax50R,RL12RP4IMax100R,RL12RP4IMax150R,RL12RP4IMax200R,RL12RP4IMax250R];
    RL14P4ISweepR = [RL14P4IMax50R,RL14P4IMax100R,RL14P4IMax150R,RL14P4IMax200R,RL14P4IMax250R];

    poly8P0IR = polyfit(RL8P0ISweepR,FzRange,1);
    poly10P0IR = polyfit(RL10P0ISweepR,FzRange,1);
    poly12iP0IR = polyfit(RL12iP0ISweepR,FzRange,1);
    poly12RP0IR = polyfit(RL12RP0ISweepR,FzRange,1);
    poly14P0IR = polyfit(RL14P0ISweepR,FzRange,1);

    poly8P2RIR = polyfit(RL8P2RISweepR,FzRange,1);
    poly10P2RIR = polyfit(RL10P2RISweepR,FzRange,1);
    poly12iP2RIR = polyfit(RL12iP2RISweepR,FzRange,1);
    poly12RP2RIR = polyfit(RL12RP2RISweepR,FzRange,1);
    poly14P2RIR = polyfit(RL14P2RISweepR,FzRange,1);

    poly8P4IR = polyfit(RL8P4ISweepR,FzRange,1);
    poly10P4IR = polyfit(RL10P4ISweepR,FzRange,1);
    poly12iP4IR = polyfit(RL12iP4ISweepR,FzRange,1);
    poly12RP4IR = polyfit(RL12RP4ISweepR,FzRange,1);
    poly14P4IR = polyfit(RL14P4ISweepR,FzRange,1);

    polyfits0IR = [poly8P0IR(1,1); poly10P0IR(1,1); poly12iP0IR(1,1); poly12RP0IR(1,1); poly14P0IR(1,1)];

    polyfits2IR = [poly8P2RIR(1,1); poly10P2RIR(1,1); poly12iP2RIR(1,1); poly12RP2RIR(1,1); poly14P2RIR(1,1)];

    polyfits4IR = [poly8P4IR(1,1); poly10P4IR(1,1); poly12iP4IR(1,1); poly12RP4IR(1,1); poly14P4IR(1,1)];

    F_Tire_psi = vehicle.TirePressure(1,1);
    R_Tire_psi = vehicle.TirePressure(2,1);

    F_camber = vehicle.Camber(1,1);
    R_camber = vehicle.Camber(2,1);

    % Spring Rate Calculator
    if (F_Tire_psi == 8 && F_camber == 0)
        F_polyCalc = polyfits0IF(1,:);
    end

    if (F_Tire_psi == 10 && F_camber == 0)
        F_polyCalc = polyfits0IF(2,:);
    end

    if (F_Tire_psi == 12 && F_camber == 0)
        F_polyCalc = polyfits0IF(3,:);
    end

    if (F_Tire_psi == 14 && F_camber == 0)
        F_polyCalc = polyfits0IF(5,:);
    end

    if (F_Tire_psi == 8 && F_camber == 2)
        F_polyCalc = polyfits2IF(1,:);
    end

    if (F_Tire_psi == 10 && F_camber == 2)
        F_polyCalc = polyfits2IF(2,:);
    end

    if (F_Tire_psi == 12 && F_camber == 2)
        F_polyCalc = polyfits2IF(3,:);
    end

    if (F_Tire_psi == 14 && F_camber == 2)
        F_polyCalc = polyfits2IF(5,:);
    end

    if (F_Tire_psi == 8 && F_camber == 4)
        F_polyCalc = polyfits4IF(1,:);
    end

    if (F_Tire_psi == 10 && F_camber == 4)
        F_polyCalc = polyfits4IF(2,:);
    end

    if (F_Tire_psi == 12 && F_camber == 4)
        F_polyCalc = polyfits4IF(3,:);
    end

    if (F_Tire_psi == 14 && F_camber == 4)
        F_polyCalc = polyfits4IF(5,:);
    end

    % Rear Spring Rate Calculator
    if (R_Tire_psi == 8 && R_camber == 0)
        R_polyCalc = polyfits0IR(1,:);
    end

    if (R_Tire_psi == 10 && R_camber == 0)
        R_polyCalc = polyfits0IR(2,:);
    end

    if (R_Tire_psi == 12 && R_camber == 0)
        R_polyCalc = polyfits0IR(3,:);
    end

    if (R_Tire_psi == 14 && R_camber == 0)
        R_polyCalc = polyfits0IR(5,:);
    end

    if (R_Tire_psi == 8 && R_camber == 2)
        R_polyCalc = polyfits2IR(1,:);
    end

    if (R_Tire_psi == 10 && R_camber == 2)
        R_polyCalc = polyfits2IR(2,:);
    end

    if (R_Tire_psi == 12 && R_camber == 2)
        R_polyCalc = polyfits2IR(3,:);
    end

    if (R_Tire_psi == 14 && R_camber == 2)
        R_polyCalc = polyfits2IR(5,:);
    end

    if (R_Tire_psi == 8 && R_camber == 4)
        R_polyCalc = polyfits4IR(1,:);
    end

    if (R_Tire_psi == 10 && R_camber == 4)
        F_polyCalc = polyfits4IR(2,:);
    end

    if (R_Tire_psi == 12 && R_camber == 4)
        F_polyCalc = polyfits4IR(3,:);
    end

    if (R_Tire_psi == 14 && R_camber == 4)
        R_polyCalc = polyfits4IR(5,:);
    end

    K_t = [F_polyCalc, F_polyCalc; R_polyCalc, R_polyCalc];
>>>>>>> main

end