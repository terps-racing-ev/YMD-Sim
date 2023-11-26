%% Motor Calculator 

%% Inputs
car = TREV2Parameters();
testTransmission = 1; 
motorSpeed = linspace(0, 7000, 15); % 0-7000
velocity = 1:15; 
pTorqueNM = [140 150 150 150 150 150 150 150 150 150 150 150 135 120 110];
cTorqueNM = [80 82 82 82 82 82 82 82 82 82 82 82 82 75 70];
peakT = 1:15; 
conT = 1:15;
axPT = 1:15; 
axCT = 1:15; 

disp(motorSpeed);
disp(car.FinalDrive);
disp(testTransmission);
disp(finaldr)


%% Car velocity 0-86.9mph
for i = 1:numel(motorSpeed)
velocity(i) = motorSpeed(i)/(car.FinalDrive * testTransmission) * ((2 * pi*(car.TireRadius/12))/60)*(1/(22/15));


end

%% ax due to peak torque 
for i = 1:numel(pTorqueNM)
peakT(i) = pTorqueNM(i) * 0.737562 * 12;

axPT(i) = (((peakT(i) * car.FinalDrive * testTransmission)/ car.TireRadius)/car.TotalWeight);
end

%% ax due to continuous torque 
for i = 1:numel(cTorqueNM)
conT(i) = cTorqueNM(i) * 0.737562 * 12; 
axCT(i) = (((conT(i) * car.FinalDrive * testTransmission)/car.TireRadius)/car.TotalWeight); 
end 




%% Plotting
disp(axCT);
disp(axPT);
disp(velocity);


figure;

plot(velocity, axPT, '-o', 'DisplayName', 'a_x due to Peak Acceleration');
hold on; 

plot(velocity, axCT, '-s', 'DisplayName', 'a_x due to Continuous Acceleration');
%add acceleration sweep
xlabel('Velocity (MPH)');
ylabel('Acceleration (Gs)');
title('Max Acceleration Possible Given Vehicle Speed');
legend('show');
hold off; 