%% Fy Plot Generator - Loading Data
% Credit - LJ Hamilton
%{
everything in imperial units
torque -- ft*lbs


%}
close all
clear all
clc

filename_P1 = 'A2356run8.mat';
[latTrainingData_P1,tireID,testID] = createLatTrngData(filename_P1);

filename_P2 = 'A2356run9.mat';
[latTrainingData_P2,tireID,testID] = createLatTrngData(filename_P2);

totData = cat(1,latTrainingData_P1,latTrainingData_P2);
trainData = latTrainingData_P1;

%% Inputs

testF = -350; %Front Tire Fz (lb)
IA_F = 0; %Front Camber (deg)
P_F = 8; %Front Tire Pressure (psi)
testR = -400; %Rear Tire Fz (lb)
IA_R = 0; %Rear Camber (deg)
P_R = 8; %Front Tire Pressure (psi)

%% Plots to Understand Test - Input Plot

figure('Name','Input Plots');
tiledlayout(1,2)

nexttile
plot(latTrainingData_P1(:,1),'c') %slip angle, SA
hold on
plot(latTrainingData_P1(:,2),'r') %inclincation angle, IA
plot(latTrainingData_P1(:,3)/10,'g') %vertical load, Fz divided by 10 for scaling
plot(latTrainingData_P1(:,4),'k') %tire pressure.P
hold off
title('Tire input data');xlabel('sample #');ylabel('data values')
subtitle(tireID)
legend('slip angle (deg)','inclination angle (deg)','vertical load (lbf/10)','tire pressure (psi)','Location','southoutside')
axis([0 6e4 -30 20]);grid on

nexttile
plot(latTrainingData_P2(:,1),'c') %slip angle, SA
hold on
plot(latTrainingData_P2(:,2),'r') %inclincation angle, IA
plot(latTrainingData_P2(:,3)/10,'g') %vertical load, Fz divided by 10 for scaling
plot(latTrainingData_P2(:,4),'k') %tire pressure.P
hold off
title('Tire input data');xlabel('sample #');ylabel('data values')
subtitle(tireID)
legend('slip angle (deg)','inclination angle (deg)','vertical load (lbf/10)','tire pressure (psi)','Location','southoutside')
axis([0 6e4 -30 20]);grid on

%% Plots to Understand Test - Output Plot

figure('Name','Output Plots');
tiledlayout(1,2)

nexttile
plot(latTrainingData_P1(:,1),'c') %slip angle, SA
hold on
plot(latTrainingData_P1(:,5)/100,'r') %lateral force, Fy divided by 10
plot(10*latTrainingData_P1(:,6),'g') %lateral friction coefficient, muy
plot(latTrainingData_P1(:,7),'k') %aligning moment, Mz (lbf-ft)
hold off
legend('Slip angle (deg)','Lateral force,Fy (lbf/100)','Lateral friction coefficient, muy (*10)','Aligning torque, Mz (lbf-ft)','Location','southoutside')
title('Tire output data');xlabel('sample #');ylabel('data values')
subtitle(tireID)
axis([0 1278 -60 60]);grid on

nexttile
plot(latTrainingData_P2(:,1),'c') %slip angle, SA
hold on
plot(latTrainingData_P2(:,5)/100,'r') %lateral force, Fy divided by 10
plot(10*latTrainingData_P2(:,6),'g') %lateral friction coefficient, muy
plot(latTrainingData_P2(:,7),'k') %aligning moment, Mz (lbf-ft)
hold off
legend('Slip angle (deg)','Lateral force,Fy (lbf/100)','Lateral friction coefficient, muy (*10)','Aligning torque, Mz (lbf-ft)','Location','southoutside')
title('Tire output data');xlabel('sample #');ylabel('data values')
subtitle(tireID)
axis([0 1278 -60 60]);grid on

%% "Traditional" Plots - Data Stratification

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


%% Lateral CoF (mu) vs. Normal Force (Fz)
figure('Name','Lateral CoF vs. Normal Force');
tiledlayout(1,2)

nexttile
plot(latTrainingData_P1(Num8psi_P1,3),latTrainingData_P1(Num8psi_P1,6),'r-')
hold on
plot(latTrainingData_P1(Num10psi_P1,3),latTrainingData_P1(Num10psi_P1,6),'g-')
hold on
plot(latTrainingData_P1(Num12psi_P1,3),latTrainingData_P1(Num12psi_P1,6),'b-')
hold on
plot(latTrainingData_P1(Num14psi_P1,3),latTrainingData_P1(Num14psi_P1,6),'c-')
hold on
xlabel('Normal Force');
ylabel('Lateral CoF');
title('Lateral CoF vs. Normal Force');
subtitle(tireID)
legend('10 psi - g','12 psi - b','14 psi - c','Location','southoutside')

nexttile
plot(latTrainingData_P2(Num8psi_P2,3),latTrainingData_P2(Num8psi_P2,6),'r-')
hold on
plot(latTrainingData_P2(Num10psi_P2,3),latTrainingData_P2(Num10psi_P2,6),'g-')
hold on
plot(latTrainingData_P2(Num12psi_P2,3),latTrainingData_P2(Num12psi_P2,6),'b-')
hold on
plot(latTrainingData_P2(Num14psi_P2,3),latTrainingData_P2(Num14psi_P2,6),'c-')
hold on
xlabel('Normal Force');
ylabel('Lateral CoF');
title('Lateral CoF vs. Normal Force');
subtitle(tireID)
legend('8 psi - r','12 psi - b','Location','southoutside')

CoF8Max = max(abs(latTrainingData_P2(Num8psi_P2,6)))
CoF10Max = max(abs(latTrainingData_P1(Num10psi_P1,6)))
CoF12iMax = max(abs(latTrainingData_P1(Num12psi_P1,6)))
CoF12fMax = max(abs(latTrainingData_P2(Num12psi_P2,6)))
CoF14Max = max(abs(latTrainingData_P1(Num14psi_P1,6)))

Num8P250Fz_P2 = intersect(Num8psi_P2,Num250Fz_P2);
Num10P250Fz_P1 = intersect(Num10psi_P1,Num250Fz_P1);
Num12iP250Fz_P1 = intersect(Num12psi_P1,Num250Fz_P1);
Num12fP250Fz_P2 = intersect(Num12psi_P2,Num250Fz_P2);
Num14P250Fz_P1 = intersect(Num14psi_P1,Num250Fz_P1);

CoF8Min = max(abs(latTrainingData_P2(Num8P250Fz_P2,6)))
CoF10Min = max(abs(latTrainingData_P1(Num10P250Fz_P1,6)))
CoF12iMin = max(abs(latTrainingData_P1(Num12iP250Fz_P1,6)))
CoF12fMin = max(abs(latTrainingData_P2(Num12fP250Fz_P2,6)))
CoF14Min = max(abs(latTrainingData_P1(Num14P250Fz_P1,6)))

%% Bonus: Lateral CoF (mu) vs. Normal Force (Fz) Max

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

CoF8Max50 = max(abs(latTrainingData_P2(Num8psi_P2,6)))
CoF10Max50 = max(abs(latTrainingData_P1(Num10psi_P1,6)))
CoF12iMax50 = max(abs(latTrainingData_P1(Num12psi_P1,6)))
CoF12fMax50 = max(abs(latTrainingData_P2(Num12psi_P2,6)))
CoF14Max50 = max(abs(latTrainingData_P1(Num14psi_P1,6)))

CoF8Max100 = max(abs(latTrainingData_P2(Num8P100Fz_P2,6)))
CoF10Max100 = max(abs(latTrainingData_P1(Num10P100Fz_P1,6)))
CoF12iMax100 = max(abs(latTrainingData_P1(Num12iP100Fz_P1,6)))
CoF12fMax100 = max(abs(latTrainingData_P2(Num12fP100Fz_P2,6)))
CoF14Max100 = max(abs(latTrainingData_P1(Num14P100Fz_P1,6)))

CoF8Max150 = max(abs(latTrainingData_P2(Num8P150Fz_P2,6)))
CoF10Max150 = max(abs(latTrainingData_P1(Num10P150Fz_P1,6)))
CoF12iMax150 = max(abs(latTrainingData_P1(Num12iP150Fz_P1,6)))
CoF12fMax150 = max(abs(latTrainingData_P2(Num12fP150Fz_P2,6)))
CoF14Max150 = max(abs(latTrainingData_P1(Num14P150Fz_P1,6)))

CoF8Max200 = max(abs(latTrainingData_P2(Num8P200Fz_P2,6)))
CoF10Max200 = max(abs(latTrainingData_P1(Num10P200Fz_P1,6)))
CoF12iMax200 = max(abs(latTrainingData_P1(Num12iP200Fz_P1,6)))
CoF12fMax200 = max(abs(latTrainingData_P2(Num12fP200Fz_P2,6)))
CoF14Max200 = max(abs(latTrainingData_P1(Num14P200Fz_P1,6)))

CoF8Max250 = max(abs(latTrainingData_P2(Num8P250Fz_P2,6)))
CoF10Max250 = max(abs(latTrainingData_P1(Num10P250Fz_P1,6)))
CoF12iMax250 = max(abs(latTrainingData_P1(Num12iP250Fz_P1,6)))
CoF12fMax250 = max(abs(latTrainingData_P2(Num12fP250Fz_P2,6)))
CoF14Max250 = max(abs(latTrainingData_P1(Num14P250Fz_P1,6)))

%% Self-Aligning Torque (Mz) vs Lateral Force (Fy)

figure('Name','Self-Aligning Torque vs. Lateral Force');
tiledlayout(1,2)

nexttile
plot(latTrainingData_P1(Num8psi_P1,5),latTrainingData_P1(Num8psi_P1,7),'r-')
hold on
plot(latTrainingData_P1(Num10psi_P1,5),latTrainingData_P1(Num10psi_P1,7),'g-')
hold on
plot(latTrainingData_P1(Num12psi_P1,5),latTrainingData_P1(Num12psi_P1,7),'b-')
hold on
plot(latTrainingData_P1(Num14psi_P1,5),latTrainingData_P1(Num14psi_P1,7),'c-')
hold on
xlabel('Lateral Force');
ylabel('Self-Aligning Torque');
title('Self-Aligning Torque vs. Lateral Force');
subtitle(tireID)
legend('10 psi - g','12 psi - b','14 psi - c','Location','southoutside')

nexttile
plot(latTrainingData_P2(Num8psi_P2,5),latTrainingData_P2(Num8psi_P2,7),'r-')
hold on
plot(latTrainingData_P2(Num10psi_P2,5),latTrainingData_P2(Num10psi_P2,7),'g-')
hold on
plot(latTrainingData_P2(Num12psi_P2,5),latTrainingData_P2(Num12psi_P2,7),'b-')
hold on
plot(latTrainingData_P2(Num14psi_P2,5),latTrainingData_P2(Num14psi_P2,7),'c-')
hold on
xlabel('Lateral Force');
ylabel('Self-Aligning Torque');
title('Self-Aligning Torque vs. Lateral Force');
subtitle(tireID)
legend('8 psi - r','12 psi - b','Location','southoutside')

%% Lateral Force (Fy) vs. Slip Angle (SA): Camber (IA) - 0 deg
figure('Name','Lateral Force vs. Slip Angle');
tiledlayout(2,2)

nexttile
plot(latTrainingData_P1(Num8P0I_P1,1),latTrainingData_P1(Num8P0I_P1,5),'r.')
hold on
plot(latTrainingData_P2(Num8P0I_P2,1),latTrainingData_P2(Num8P0I_P2,5),'k.')
hold on
title('8 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

nexttile
plot(latTrainingData_P1(Num10P0I_P1,1),latTrainingData_P1(Num10P0I_P1,5),'k.')
hold on
plot(latTrainingData_P2(Num10P0I_P2,1),latTrainingData_P2(Num10P0I_P2,5),'r.')
hold on
title('10 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

nexttile
plot(latTrainingData_P1(Num12P0I_P1,1),latTrainingData_P1(Num12P0I_P1,5),'k.')
hold on
plot(latTrainingData_P2(Num12P0I_P2,1),latTrainingData_P2(Num12P0I_P2,5),'r.')
hold on
title('12 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
legend('Initial - k','Final - r','Location','southoutside')
xlim([-13 13])

nexttile
plot(latTrainingData_P1(Num14P0I_P1,1),latTrainingData_P1(Num14P0I_P1,5),'k.')
hold on
plot(latTrainingData_P2(Num14P0I_P2,1),latTrainingData_P2(Num14P0I_P2,5),'r.')
hold on
title('14 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

%% Lateral Force (Fy) vs. Slip Angle (SA): Camber (IA) - 0,2,4 deg
figure('Name','Lateral Force vs. Slip Angle: Camber - 0,2,4 deg');
tiledlayout(3,2)

nexttile
plot(latTrainingData_P2(Num8P0I_P2,1),latTrainingData_P2(Num8P0I_P2,5),'r-')
hold on
plot(latTrainingData_P2(Num8P2I_P2,1),latTrainingData_P2(Num8P2I_P2,5),'g-')
hold on
plot(latTrainingData_P2(Num8P4I_P2,1),latTrainingData_P2(Num8P4I_P2,5),'b-')
hold on
title('8 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

nexttile
plot(latTrainingData_P1(Num10P0I_P1,1),latTrainingData_P1(Num10P0I_P1,5),'r-')
hold on
plot(latTrainingData_P1(Num10P2I_P1,1),latTrainingData_P1(Num10P2I_P1,5),'g-')
hold on
plot(latTrainingData_P1(Num10P4I_P1,1),latTrainingData_P1(Num10P4I_P1,5),'b-')
hold on
title('10 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

nexttile
plot(latTrainingData_P1(Num12P0I_P1,1),latTrainingData_P1(Num12P0I_P1,5),'r-')
hold on
plot(latTrainingData_P1(Num12P2I_P1,1),latTrainingData_P1(Num12P2I_P1,5),'g-')
hold on
plot(latTrainingData_P1(Num12P4I_P1,1),latTrainingData_P1(Num12P4I_P1,5),'b-')
hold on
title('Initial: 12 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

nexttile
plot(latTrainingData_P2(Num12P0I_P2,1),latTrainingData_P2(Num12P0I_P2,5),'r-')
hold on
plot(latTrainingData_P2(Num12P2I_P2,1),latTrainingData_P2(Num12P2I_P2,5),'g-')
hold on
plot(latTrainingData_P2(Num12P4I_P2,1),latTrainingData_P2(Num12P4I_P2,5),'b-')
hold on
title('Final: 12 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
xlim([-13 13])

nexttile
plot(latTrainingData_P1(Num14P0I_P1,1),latTrainingData_P1(Num14P0I_P1,5),'r-')
hold on
plot(latTrainingData_P1(Num14P2I_P1,1),latTrainingData_P1(Num14P2I_P1,5),'g-')
hold on
plot(latTrainingData_P1(Num14P4I_P1,1),latTrainingData_P1(Num14P4I_P1,5),'b-')
hold on
title('14 psi');
subtitle(tireID)
xlabel('Slip Angle (deg)');
ylabel('Lateral Force (lb)');
legend('IA: 0 deg - r','IA: 2 deg - g','IA: 4 deg - b','Location','eastoutside')
xlim([-13 13])

%% Normal Force (Fz) vs. Loaded Radius (RL): Camber (IA) - 0,2,4 deg

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

figure('Name','Normal Force vs. Loaded Radius: Camber - 0,2,4 deg');
tiledlayout(1,5)

nexttile
plot(RL8P0ISweep,FzRange);
hold on
plot(RL8P2ISweep,FzRange);
plot(RL8P4ISweep,FzRange);
title('8 psi');

nexttile
plot(RL10P0ISweep,FzRange);
hold on
plot(RL10P2ISweep,FzRange);
plot(RL10P4ISweep,FzRange);
title('10 psi');

nexttile
plot(RL12iP0ISweep,FzRange);
hold on
plot(RL12iP2ISweep,FzRange);
plot(RL12iP4ISweep,FzRange);
title('12 psi - Initial');

nexttile
plot(RL12fP0ISweep,FzRange);
hold on
plot(RL12fP2ISweep,FzRange);
plot(RL12fP4ISweep,FzRange);
title('12 psi - Final');

nexttile
plot(RL14P0ISweep,FzRange);
hold on
plot(RL14P2ISweep,FzRange);
plot(RL14P4ISweep,FzRange);
title('14 psi');

%% Lateral Force (Fy) vs Slip Angle (SA) for Cornering Normal Load (Fz) - Front

%train Fy model
tic
    disp('Fy Model is being trained.  Standby...')
    [Model_Fy, validation.RMSE_Fy] = Trainer_Fy(trainData); %creates trained model and root mean square error to evaluate "fit"
    disp('Training completed')  
toc
% test the model to see if it works before moving on to plots
TestInputs = [-13,2,0,14]; %slip angle, inc angle, Fz, tire pressure
Test.Fy = Model_Fy.predictFcn(TestInputs) 

%create data for plot F
SA = [-13:1:13]'; %slip angle vector
UCV = ones(size(SA));%makes a unit column vector of the same length as the slip angle vector

FY50_F = Model_Fy.predictFcn([SA IA_F*UCV -50*UCV P_F*UCV]); %Fy at Fz = -50
FY100_F = Model_Fy.predictFcn([SA IA_F*UCV -100*UCV P_F*UCV]); %Fy at Fz = -100
FY150_F = Model_Fy.predictFcn([SA IA_F*UCV -150*UCV P_F*UCV]); %Fy at Fz = -150
FY200_F = Model_Fy.predictFcn([SA IA_F*UCV -200*UCV P_F*UCV]); %Fy at Fz = -200
FY250_F = Model_Fy.predictFcn([SA IA_F*UCV -250*UCV P_F*UCV]); %Fy at Fz = -250
FY_tF = Model_Fy.predictFcn([SA IA_F*UCV testF*UCV P_F*UCV]); %Fy at Fz = F_Fz

%create plot 1
plot(SA,FY50_F)
hold on
plot(SA,FY100_F,'r')
plot(SA,FY150_F,'g')
plot(SA,FY200_F,'c')
plot(SA,FY250_F,'k')
plot(SA,FY_tF,'m')
hold off
legend('FZ = 50 lb', 'Fz = 100 lb', 'Fz = 150 lb','Fz = 200 lb', 'Fz = 250 lb', 'Fz = test lb', 'Location','Best')
title(['Plot F: ' 'IA = ' num2str(IA_F) ' deg,' ' P = ' num2str(P_F) ' psi'])
subtitle(tireID)
xlabel('slip angle (deg)');ylabel('lateral force, Fy (lbf)')
grid on

%Calculate cornering stiffness at origin
%This finds greatest slope (ie inflection point at origin)
Calpha50_F = min(gradient(FY50_F)) %cornering stiffness for Fz = -50 lbf
Calpha100_F = min(gradient(FY100_F)) %cornering stiffness for Fz = -100 lbf
Calpha150_F = min(gradient(FY150_F)) %cornering stiffness for Fz = -150 lbf
Calpha200_F = min(gradient(FY200_F)) %cornering stiffness for Fz = -200 lbf
Calpha250_F = min(gradient(FY250_F)) %cornering stiffness for Fz = -250 lbf
Calpha_tF = min(gradient(FY_tF)) %cornering stiffness for Fz = Ftest lbf

%% Lateral Force (Fy) vs Slip Angle (SA) for Cornering Normal Load (Fz) - Rear

%train Fy model
tic
    disp('Fy Model is being trained.  Standby...')
    [Model_Fy, validation.RMSE_Fy] = Trainer_Fy(trainData); %creates trained model and root mean square error to evaluate "fit"
    disp('Training completed')  
toc
% test the model to see if it works before moving on to plots
TestInputs = [-13,2,0,10]; %slip angle, inc angle, Fz, tire pressure
Test.Fy = Model_Fy.predictFcn(TestInputs) 

%create data for plot R
SA = [-13:1:13]'; %slip angle vector
UCV = ones(size(SA));%makes a unit column vector of the same length as the slip angle vector

FY50_R = Model_Fy.predictFcn([SA IA_R*UCV -50*UCV P_R*UCV]); %Fy at Fz = -50
FY100_R = Model_Fy.predictFcn([SA IA_R*UCV -100*UCV P_R*UCV]); %Fy at Fz = -100
FY150_R = Model_Fy.predictFcn([SA IA_R*UCV -150*UCV P_R*UCV]); %Fy at Fz = -150
FY200_R = Model_Fy.predictFcn([SA IA_R*UCV -200*UCV P_R*UCV]); %Fy at Fz = -200
FY250_R = Model_Fy.predictFcn([SA IA_R*UCV -250*UCV P_R*UCV]); %Fy at Fz = -250
FY_tR = Model_Fy.predictFcn([SA IA_R*UCV testR*UCV P_R*UCV]); %Fy at Fz = F_Fz

%create plot R
nexttile
plot(SA,FY50_R)
hold on
plot(SA,FY100_R,'r')
plot(SA,FY150_R,'g')
plot(SA,FY200_R,'c')
plot(SA,FY250_R,'k')
plot(SA,FY_tR,'m')
hold off
legend('FZ = 50 lb', 'Fz = 100 lb', 'Fz = 150 lb','Fz = 200 lb', 'Fz = 250 lb', 'Fz = test lb', 'Location','Best')
title(['Plot R: ' 'IA = ' num2str(IA_R) ' deg,' ' P = ' num2str(P_R) ' psi'])
subtitle(tireID)
xlabel('slip angle (deg)');ylabel('lateral force, Fy (lbf)');
grid on

%Calculate cornering stiffness at origin
%This finds greatest slope (ie inflection point at origin)
Calpha50_R = min(gradient(FY50_R)) %cornering stiffness for Fz = -50 lbf
Calpha100_R = min(gradient(FY100_R)) %cornering stiffness for Fz = -100 lbf
Calpha150_R = min(gradient(FY150_R)) %cornering stiffness for Fz = -150 lbf
Calpha200_R = min(gradient(FY200_R)) %cornering stiffness for Fz = -200 lbf
Calpha250_R = min(gradient(FY250_R)) %cornering stiffness for Fz = -250 lbf
Calpha_tR = min(gradient(FY_tR)) %cornering stiffness for Fz = Ftest lbf

%% Effect of Inclination Angle (IA) on Lateral Force (Fy) for fixed Vertical Load (Fz) and Tire Pressure (P) - Front

%train Fy model
tic
    disp('Fy Model is being trained.  Standby...')
    [Model_Fy, validation.RMSE_Fy] = Trainer_Fy(trainData); %creates trained model and root mean square error to evaluate "fit"
    disp('Training completed')  
toc
% test the model to see if it works before moving on to plots
TestInputs = [-13,2,0,10]; %slip angle, inc angle, Fz, tire pressure
Test.Fy = Model_Fy.predictFcn(TestInputs) 

%create data for plot F
SA = [-13:1:13]'; %slip angle vector (deg)
UCV = ones(size(SA));%makes a unit column vector of the same length as the slip angle vector

FYIA0_F = Model_Fy.predictFcn([SA 0*UCV testF*UCV P_F*UCV]); %Fy for IA = 0 deg
FYIA2_F = Model_Fy.predictFcn([SA 2*UCV testF*UCV P_F*UCV]);
FYIA4_F = Model_Fy.predictFcn([SA 4*UCV testF*UCV P_F*UCV]);

%create plot F
clf
plot(SA,FYIA0_F)
hold on
plot(SA,FYIA2_F,'r')
plot(SA,FYIA4_F,'g')

legend('IA = 0 deg', 'IA = 2 deg', 'IA = 4 deg','Location','Best')
title(['Plot F: ' 'Fz = ' num2str(testF) ' lbf,' ' P = ' num2str(P_F) ' psi'])
subtitle(tireID)
xlabel('slip angle (deg)');ylabel('lateral force, Fy (lbf)')
hold off
grid on

%% Effect of Inclination Angle (IA) on Lateral Force (Fy) for fixed Vertical Load (Fz) and Tire Pressure (P) - Rear

%train Fy model
tic
    disp('Fy Model is being trained.  Standby...')
    [Model_Fy, validation.RMSE_Fy] = Trainer_Fy(trainData); %creates trained model and root mean square error to evaluate "fit"
    disp('Training completed')  
toc
% test the model to see if it works before moving on to plots
TestInputs = [-13,2,0,10]; %slip angle, inc angle, Fz, tire pressure
Test.Fy = Model_Fy.predictFcn(TestInputs) 

%create data for plot R
SA = [-13:1:13]'; %slip angle vector (deg)
UCV = ones(size(SA));%makes a unit column vector of the same length as the slip angle vector

FYIA0_R = Model_Fy.predictFcn([SA 0*UCV testR*UCV P_R*UCV]); %Fy for IA = 0 deg
FYIA2_R= Model_Fy.predictFcn([SA 2*UCV testR*UCV P_R*UCV]);
FYIA4_R = Model_Fy.predictFcn([SA 4*UCV testR*UCV P_R*UCV]);

%create plot R
clf
plot(SA,FYIA0_R)
hold on
plot(SA,FYIA2_R,'r')
plot(SA,FYIA4_R,'g')

legend('IA = 0 deg', 'IA = 2 deg', 'IA = 4 deg','Location','Best')
title(['Plot R: ' 'Fz = ' num2str(testR) ' lbf,' ' P = ' num2str(P_R) ' psi'])
subtitle(tireID)
xlabel('slip angle (deg)');ylabel('lateral force, Fy (lbf)')
hold off
grid on
