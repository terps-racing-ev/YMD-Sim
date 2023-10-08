%% Lateral CoF Simulator

function [polyfits] = LateralCoFSim(latTrainingData_P1,latTrainingData_P2)

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

    % Lateral CoF (mu) vs. Normal Force (Fz) Max

    Num8P100Fz_P2 = intersect(Num8psi_P2,Num100Fz_P2);
    Num10P100Fz_P1 = intersect(Num10psi_P1,Num100Fz_P1);
    Num12iP100Fz_P1 = intersect(Num12psi_P1,Num100Fz_P1);
    Num12fP100Fz_P2 = intersect(Num12psi_P2,Num100Fz_P2);
    Num14P100Fz_P1 = intersect(Num14psi_P1,Num100Fz_P1);

    Num8P150Fz_P2 = intersect(Num8psi_P2,Num150Fz_P2);
    Num10P150Fz_P1 = intersect(Num10psi_P1,Num150Fz_P1);
    Num12iP150Fz_P1 = intersect(Num12psi_P1,Num150Fz_P1);
    Num12fP150Fz_P2 = intersect(Num12psi_P2,Num150Fz_P2);
    Num14P150Fz_P1 = intersect(Num14psi_P1,Num150Fz_P1);

    Num8P200Fz_P2 = intersect(Num8psi_P2,Num200Fz_P2);
    Num10P200Fz_P1 = intersect(Num10psi_P1,Num200Fz_P1);
    Num12iP200Fz_P1 = intersect(Num12psi_P1,Num200Fz_P1);
    Num12fP200Fz_P2 = intersect(Num12psi_P2,Num200Fz_P2);
    Num14P200Fz_P1 = intersect(Num14psi_P1,Num200Fz_P1);

    Num8P250Fz_P2 = intersect(Num8psi_P2,Num250Fz_P2);
    Num10P250Fz_P1 = intersect(Num10psi_P1,Num250Fz_P1);
    Num12iP250Fz_P1 = intersect(Num12psi_P1,Num250Fz_P1);
    Num12fP250Fz_P2 = intersect(Num12psi_P2,Num250Fz_P2);
    Num14P250Fz_P1 = intersect(Num14psi_P1,Num250Fz_P1);

    CoF8Max50 = max(abs(latTrainingData_P2(Num8psi_P2,6)));
    CoF10Max50 = max(abs(latTrainingData_P1(Num10psi_P1,6)));
    CoF12iMax50 = max(abs(latTrainingData_P1(Num12psi_P1,6)));
    CoF12fMax50 = max(abs(latTrainingData_P2(Num12psi_P2,6)));
    CoF14Max50 = max(abs(latTrainingData_P1(Num14psi_P1,6)));

    CoF8Max100 = max(abs(latTrainingData_P2(Num8P100Fz_P2,6)));
    CoF10Max100 = max(abs(latTrainingData_P1(Num10P100Fz_P1,6)));
    CoF12iMax100 = max(abs(latTrainingData_P1(Num12iP100Fz_P1,6)));
    CoF12fMax100 = max(abs(latTrainingData_P2(Num12fP100Fz_P2,6)));
    CoF14Max100 = max(abs(latTrainingData_P1(Num14P100Fz_P1,6)));

    CoF8Max150 = max(abs(latTrainingData_P2(Num8P150Fz_P2,6)));
    CoF10Max150 = max(abs(latTrainingData_P1(Num10P150Fz_P1,6)));
    CoF12iMax150 = max(abs(latTrainingData_P1(Num12iP150Fz_P1,6)));
    CoF12fMax150 = max(abs(latTrainingData_P2(Num12fP150Fz_P2,6)));
    CoF14Max150 = max(abs(latTrainingData_P1(Num14P150Fz_P1,6)));

    CoF8Max200 = max(abs(latTrainingData_P2(Num8P200Fz_P2,6)));
    CoF10Max200 = max(abs(latTrainingData_P1(Num10P200Fz_P1,6)));
    CoF12iMax200 = max(abs(latTrainingData_P1(Num12iP200Fz_P1,6)));
    CoF12fMax200 = max(abs(latTrainingData_P2(Num12fP200Fz_P2,6)));
    CoF14Max200 = max(abs(latTrainingData_P1(Num14P200Fz_P1,6)));

    CoF8Max250 = max(abs(latTrainingData_P2(Num8P250Fz_P2,6)));
    CoF10Max250 = max(abs(latTrainingData_P1(Num10P250Fz_P1,6)));
    CoF12iMax250 = max(abs(latTrainingData_P1(Num12iP250Fz_P1,6)));
    CoF12fMax250 = max(abs(latTrainingData_P2(Num12fP250Fz_P2,6)));
    CoF14Max250 = max(abs(latTrainingData_P1(Num14P250Fz_P1,6)));

    CoF8 = [CoF8Max50, CoF8Max100, CoF8Max150, CoF8Max200, CoF8Max250];
    CoF10 = [CoF10Max50, CoF10Max100, CoF10Max150, CoF10Max200, CoF10Max250];
    CoF12i = [CoF12iMax50, CoF12iMax100, CoF12iMax150, CoF12iMax200, CoF12iMax250];
    CoF12f = [CoF12fMax50, CoF12fMax100, CoF12fMax150, CoF12fMax200, CoF12fMax250];
    CoF14 = [CoF14Max50, CoF14Max100, CoF14Max150, CoF14Max200, CoF14Max250];

    FzRange = [-50, -100, -150, -200, -250];
    
    poly8 = polyfit(FzRange,CoF8,4);
    poly10 = polyfit(FzRange,CoF10,4);
    poly12i = polyfit(FzRange,CoF12i,4);
    poly12f = polyfit(FzRange,CoF12f,4);
    poly14 = polyfit(FzRange,CoF14,4);
    
    polyfits = [poly8; poly10; poly12i; poly12f; poly14];

end