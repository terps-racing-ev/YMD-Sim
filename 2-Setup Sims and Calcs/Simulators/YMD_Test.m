%% YMD Test
% Credit - LJ Hamilton, Yash Goswami

close all
clearvars
clc

%% Adding Paths

% Adding Vehicle Parameters
currentFolder = pwd;
addpath([currentFolder, filesep, '1-Input Functions']);

% Adding Tire Models
addpath([currentFolder, filesep, '1-Input Functions', filesep, 'Tire Modeling']);

% Adding Additional Calculators
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Calculators']);

% Adding Additional Similators
addpath([currentFolder, filesep, '2-Setup Sims and Calcs', filesep, 'Simulators']);

% Adding Reference Files
addpath([currentFolder, filesep, 'Reference Files\']);

vehicleObj = TREV2Parameters();

%% Tire Modeling

% Hoosier 18x7.5-10 R25B (8 in Rim)

% Input Front and Rear Tire Data
% Front
filename_P1F = 'A1654run24.mat';
[latTrainingData_P1F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P1F);

filename_P2F = 'A1654run25.mat';
[latTrainingData_P2F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P2F);

totDataF = cat(1,latTrainingData_P1F,latTrainingData_P2F);
trainDataF = totDataF;

% Rear

filename_P1R = 'A1654run24.mat';
[latTrainingData_P1R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P1R);

filename_P2R = 'A1654run25.mat';
[latTrainingData_P2R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P2R);

totDataR = cat(1,latTrainingData_P1R,latTrainingData_P2R);
trainDataR = totDataR;

% Front tires
disp([tire.IDF, ', Front Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainDataF);
[model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainDataF);
[model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainDataF);
%[model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainDataF);
toc(t1)

disp('Training completed')

% Rear tires
disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
t1 = tic;
[model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
[model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
[model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
%[model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
toc(t1)

disp('Training completed')

%% Tuned Car Parameters

% Tire Spring Rates (lbf/in)
[K_t] = SpringRateCalc(latTrainingData_P1F,latTrainingData_P2F,latTrainingData_P1R,latTrainingData_P2R,vehicleObj);

% Stiffnesses (lbf/in)
[K_w,K_r,K_roll] = StiffnessCalc(K_t,vehicleObj);

%% Motor Parameters

Max_Velocity = 70; % mph

%% Inputs

%number of iso lines
nSteer = 27;
nBeta = 13;

%cons vel chosen
ConstantVelocity = 23.86; % mph
VelocityInput = 0.1; % mph

%steering wheel angle array
SWAngle = linspace(-24,24,nSteer); % deg (pos->Right, neg->Left)
%slip angle array
BetaInput = linspace(-12,12,nBeta); % deg (pos->Right, neg->Left)
Radius = 329; % in (pos->Right, neg->Left)

converge = false;
YMD = zeros(nSteer,nBeta,2);

%% Calculations

% Constant Radius
%{
YMGradient = zeros(1,numel(SWAngle));
AccelGradient = zeros(1,numel(SWAngle));
 
for i = 1:numel(SWAngle)
    while(converge == false)
 
        if SWAngle(i) < 0
            RadiusInput = -Radius;
        else
            RadiusInput = Radius;
        end
        [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle(i),vehicleObj);
        [SlipAngles] = SlipAngleCalc(SteerAngles,BetaInput,VelocityInput,RadiusInput,vehicleObj);
 
        if max(max(abs(SlipAngles))) > 13 %max slip angle tested by TTC
            Accel = 0;
            if Accel == 0
                Accel(1,2) = 0;
           end
            YM = 0;
            break %no calculations for conditions outside of testing limits
        end

        Accelcalc = -((VelocityInput*17.6)^2/RadiusInput)/386.4; % g's
% 
        [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,VelocityInput,Accelcalc,vehicleObj);
 
        [IA] = CamberCalc(Z,Roll_Angle,SWAngle(i),vehicleObj);
 
        [Fx,Fy,Mz] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);
 
        [YM,Accel] = YMCalc(SteerAngles,Fx,Fy,Mz,vehicleObj);

        % [Calpha] = CstiffCalc(Fz,model.FyFront,model.FyRear,vehicleObj);
         %
         % MaxBeta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*(((VelocityInput*17.6)^2)/(Radius*386.4))));
         %
         % if SWAngle < 0
         %         MaxBeta = -MaxBeta;
         % else
         %         MaxBeta = MaxBeta;
         % end
 
        if (abs(Accelcalc - Accel(1,2))>(0.0001*abs(Accelcalc)))%             Vcalc = sqrt(abs((Accel(1,2)*386.4))*Radius)./17.6;%             VelocityInput = Vcalc;
        else
             converge = true;
        end
 
    end
 
    YMGradient(1,i) = YM;
    AccelGradient(1,i) = Accel(1,2);
 
    converge = false;
end
%}

 %Constant Velocity

%define a couple of parameters
YMGradient = zeros(numel(BetaInput),numel(SWAngle));
AccelGradient = zeros(numel(BetaInput),numel(SWAngle));
VeloGradient = zeros(numel(BetaInput),numel(SWAngle));
RadiusInput = 329;
Vcalc = 5;
yawrate = 0;
Accelprev = 0;
for i = 1:numel(SWAngle)
    for j = 1:numel(BetaInput)
        RadiusInput = 329;
        yawrate = 0;
        while(converge == false)

            if SWAngle(i) < 0
                %RadiusInput = -RadiusInput;
            else
                %RadiusInput = RadiusInput;
            end

            [SteerAngles,TurnRadius] = SteerAngleCalc(SWAngle(i),vehicleObj);

            [SlipAngles] = SlipAngleCalc(SteerAngles,BetaInput(j),ConstantVelocity,RadiusInput,vehicleObj, yawrate);

            if max(max(abs(SlipAngles))) > 13 %max slip angle tested by TTC
                Accel(1) = 0; Accel(2) = 0;
                YM = 0;
                break %no calculations for conditions outside of testing limits
            end

            Accelcalc = -(ConstantVelocity^2/RadiusInput)/386.4; % g's

            [Fz,LLT,LLT_D,R_g,Roll_Angle,Z] = LLTCalc(K_r,K_roll,ConstantVelocity,Accelcalc,vehicleObj);

            [IA] = CamberCalc(Z,Roll_Angle,SWAngle(i),vehicleObj);

            [Fx,Fy,Mz] = findTireFM(model,SlipAngles,IA,Fz,vehicleObj.TirePressure);

            [YM,Accel] = YMCalc(SteerAngles,Fx,Fy,Mz,vehicleObj);
            %SteerAngles
            %Accel

            % [Calpha] = CstiffCalc(Fz,model.FyFront,model.FyRear,vehicleObj);
            %
            % MaxBeta = atand(vehicleObj.CoGToRearAxle/Radius) - (((-2*vehicleObj.RearStatic)/sum(Calpha(2,:))*(((VelocityInput*17.6)^2)/(Radius*386.4))));
            %
            % if SWAngle < 0
            %         MaxBeta = -MaxBeta;
            % else
            %         MaxBeta = MaxBeta;
            % end

            Vcalc = sqrt(abs(Accel(2)*386.4*Radius))./17.6; %mph

            %replaced Accel prev > Accel or whatever w/ velocities, RPM 3/20/24
            if (abs(Accel(2) - Accelprev) > .005)
                RadiusInput = 17.6*ConstantVelocity^2/(386.4*Accel(2));
                yawrate = yawrate-0.001*(yawrate-sign(Accel(2))*sqrt(Accel(1).^2 + Accel(2).^2)/(ConstantVelocity*17.6));
                Accelprev = Accel(2);
            else
                converge = true;
            end

        end
        YMGradient(j,i) = YM;
        AccelGradient(j,i) = Accel(2);
        VeloGradient(j,i) = Vcalc;
        YMD(i,j,1) =  Accel(2); %there is an error here
        YMD(i,j,2) = YM;
        converge = false;
    end
end

%get a little bit of results yeah? RPM 6/25/24
%most of the following code will be taken from hamilton
clear YM
data.maxGRightUntrimmed = max(max(YMD(:,:,1)));
data.maxGLeftUntrimmed = min(min(YMD(:,:,1)));

%find rear lat g limits
    %find all the lowest magnitude yaw moments at each beta
for m = 1:nBeta
    mask = abs(YMD(:,m,2))'; %creates vector of absolute values at each beta
    val = min(mask(mask>0)); %find smallest nonzero yaw moment
    if val > 0
        index = find(abs(mask - val) < 0.001); %index of smallest nonzero yawrate
        data.maxGbyBeta(m) = YMD(index,m,1); %finds lat G at smallest nonzero yawrate
    else
    end    
end
data.maxGRightRear = max(data.maxGbyBeta); %max positive (to the right) lat G from rear
data.maxGLeftRear = min(data.maxGbyBeta); %max negative (to the left) lat G from rear
%check for oversteer
if abs(data.maxGRightRear - data.maxGRightUntrimmed) == 0 || abs(data.maxGLeftRear - data.maxGLeftUntrimmed) == 0
    disp('understeer') %because rear g = max g
    data.understeer = 1;
    %find all the lowest magnitude yaw moments at each steer angle
    for n = 1:(nSteer-1/2) %just gets YMD table above zero steer
        mask = abs(YMD(n,:,2))'; %creates vector of absolute values at each steer angle
        val = min(mask(mask>0)); %find smallest nonzero yaw moment
        if val > 0
            index = find(abs(mask - val) < 0.001); %index of smallest nonzero yaw moment
            data.maxGbySteer(n) = YMD(n,index,1); %finds lat G at smallest nonzero yaw moment
        else
        end
    end
    data.maxGRightFront = max(data.maxGbySteer); %max positive (to the right) lat G from rear
    data.maxGLeftFront = min(data.maxGbySteer); %max negative (to the left) lat G from rear
    data.balanceR = data.maxGRightRear/data.maxGRightFront; %US/OS factor (US if >1,OS if <1)
    data.balanceL = data.maxGLeftRear/data.maxGLeftFront; %US/OS factor (US if >1,OS if <1)
else
    disp('oversteer') %because front g = max g
    data.understeer = 0;
    data.maxGRightFront = data.maxGRightUntrimmed; %max positive (to the right) lat G from front
    data.maxGLeftFront = data.maxGLeftUntrimmed; %max negative (to the left) lat G from front
    data.balanceR = data.maxGRightRear/data.maxGRightFront; %US/OS factor (US if >1,OS if <1)
    data.balanceL = data.maxGLeftRear/data.maxGLeftFront;%US/OS factor (US if >1,OS if <1)
end

%calculate control at steer = 0, beta = 0
nMidRow = (nSteer+1)/2;
mMidCol = (nBeta+1)/2;
YM.zero = YMD(nMidRow,mMidCol,2); %yaw moment at steer = 0, beta = 0
YM.steerStep = YMD(nMidRow+1,mMidCol,2); %increase steer angle by one increment
data.control = (YM.steerStep - YM.zero)/(0.5*max(SWAngle)/(nSteer-1)); %yaw moment change (ft-lbf/deg steer angle)

%calculate stability at steer = 0, beta = 0
YM.betaStep = YMD(nMidRow,mMidCol+1,2); %increase beta by one increment
data.stability = (YM.betaStep - YM.zero)/(0.5*max(BetaInput)/(nBeta-1)); %yaw moment change (ft-lbf/deg Beta) neg = more stable

%calculate max yaw moment at turn-in
%find all the lowest magnitude yaw rates at each steer angle
for n = 1:nSteer
    mask = abs(YMD(n,:,1))'; %creates vector of absolute values at each steer angle
    val = min(mask(mask>0)); %find smallest nonzero lat g
    if val > 0
        index = find(abs(mask - val) < 0.0000001); %index of smallest nonzero lat g
        data.maxYMbySteer(n) = YMD(n,index,2); %finds yaw moment at smallest nonzero lat g
    else
    end
end

data.maxYMRight = max(data.maxYMbySteer); %max positive (to the right) Yaw moment (ft-lbf)
data.maxYMLeft = min(data.maxYMbySteer); %max negative (to the left) Yaw moment (ft-lbf)
%% Plot - YMD
%hamilton's way of plotting

patience = 1;
z = 1;
results = {'Variable','Front','Rear';
    'Mass(lbm)', vehicleObj.FrontStatic,vehicleObj.RearStatic;
    %'Downforce (lbf), ', Vout.downF(1), Vout.downF(2); don't have this yet
    'LLTD',LLT_D(1),LLT_D(2);
    'Kspring (lbf/in)',vehicleObj.K_s(1),vehicleObj.K_s(4);
    'Karb (lbf/in)',vehicleObj.K_ARB(1),vehicleObj.K_ARB(2);
    %'Frequency (Hz)',Vout.FreqF, Vout.FreqR; don't have this yet
    'Tire', tire.IDF(1:28),tire.IDR(1:28);
    'Static Toe (deg)',vehicleObj.Toe(1), vehicleObj.Toe(4);
    'Static Camber (deg)',vehicleObj.Camber(1),vehicleObj.Camber(4)
    'Tire Pressure (psi)',vehicleObj.TirePressure(1),vehicleObj.TirePressure(4)
    'RESULTS','Left','Right';
    'Max lateral G', data.maxGLeftFront,data.maxGRightFront;
    'Max turn-in (ft-lbf)',data.maxYMLeft,data.maxYMRight;
    'balance (OS<1<US)', data.balanceL, data.balanceR;
    'control/stability',data.control,data.stability};
fig(z) = uifigure('Name',['velocity = ',num2str(ConstantVelocity), ' mph,', ' Ackerman = ', num2str(vehicleObj.Ackermann), ', CG = ' num2str(100*(1-vehicleObj.FrontPercent)) ' % aft']);

t = uitable(fig(z),'Position', [25 20 500 420],'ColumnWidth',{128 166 166},'Data',results,'ColumnEditable',false);
%figure(z)
%subplot(2,2,z)
figure();
if patience == 0
    plot(YMD(:,:,1),(YMD(:,:,2)),'r.')
else
q = 1;
h = waitbar(q/((nSteer)*(nBeta)), 'Plotting...');
for m = 1:nBeta %Iso-slip
    for n = 1:nSteer-1
        q = q +1;
        waitbar(q/((nBeta)*(nSteer)), h, 'Plotting Iso-slip...');
        mask = logical(YMD(n,:,1));
        starts = strfind([false,mask],[0 1]);
        stops = strfind([mask,false],[1 0]);
        
            for j = starts:stops-1
                plot([YMD(n, j, 1) YMD(n, j+1, 1)], [YMD(n, j, 2) YMD(n, j+1, 2)], 'k')
            end
       
        hold on
    end 
end
close(h);

q = 1;
h = waitbar(q/((nBeta)*(nSteer)), 'Plotting...');
for n = 1:1:nSteer %Iso- Steer n = 1:10:nsteer if generating detailed graph
     for m = 1:nBeta-1
         q = q + 1;
        waitbar(q/((nBeta)*(nSteer)), h, 'Plotting Iso-steer...');
        mask = logical(YMD(:,m,1))'; %converts non-zero elements to "1"
        starts = strfind([false,mask],[0 1]); %finds index for 1st "1"
        stops = strfind([mask,false],[1 0]); %finds index for last "1"
        
            for j = starts:stops-1
            plot([YMD(j, m, 1) YMD(j+1, m, 1)], [YMD(j, m, 2) YMD(j+1, m, 2)], 'r') %k
            end
        
     end
end

close(h);
text(0.75*max(xlim),0.75*max(ylim), 'Iso-Slip', 'Color', 'r')
text(0.75*max(xlim),0.65*max(ylim), 'Iso-Steer', 'Color', 'k')
end
grid on
xlabel('Lateral Accel [g]')
ylabel('Yaw Moment [lbf-in]')
title(['TREV2: ' 'V = ' num2str(ConstantVelocity) ' mph, ' 'Ack = ' num2str(vehicleObj.Ackermann), ', CG = ' num2str(100*(1 - vehicleObj.FrontPercent)) ' % aft'])
if data.understeer == 1
txt1 = ['max lat g (L/R) = ' sprintf('%0.2f',data.maxGLeftFront) '/' sprintf('%0.2f',data.maxGRightFront) ' g' ' understeer limited'];
else
txt1 = ['max lat g (L/R) = ' sprintf('%0.2f',data.maxGLeftRear) '/' sprintf('%0.2f',data.maxGRightRear) ' g' ' oversteer limited'];
end
txt2 = ['max turn-in yaw moment(L/R) = ' sprintf('%0.0f',data.maxYMLeft) '/ ' sprintf('%0.0f',data.maxYMRight) ' ft-lbf'];
txt3 = ['control = ' sprintf('%0.0f',data.control) ' ft-lbf/deg steer angle, ' 'stability = ' sprintf('%0.0f',data.stability) ' ft-lbf/deg beta'];
txt4 = ['balance (L/R) = ' sprintf('%0.3f',data.balanceL) '/' sprintf('%0.3f',data.balanceR)];
txt5 = ['front: ' tire.IDF];
txt6 = ['rear: ' tire.IDR];
txt = {txt1,txt2,txt3,txt4,txt5,txt6};
subtitle(txt)
%old code, yash's way of plotting. was giving me trouble so i used
%hamiltons way of plotting instead -- rpm
% Constant Radius
% PlotData = [SWAngle; AccelGradient; YMGradient];
% 
% figure('Name','Plot - YMD');
% title('Yaw Moment Diagram');
% hold on
% xlabel('Acceleration (Gs)');
% hold on
% ylabel('Yaw Moment (lb-in)');
% hold on
% grid on
% 
% plot(AccelGradient,YMGradient,'r*');
% hold on


% Constant Velocity
%{
hold on
for j = 1:numel(BetaInput)
    plot(AccelGradient(j,:),YMGradient(j,:), 'k');
    hold on
    %PlotData = [SWAngle; AccelGradient(j,:); YMGradient(j,:); VeloGradient(j,:)];
end
for j = 1:numel(SWAngle)
    plot(AccelGradient(:,j),YMGradient(:,j),'r');
end

figure('Name','Plot - YMD');
title('Yaw Moment Diagram');
hold on
xlabel('Acceleration (Gs)');
hold on
ylabel('Yaw Moment (lb-in)');
hold on
grid on
plot(AccelGradient,YMGradient);
hold on
%}
% disp('Velocity: ');
% disp(Vcalc);
% disp('Radius: ');
% disp(Radius);
% disp('Steering Wheel Angle: ');
% disp(SWAngle);
% disp('Input Beta: ');
% disp(BetaInput);
% disp('Max Beta: ');
% disp(MaxBeta);
% disp('Roll Angle: ');
% disp(Roll_Angle);
% disp('Slip Angles: ');
% disp(SlipAngles);
% disp('Fx: ');
% disp(Fx);
% disp('Fy: ');
% disp(Fy);
% disp('Fz: ');
% disp(Fz);
% disp('Mz: ');
% disp(Mz);
% disp('Gs: ');
% disp(Accel);
% disp('Acceleration: ');
% disp(LatAccelG);
% disp('Yaw Moment: ');
% disp(YM);
% disp('Camber: ');
% disp(IA);
% disp('Wheel Displacement: ');
% disp(Z);
% disp('Tire Pressure: ');
% disp(vehicleObj.TirePressure);
% disp('----------------------');