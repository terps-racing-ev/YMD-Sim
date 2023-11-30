classdef TREV2ParametersV2
    % This class holds general vehicle parameters that can be used
    % in various calculations and simulations

    %% Car Parameters
    % Given

    properties 
        TotalWeight %lb
        FrontPercent 
        Wheelbase %in
        FrontTrackWidth %in
        RearTrackWidth %in
        CoGHeight %in
        TireRadius %in
        FrontAxleH %in
        RearAxleH %in
        RollAxisF %in
        RollAxisR %in
    end
    % Calculated
    properties (Dependent)
        RearPercent
        FrontAxleToCoG %in
        CoGToRearAxle %in
        FrontStatic %lb
        RearStatic %lb
        CoGhZrF %in
        CoGhZrR %in
        CoGhRA %in
    end
    
    %% Alignment and Tuning Parameters
    % Given
    properties 
        K_s   %lb/in
        K_ARB  %lb/in
        MR_s 
        MR_ARB 
        DampC_Low %((lb*s)/in)
        DampC_High %((lb*s)/in)
        Ackermann  % 1 = 100% Ackermann, -1 = 100% Anti-Ackermann, 0 = parallel)
        Toe 
        Camber  % positive = top of tires toward chassis (normally neg camber)
        TirePressure 
    end

    %% Braking Parameters
    % Given
    properties 
        FBrakePadArea %(in^2)
        FPistonDia %(in)
        FPadCoF
        FNumPistons
        FMasterCylBore %(in)
        FRotorDia %(in)
        RBrakePadArea %(in^2)
        RPistonDia %(in)
        RPadCoF
        RNumPistons
        RMasterCylBore %(in)
        RRotorDia %(in)
        BrakePedalRatio
        BrakeBias
        FPistonArea %(in^2)
        FMasterCylArea %(in^2)
        RPistonArea %(in^2)
        RMasterCylArea %(in^2)
    end

    %% Aero Parameters
    % Given
    %Set Cl & Cd = 0 for no aero calculations

    properties 
        Cl 
        Cd 
        Af  %in^2
        air_density %lb/in^3
        FrontAeroPercent
    end
    % Calculated
    properties (Dependent)
        RearAeroPercent
    end

    %% Powertrain Parameters
    % Given
    properties 
        FinalDrive
    end

    %% FR Suspension Points
 properties (SetAccess = private)  
        % Point 1: Lower wishbone front pivot
        p1F
        % Point 2: Lower wishbone rear pivot
        p2F
        % Point 3: Lower wishbone outer ball joint
        p3F
        % Point 5: Upper wishbone front pivot
        p5F
        % Point 6: Upper wishbone rear pivot
        p6F
        % Point 7: Upper wishbone outer ball joint
        p7F
        % Point 8: Push rod wishbone end
        p8F
        % Point 9: Push rod rocker end
        p9F
        % Point 11: Outer track rod ball joint
        p11F
        % Point 12: Inner track rod ball joint
        p12F
        % Point 16: Damper to body point
        p16F
        % Point 17: Damper to rocker point
        p17F
        % Point 18: Wheel spindle point
        p18F
        % Point 19: Wheel centre point
        p19F
        % Point 20: Rocker axis 1st point
        p20F
        % Point 21: Rocker axis 2nd point
        p21F
        % Point 99: Tyre Contact Patch, x,y,z
        p99F
 end

    %% RR Suspension Points
    properties (SetAccess = private)
        % Point 1: Lower wishbone front pivot
        p1R
        % Point 2: Lower wishbone rear pivot
        p2R
        % Point 3: Lower wishbone outer ball joint
        p3R
        % Point 5: Upper wishbone front pivot
        p5R
        % Point 6: Upper wishbone rear pivot
        p6R
        % Point 7: Upper wishbone outer ball joint
        p7R
        % Point 8: Push rod wishbone end
        p8R
        % Point 9: Push rod rocker end
        p9R
        % Point 11: Outer track rod ball joint
        p11R
        % Point 12: Inner track rod ball joint
        p12R
        % Point 16: Damper to body point
        p16R
        % Point 17: Damper to rocker point
        p17R
        % Point 18: Wheel spindle point
        p18R
        % Point 19: Wheel centre point
        p19R
        % Point 20: Rocker axis 1st point
        p20R
        % Point 21: Rocker axis 2nd point
        p21R
        % Point 99: Tyre Contact Patch, x,y,z
        p99R
end

   %% BRS Gain
    properties (SetAccess = private)
        % Bump
        % Front Camber Gain
        BCF
        % Rear Camber Gain
        BCR
        % Front Toe Gain
        BTF
        % Rear Toe Gain
        BTR

        % Roll
        % Front Camber Gain
        RCF
        % Rear Camber Gain
        RCR
        % Front Toe Gain
        RTF
        % Rear Toe Gain
        RTR

        % Steer
        % Front Camber Gain
        SCF
        % Rear Camber Gain
        SCR
        % Front Toe Gain
        STF
        % Rear Toe Gain
        STR
    end

    %% Functions

    methods
        % Car Getters:
        function value = get.RearPercent(obj)
            value = 1 - obj.FrontPercent;
        end
        function value = get.RearAeroPercent(obj)
            value = 1 - obj.FrontAeroPercent;
        end
        function value = get.FrontAxleToCoG(obj)
            value = obj.Wheelbase * obj.RearPercent;
        end
        function value = get.CoGToRearAxle(obj)
            value = obj.Wheelbase * obj.FrontPercent;
        end
        function value = get.FrontStatic(obj)
            value = (obj.TotalWeight * obj.FrontPercent) / 2;
        end
        function value = get.RearStatic(obj)
            value = (obj.TotalWeight * obj.RearPercent) / 2;
        end
        function value = get.CoGhZrF(obj)
            value = (obj.CoGHeight - obj.RollAxisF);
        end
        function value = get.CoGhZrR(obj)
            value = (obj.CoGHeight - obj.RollAxisR);
        end
        function value = get.CoGhRA(obj)
            value = obj.CoGhZrF+(((obj.CoGhZrR - obj.CoGhZrF)/obj.Wheelbase)*obj.FrontAxleToCoG);
        end

        % Function Methods:
        function output = staticWeights(obj)
            % Defining output
            output = -[obj.FrontStatic, obj.FrontStatic; obj.RearStatic, obj.RearStatic];
        end
        function output = TrackWidth(obj)
            % Defining output
            output = [obj.FrontTrackWidth; obj.RearTrackWidth];
        end
        function output = CoGhZr(obj)
            % Defining output
            output = [obj.CoGhZrF; obj.CoGhZrR];
        end
        function output = Zr(obj)
            % Defining output
            output = [obj.RollAxisF();obj.RollAxisR()];
        end

        % Setting all points, look here for values
        function obj = TREV2ParametersV2()
            
            [~, name, ext] = fileparts('TREV2 Cookbook V2.xlsx');
            tempTREV2Cookbook = fullfile('Reference Files/',['TREV2 Cookbook V2-MATLAB', ext]);
            copyfile('TREV2 Cookbook V2.xlsx', tempTREV2Cookbook);
            %data = readtable(tempTREV2Cookbook)

            parameters = readtable('TREV2 Cookbook V2-MATLAB','Sheet', 'Parameters','VariableNamingRule','preserve');
            points = readtable('TREV2 Cookbook V2-MATLAB','Sheet', 'Geo Points','VariableNamingRule','preserve');
            BRS = readtable('TREV2 Cookbook V2-MATLAB','Sheet', 'BRS Camber & Toe Gain','VariableNamingRule','preserve');

            
            obj.TotalWeight = parameters{1,2};
            obj.FrontPercent = parameters{2,2};
            obj.Wheelbase = parameters{3,2};
            obj.FrontTrackWidth = parameters{4,2};
            obj.RearTrackWidth = parameters{5,2};
            obj.CoGHeight = parameters{6,2};
            obj.TireRadius = parameters{7,2};
            obj.FrontAxleH = parameters{8,2};
            obj.RearAxleH = parameters{9,2};
            obj.RollAxisF = parameters{10,2};
            obj.RollAxisR = parameters{11,2};


            obj.Cl= parameters{22,2}; 
            obj.Cd = parameters{23,2};
            obj.Af = parameters{24,2};  %in^2
            obj.air_density = parameters{25,2}; %lb/in^3
            obj.FrontAeroPercent = parameters{26,2};
       
            obj.FinalDrive = parameters{30,2};

            obj.K_s = [parameters{1,6} parameters{1,6}; parameters{2,6} parameters{2,6}]; %lb/in
            obj.K_ARB = [parameters{3,6} ; parameters{4,6}]; %lb/in 
            obj.MR_s = [parameters{5,6} parameters{5,6}; parameters{6,6} parameters{6,6}];
            obj.MR_ARB = [parameters{7,6}; parameters{8,6}];
            obj.DampC_Low = [parameters{9,6} parameters{9,6}; parameters{10,6} parameters{10,6}];
            obj.DampC_High = [parameters{11,6} parameters{11,6}; parameters{12,6} parameters{12,6}];
            obj.Ackermann = parameters{13,6}; % 1 = 100% Ackermann, -1 = 100% Anti-Ackermann, 0 = parallel)
            obj.Toe = [parameters{14,6}, parameters{14,6}; parameters{15,6}, parameters{15,6}];
            obj.Camber = [parameters{16,6}, parameters{16,6}; parameters{17,6}, parameters{17,6}]; % positive = top of tires toward chassis (normally neg camber)
            obj.TirePressure = [parameters{18,6}, parameters{18,6}; parameters{19,6}, parameters{19,6}];


            obj.FBrakePadArea = parameters{22,6};  %(in^2)
            obj.FPistonDia = parameters{23,6};  %(in)
            obj.FPadCoF = parameters{24,6};
            obj.FNumPistons = parameters{25,6};
            obj.FMasterCylBore = parameters{26,6}; %(in)
            obj.FRotorDia = parameters{27,6}; %(in)
            obj.RBrakePadArea = parameters{28,6}; %(in^2)
            obj.RPistonDia = parameters{29,6}; %(in)
            obj.RPadCoF = parameters{30,6};
            obj.RNumPistons = parameters{31,6};
            obj.RMasterCylBore = parameters{32,6}; %(in)
            obj.RRotorDia = parameters{33,6}; %(in)
            obj.BrakePedalRatio = parameters{34,6};
            obj.BrakeBias = parameters{35,6};
            obj.FPistonArea = parameters{36,6}; %(in^2)
            obj.FMasterCylArea = parameters{37,6}; %(in^2)
            obj.RPistonArea = parameters{38,6}; %(in^2)
            obj.RMasterCylArea = parameters{39,6}; %(in^2)


            % Columns X, Y, and Z in inches
            columnX=5;
            columnY=6;
            columnZ=7;


            % FR Suspension Points:
            obj.p1F = [points{1,columnX} points{1,columnY} points{1,columnZ}];
            obj.p2F = [points{2,columnX} points{2,columnY} points{2,columnZ}];
            obj.p3F = [points{3,columnX} points{3,columnY} points{3,columnZ}];
            obj.p5F = [points{4,columnX} points{4,columnY} points{4,columnZ}];
            obj.p6F = [points{5,columnX} points{5,columnY} points{5,columnZ}];
            obj.p7F = [points{6,columnX} points{6,columnY} points{6,columnZ}];
            obj.p8F = [points{7,columnX} points{7,columnY} points{7,columnZ}];
            obj.p9F = [points{8,columnX} points{8,columnY} points{8,columnZ}];
            obj.p11F = [points{9,columnX} points{9,columnY} points{9,columnZ}];
            obj.p12F = [points{10,columnX} points{10,columnY} points{10,columnZ}];
            obj.p16F = [points{11,columnX} points{11,columnY} points{11,columnZ}];
            obj.p17F = [points{12,columnX} points{12,columnY} points{12,columnZ}];
            obj.p18F = [points{13,columnX} points{13,columnY} points{13,columnZ}];
            obj.p19F = [points{14,columnX} points{14,columnY} points{14,columnZ}];
            obj.p20F = [points{15,columnX} points{15,columnY} points{15,columnZ}];
            obj.p21F = [points{16,columnX} points{16,columnY} points{16,columnZ}];
            obj.p99F = [points{17,columnX} points{17,columnY} points{17,columnZ}];

            % RR Suspension Points
            obj.p1R = [points{19,columnX} points{19,columnY} points{19,columnZ}];
            obj.p2R = [points{20,columnX} points{20,columnY} points{20,columnZ}];
            obj.p3R = [points{21,columnX} points{21,columnY} points{21,columnZ}];
            obj.p5R = [points{22,columnX} points{22,columnY} points{22,columnZ}];
            obj.p6R = [points{23,columnX} points{23,columnY} points{23,columnZ}];
            obj.p7R = [points{24,columnX} points{24,columnY} points{24,columnZ}];
            obj.p8R = [points{25,columnX} points{25,columnY} points{25,columnZ}];
            obj.p9R = [points{26,columnX} points{26,columnY} points{26,columnZ}];
            obj.p11R = [points{27,columnX} points{27,columnY} points{27,columnZ}];
            obj.p12R = [points{28,columnX} points{28,columnY} points{28,columnZ}];
            obj.p16R = [points{29,columnX} points{29,columnY} points{29,columnZ}];
            obj.p17R = [points{30,columnX} points{30,columnY} points{30,columnZ}];
            obj.p18R = [points{31,columnX} points{31,columnY} points{31,columnZ}];
            obj.p19R = [points{32,columnX} points{32,columnY} points{32,columnZ}];
            obj.p20R = [points{33,columnX} points{33,columnY} points{33,columnZ}];
            obj.p21R = [points{34,columnX} points{34,columnY} points{34,columnZ}];
            obj.p99R = [points{35,columnX} points{35,columnY} points{35,columnZ}];

            
            % Columns Front and Rear
            columnFront=2;
            columnRear=3;

            % Bump Gain
            obj.BCF = [BRS{2,columnFront} BRS{3,columnFront} BRS{4,columnFront} BRS{5,columnFront}];
            obj.BCR = [BRS{2,columnRear} BRS{3,columnRear} BRS{4,columnRear} BRS{5,columnRear}];
            
            obj.BTF = [BRS{7,columnFront} BRS{8,columnFront} BRS{9,columnFront} BRS{10,columnFront}];
            obj.BTR = [BRS{7,columnRear} BRS{8,columnRear} BRS{9,columnRear} BRS{10,columnRear}];
            
            % Roll Gain
            obj.RCF = [BRS{14,columnFront} BRS{15,columnFront} BRS{16,columnFront} BRS{17,columnFront}];
            obj.RCR = [BRS{14,columnRear} BRS{15,columnRear} BRS{16,columnRear} BRS{17,columnRear}];
            
            obj.RTF = [BRS{19,columnFront} BRS{20,columnFront} BRS{21,columnFront} BRS{22,columnFront}];
            obj.RTR = [BRS{19,columnRear} BRS{20,columnRear} BRS{21,columnRear} BRS{22,columnRear}];
            
            % Steer Gain
            obj.SCF = [BRS{26,columnFront} BRS{27,columnFront} BRS{28,columnFront} BRS{29,columnFront}];
            obj.SCR = [BRS{26,columnRear} BRS{27,columnRear} BRS{28,columnRear} BRS{29,columnRear}];
            
            obj.STF = [BRS{31,columnFront} BRS{32,columnFront} BRS{33,columnFront} BRS{34,columnFront}];
            obj.STR = [BRS{31,columnRear} BRS{32,columnRear} BRS{33,columnRear} BRS{34,columnRear}];

        end
        
        % Bump Camber Gains
        function output = BumpC(obj,x)

            x = x.*25.4;

            % RHS
            % FR
            fFR = @(x) (obj.BCF(1,1)*x(1,2).^0) + (obj.BCF(1,2)*x(1,2).^1) + (obj.BCF(1,3)*x(1,2).^2) + (obj.BCF(1,4)*x(1,2).^3);
            yFR = fFR(x);

            % RR
            fRR = @(x) (obj.BCR(1,1)*x(2,2).^0) + (obj.BCR(1,2)*x(2,2).^1) + (obj.BCR(1,3)*x(2,2).^2) + (obj.BCR(1,4)*x(2,2).^3);
            yRR = fRR(x);

            % LHS
            % FL
            fFL = @(x) (obj.BCF(1,1)*x(1,1).^0) + (obj.BCF(1,2)*x(1,1).^1) + (obj.BCF(1,3)*x(1,1).^2) + (obj.BCF(1,4)*x(1,1).^3);
            yFL = fFL(x);

            % RL
            fRL = @(x) (obj.BCR(1,1)*x(2,1).^0) + (obj.BCR(1,2)*x(2,1).^1) + (obj.BCR(1,3)*x(2,1).^2) + (obj.BCR(1,4)*x(2,1).^3);
            yRL = fRL(x);

            output = [yFL, yFR; yRL, yRR];
        end

        % Roll Camber Gains
        function output = RollC(obj,x)
            
            x = -x;
            
            % RHS
            % FR
            fFR = @(x) (obj.RCF(1,1)*x.^0) + (obj.RCF(1,2)*x.^1) + (obj.RCF(1,3)*x.^2) + (obj.RCF(1,4)*x.^3);
            yFR = fFR(x);

            % RR
            fRR = @(x) (obj.RCR(1,1)*x.^0) + (obj.RCR(1,2)*x.^1) + (obj.RCR(1,3)*x.^2) + (obj.RCR(1,4)*x.^3);
            yRR = fRR(x);

            % LHS
            % FL
            fFL = @(x) (obj.RCF(1,1)*(-x).^0) + (obj.RCF(1,2)*(-x).^1) + (obj.RCF(1,3)*(-x).^2) + (obj.RCF(1,4)*(-x).^3);
            yFL = fFL(x);

            % RL
            fRL = @(x) (obj.RCR(1,1)*(-x).^0) + (obj.RCR(1,2)*(-x).^1) + (obj.RCR(1,3)*(-x).^2) + (obj.RCR(1,4)*(-x).^3);
            yRL = fRL(x);

            output = [yFL, yFR; yRL, yRR];
        end

        % Steer Camber Gains
        function output = SteerC(obj,x)

            x = (-x*2)*(1.625/248)*25.4;

            % RHS
            % FR
            fFR = @(x) (obj.SCF(1,1)*x.^0) + (obj.SCF(1,2)*x.^1) + (obj.SCF(1,3)*x.^2) + (obj.SCF(1,4)*x.^3);
            yFR = fFR(x);

            % RR
            fRR = @(x) (obj.SCR(1,1)*x.^0) + (obj.SCR(1,2)*x.^1) + (obj.SCR(1,3)*x.^2) + (obj.SCR(1,4)*x.^3);
            yRR = fRR(x);

            % LHS
            % FL
            fFL = @(x) (obj.SCF(1,1)*(-x).^0) + (obj.SCF(1,2)*(-x).^1) + (obj.SCF(1,3)*(-x).^2) + (obj.SCF(1,4)*(-x).^3);
            yFL = fFL(x);

            % RL
            fRL = @(x) (obj.SCR(1,1)*(-x).^0) + (obj.SCR(1,2)*(-x).^1) + (obj.SCR(1,3)*(-x).^2) + (obj.SCR(1,4)*(-x).^3);
            yRL = fRL(x);

            output = [yFL, yFR; yRL, yRR];
        end
            
    end

end