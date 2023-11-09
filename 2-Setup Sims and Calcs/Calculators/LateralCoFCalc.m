%% Lateral CoF Calculator


function [F_polyCalc,R_polyCalc] = LateralCoFCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicle)

    %% Fronts
    % "Traditional" Plots - Data Stratification (Front)
    
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
    
   % Lateral CoF (mu) vs. Normal Force (Fz) Max

    Num8P100Fz_P2F = intersect(Num8psi_P2F,Num100Fz_P2F);
    Num10P100Fz_P1F = intersect(Num10psi_P1F,Num100Fz_P1F);
    Num12iP100Fz_P1F = intersect(Num12psi_P1F,Num100Fz_P1F);
    Num12fP100Fz_P2F = intersect(Num12psi_P2F,Num100Fz_P2F);
    Num14P100Fz_P1F = intersect(Num14psi_P1F,Num100Fz_P1F);

    Num8P150Fz_P2F = intersect(Num8psi_P2F,Num150Fz_P2F);
    Num10P150Fz_P1F = intersect(Num10psi_P1F,Num150Fz_P1F);
    Num12iP150Fz_P1F = intersect(Num12psi_P1F,Num150Fz_P1F);
    Num12fP150Fz_P2F = intersect(Num12psi_P2F,Num150Fz_P2F);
    Num14P150Fz_P1F = intersect(Num14psi_P1F,Num150Fz_P1F);

    Num8P200Fz_P2F = intersect(Num8psi_P2F,Num200Fz_P2F);
    Num10P200Fz_P1F = intersect(Num10psi_P1F,Num200Fz_P1F);
    Num12iP200Fz_P1F = intersect(Num12psi_P1F,Num200Fz_P1F);
    Num12fP200Fz_P2F = intersect(Num12psi_P2F,Num200Fz_P2F);
    Num14P200Fz_P1F = intersect(Num14psi_P1F,Num200Fz_P1F);

    Num8P250Fz_P2F = intersect(Num8psi_P2F,Num250Fz_P2F);
    Num10P250Fz_P1F = intersect(Num10psi_P1F,Num250Fz_P1F);
    Num12iP250Fz_P1F = intersect(Num12psi_P1F,Num250Fz_P1F);
    Num12fP250Fz_P2F = intersect(Num12psi_P2F,Num250Fz_P2F);
    Num14P250Fz_P1F = intersect(Num14psi_P1F,Num250Fz_P1F);

    CoF8Max50F = max(abs(latTrainingData_P2F(Num8psi_P2F,6)));
    CoF10Max50F = max(abs(latTrainingData_P1F(Num10psi_P1F,6)));
    CoF12iMax50F = max(abs(latTrainingData_P1F(Num12psi_P1F,6)));
    CoF12fMax50F = max(abs(latTrainingData_P2F(Num12psi_P2F,6)));
    CoF14Max50F = max(abs(latTrainingData_P1F(Num14psi_P1F,6)));

    CoF8Max100F = max(abs(latTrainingData_P2F(Num8P100Fz_P2F,6)));
    CoF10Max100F = max(abs(latTrainingData_P1F(Num10P100Fz_P1F,6)));
    CoF12iMax100F = max(abs(latTrainingData_P1F(Num12iP100Fz_P1F,6)));
    CoF12fMax100F = max(abs(latTrainingData_P2F(Num12fP100Fz_P2F,6)));
    CoF14Max100F = max(abs(latTrainingData_P1F(Num14P100Fz_P1F,6)));

    CoF8Max150F = max(abs(latTrainingData_P2F(Num8P150Fz_P2F,6)));
    CoF10Max150F = max(abs(latTrainingData_P1F(Num10P150Fz_P1F,6)));
    CoF12iMax150F = max(abs(latTrainingData_P1F(Num12iP150Fz_P1F,6)));
    CoF12fMax150F = max(abs(latTrainingData_P2F(Num12fP150Fz_P2F,6)));
    CoF14Max150F = max(abs(latTrainingData_P1F(Num14P150Fz_P1F,6)));

    CoF8Max200F = max(abs(latTrainingData_P2F(Num8P200Fz_P2F,6)));
    CoF10Max200F = max(abs(latTrainingData_P1F(Num10P200Fz_P1F,6)));
    CoF12iMax200F = max(abs(latTrainingData_P1F(Num12iP200Fz_P1F,6)));
    CoF12fMax200F = max(abs(latTrainingData_P2F(Num12fP200Fz_P2F,6)));
    CoF14Max200F = max(abs(latTrainingData_P1F(Num14P200Fz_P1F,6)));

    CoF8Max250F = max(abs(latTrainingData_P2F(Num8P250Fz_P2F,6)));
    CoF10Max250F = max(abs(latTrainingData_P1F(Num10P250Fz_P1F,6)));
    CoF12iMax250F = max(abs(latTrainingData_P1F(Num12iP250Fz_P1F,6)));
    CoF12fMax250F = max(abs(latTrainingData_P2F(Num12fP250Fz_P2F,6)));
    CoF14Max250F = max(abs(latTrainingData_P1F(Num14P250Fz_P1F,6)));

    CoF8F = [CoF8Max50F, CoF8Max100F, CoF8Max150F, CoF8Max200F, CoF8Max250F];
    CoF10F = [CoF10Max50F, CoF10Max100F, CoF10Max150F, CoF10Max200F, CoF10Max250F];
    CoF12iF = [CoF12iMax50F, CoF12iMax100F, CoF12iMax150F, CoF12iMax200F, CoF12iMax250F];
    CoF12fF = [CoF12fMax50F, CoF12fMax100F, CoF12fMax150F, CoF12fMax200F, CoF12fMax250F];
    CoF14F = [CoF14Max50F, CoF14Max100F, CoF14Max150F, CoF14Max200F, CoF14Max250F];

    FzRange = [-50, -100, -150, -200, -250];

    poly8F = polyfit(log(FzRange),CoF8F,1);
    poly10F = polyfit(log(FzRange),CoF10F,1);
    poly12iF = polyfit(log(FzRange),CoF12iF,1);
    poly12fF = polyfit(log(FzRange),CoF12fF,1);
    poly14F = polyfit(log(FzRange),CoF14F,1);
    
    polyfitsF = [poly8F; poly10F; poly12iF; poly12fF; poly14F];

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
    
    Num50Fz_P1R =  find(latTrainingData_P1R(:,3) > -75);
    Num100Fz_P1R =  find(latTrainingData_P1R(:,3) <= -75 & latTrainingData_P1R(:,3) > -125);
    Num150Fz_P1R =  find(latTrainingData_P1R(:,3) <= -125 & latTrainingData_P1R(:,3) > -175);
    Num200Fz_P1R =  find(latTrainingData_P1R(:,3) <= -175 & latTrainingData_P1R(:,3) > -225);
    Num250Fz_P1R = find(latTrainingData_P1R(:,3) <= -225);
    
    Num50Fz_P2R =  find(latTrainingData_P2R(:,3) > -75);
    Num100Fz_P2R =  find(latTrainingData_P2R(:,3) <= -75 & latTrainingData_P2R(:,3) > -125);
    Num150Fz_P2R =  find(latTrainingData_P2R(:,3) <= -125 & latTrainingData_P2R(:,3) > -175);
    Num200Fz_P2R =  find(latTrainingData_P2R(:,3) <= -175 & latTrainingData_P2R(:,3) > -225);
    Num250Fz_P2R = find(latTrainingData_P2R(:,3) <= -225);

    % Lateral CoF (mu) vs. Normal Force (Fz) Max

    Num8P100Fz_P2R = intersect(Num8psi_P2R,Num100Fz_P2R);
    Num10P100Fz_P1R = intersect(Num10psi_P1R,Num100Fz_P1R);
    Num12iP100Fz_P1R = intersect(Num12psi_P1R,Num100Fz_P1R);
    Num12fP100Fz_P2R = intersect(Num12psi_P2R,Num100Fz_P2R);
    Num14P100Fz_P1R = intersect(Num14psi_P1R,Num100Fz_P1R);

    Num8P150Fz_P2R = intersect(Num8psi_P2R,Num150Fz_P2R);
    Num10P150Fz_P1R = intersect(Num10psi_P1R,Num150Fz_P1R);
    Num12iP150Fz_P1R = intersect(Num12psi_P1R,Num150Fz_P1R);
    Num12fP150Fz_P2R = intersect(Num12psi_P2R,Num150Fz_P2R);
    Num14P150Fz_P1R = intersect(Num14psi_P1R,Num150Fz_P1R);

    Num8P200Fz_P2R = intersect(Num8psi_P2R,Num200Fz_P2R);
    Num10P200Fz_P1R = intersect(Num10psi_P1R,Num200Fz_P1R);
    Num12iP200Fz_P1R = intersect(Num12psi_P1R,Num200Fz_P1R);
    Num12fP200Fz_P2R = intersect(Num12psi_P2R,Num200Fz_P2R);
    Num14P200Fz_P1R = intersect(Num14psi_P1R,Num200Fz_P1R);

    Num8P250Fz_P2R = intersect(Num8psi_P2R,Num250Fz_P2R);
    Num10P250Fz_P1R = intersect(Num10psi_P1R,Num250Fz_P1R);
    Num12iP250Fz_P1R = intersect(Num12psi_P1R,Num250Fz_P1R);
    Num12fP250Fz_P2R = intersect(Num12psi_P2R,Num250Fz_P2R);
    Num14P250Fz_P1R = intersect(Num14psi_P1R,Num250Fz_P1R);

    CoF8Max50R = max(abs(latTrainingData_P2R(Num8psi_P2R,6)));
    CoF10Max50R = max(abs(latTrainingData_P1R(Num10psi_P1R,6)));
    CoF12iMax50R = max(abs(latTrainingData_P1R(Num12psi_P1R,6)));
    CoF12fMax50R = max(abs(latTrainingData_P2R(Num12psi_P2R,6)));
    CoF14Max50R = max(abs(latTrainingData_P1R(Num14psi_P1R,6)));

    CoF8Max100R = max(abs(latTrainingData_P2R(Num8P100Fz_P2R,6)));
    CoF10Max100R = max(abs(latTrainingData_P1R(Num10P100Fz_P1R,6)));
    CoF12iMax100R = max(abs(latTrainingData_P1R(Num12iP100Fz_P1R,6)));
    CoF12fMax100R = max(abs(latTrainingData_P2R(Num12fP100Fz_P2R,6)));
    CoF14Max100R = max(abs(latTrainingData_P1R(Num14P100Fz_P1R,6)));

    CoF8Max150R = max(abs(latTrainingData_P2R(Num8P150Fz_P2R,6)));
    CoF10Max150R = max(abs(latTrainingData_P1R(Num10P150Fz_P1R,6)));
    CoF12iMax150R = max(abs(latTrainingData_P1R(Num12iP150Fz_P1R,6)));
    CoF12fMax150R = max(abs(latTrainingData_P2R(Num12fP150Fz_P2R,6)));
    CoF14Max150R = max(abs(latTrainingData_P1R(Num14P150Fz_P1R,6)));

    CoF8Max200R = max(abs(latTrainingData_P2R(Num8P200Fz_P2R,6)));
    CoF10Max200R = max(abs(latTrainingData_P1R(Num10P200Fz_P1R,6)));
    CoF12iMax200R = max(abs(latTrainingData_P1R(Num12iP200Fz_P1R,6)));
    CoF12fMax200R = max(abs(latTrainingData_P2R(Num12fP200Fz_P2R,6)));
    CoF14Max200R = max(abs(latTrainingData_P1R(Num14P200Fz_P1R,6)));

    CoF8Max250R = max(abs(latTrainingData_P2R(Num8P250Fz_P2R,6)));
    CoF10Max250R = max(abs(latTrainingData_P1R(Num10P250Fz_P1R,6)));
    CoF12iMax250R = max(abs(latTrainingData_P1R(Num12iP250Fz_P1R,6)));
    CoF12fMax250R = max(abs(latTrainingData_P2R(Num12fP250Fz_P2R,6)));
    CoF14Max250R = max(abs(latTrainingData_P1R(Num14P250Fz_P1R,6)));

    CoF8R = [CoF8Max50R, CoF8Max100R, CoF8Max150R, CoF8Max200R, CoF8Max250R];
    CoF10R = [CoF10Max50R, CoF10Max100R, CoF10Max150R, CoF10Max200R, CoF10Max250R];
    CoF12iR = [CoF12iMax50R, CoF12iMax100R, CoF12iMax150R, CoF12iMax200R, CoF12iMax250R];
    CoF12fR = [CoF12fMax50R, CoF12fMax100R, CoF12fMax150R, CoF12fMax200R, CoF12fMax250R];
    CoF14R = [CoF14Max50R, CoF14Max100R, CoF14Max150R, CoF14Max200R, CoF14Max250R];

    FzRange = [-50, -100, -150, -200, -250];

    poly8R = polyfit(log(FzRange),CoF8R,1);
    poly10R = polyfit(log(FzRange),CoF10R,1);
    poly12iR = polyfit(log(FzRange),CoF12iR,1);
    poly12fR = polyfit(log(FzRange),CoF12fR,1);
    poly14R = polyfit(log(FzRange),CoF14R,1);
    
    polyfitsR = [poly8R; poly10R; poly12iR; poly12fR; poly14R];

    F_Tire_psi = vehicle.TirePressure(1,1);
    R_Tire_psi = vehicle.TirePressure(2,1);

    if (F_Tire_psi == 8)
        F_polyCalc = polyfitsF(1,:);
    end

    if (F_Tire_psi == 10)
        F_polyCalc = polyfitsF(2,:);
    end

    if (F_Tire_psi == 12)
        F_polyCalc = polyfitsF(3,:);
    end

    if (F_Tire_psi == 14)
        F_polyCalc = polyfitsF(5,:);
    end

    if (R_Tire_psi == 8)
        R_polyCalc = polyfitsR(1,:);
    end

    if (R_Tire_psi == 10)
        R_polyCalc = polyfitsR(2,:);
    end

    if (R_Tire_psi == 12)
        R_polyCalc = polyfitsR(3,:);
    end

    if (R_Tire_psi == 14)
        R_polyCalc = polyfitsR(5,:);
    end

end