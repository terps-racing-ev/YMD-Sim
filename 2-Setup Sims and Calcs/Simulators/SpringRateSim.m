%% Spring Rate Simulator

function [polyfits0I,polyfits2I,polyfits4I] = SpringRateSim(latTrainingData_P1,latTrainingData_P2)

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

end