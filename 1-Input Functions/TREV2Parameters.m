classdef TREV2Parameters
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
            value = obj.CoGhZrF+(((obj.CoGhZrR - obj.CoGhZrF)/obj.Wheelbase)*obj.FrontAxleToCoG) ;
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

        function output = RollCFL(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.1422 -0.1031 -0.0700 -0.0429 -0.0221 -0.0078 0 0.0010 -0.0048 -0.0177 -0.0379 -0.0654 -0.1004];
            
            % Checking if input value is in our array
            if ismember(x, X)
                i = X == x;
                output = Y(i);
            else
                % 4th order polynomial
                p = polyfit(X, Y, 4);
            
                % Constructing our function
                f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
                y = f(x);
                output = y;
            end  
        end
        function output = RollCFR(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.1004 -0.0654 -0.0379 -0.0177 -0.0048 0.0010 0 -0.0078 -0.0221 -0.0429 -0.0700 -0.1031 -0.1422];
            
            % Checking if input value is in our array
            if ismember(x, X)
                i = X == x;
                output = Y(i);
            else
                % 4th order polynomial
                p = polyfit(X, Y, 4);
            
                % Constructing our function
                f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
                y = f(x);
                output = y;
            end 
        end
        function output = RollCRL(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.2835  -0.2222  -0.1663  -0.1161  -0.0715  -0.0328   0.0000   0.0268   0.0475   0.0620   0.0702   0.0719   0.0672];
            
            % Checking if input value is in our array
            if ismember(x, X)
                i = X == x;
                output = Y(i);
            else
                % 4th order polynomial
                p = polyfit(X, Y, 4);
            
                % Constructing our function
                f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
                y = f(x);
                output = y;
            end
        end
        function output = RollCRR(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [0.0672 0.0719 0.0702 0.0620 0.0475 0.0268 0 -0.0328 -0.0715 -0.1161 -0.1663 -0.2222 -0.2835];
            
            % Checking if input value is in our array
            if ismember(x, X)
                i = X == x;
                output = Y(i);
            else
                % 4th order polynomial
                p = polyfit(X, Y, 4);
            
                % Constructing our function
                f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
                y = f(x);
                output = y;
            end 
        end
        function output = steerCamberLHS(~, x)
            % X and Y coordinates in matrix form 
            X = [TREV2Parameters.getProportion(-30) TREV2Parameters.getProportion(-25) TREV2Parameters.getProportion(-20) TREV2Parameters.getProportion(-15) TREV2Parameters.getProportion(-10) TREV2Parameters.getProportion(-5) TREV2Parameters.getProportion(0) TREV2Parameters.getProportion(5) TREV2Parameters.getProportion(10) TREV2Parameters.getProportion(15) TREV2Parameters.getProportion(20) TREV2Parameters.getProportion(25) TREV2Parameters.getProportion(30)];
            Y = [5.01 3.78 2.79 1.95 1.22 0.58 0 -0.54 -1.05 -1.54 -2.03 -2.54 -3.09];

            % Checking if input value is in our array
            if ismember(x, X)
                i = X == x;
                output = Y(i);
            else
                % 5th order polynomial
                p = polyfit(X, Y, 5);
            
                % Constructing our function
                f = @(x) p(1)*x.^5 + p(2)*x.^4 + p(3)*x.^3 + p(4)*x.^2 + p(5)*x + p(6);
            
                y = f(x);
                output = y;
            end 
        end
        function output = steerCamberRHS(~, x)
            % X and Y coordinates in matrix form 
            X = [TREV2Parameters.getProportion(-30) TREV2Parameters.getProportion(-25) TREV2Parameters.getProportion(-20) TREV2Parameters.getProportion(-15) TREV2Parameters.getProportion(-10) TREV2Parameters.getProportion(-5) TREV2Parameters.getProportion(0) TREV2Parameters.getProportion(5) TREV2Parameters.getProportion(10) TREV2Parameters.getProportion(15) TREV2Parameters.getProportion(20) TREV2Parameters.getProportion(25) TREV2Parameters.getProportion(30)];
            Y = [-3.09 -2.54 -2.03 -1.54 -1.05 -0.54 0 0.58 1.22 1.95 2.79 3.78 5.01];

            % Checking if input value is in our array
            if ismember(x, X)
                i = X == x;
                output = Y(i);
            else
                % 5th order polynomial
                p = polyfit(X, Y, 5);
            
                % Constructing our function
                f = @(x) p(1)*x.^5 + p(2)*x.^4 + p(3)*x.^3 + p(4)*x.^2 + p(5)*x + p(6);
            
                y = f(x);
                output = y;
            end 
        end
        function graphRolls(~)
            % Create a 3x2 grid of subplots
            subplot(3, 2, 1);
            TREV2Parameters.RollCFL_plot();
            title('Roll vs. Camber Front Left');

            subplot(3, 2, 2);
            TREV2Parameters.RollCFR_plot();
            title('Roll vs. Camber Front Right');
            
            subplot(3, 2, 3);
            TREV2Parameters.RollCRL_plot();
            title('Roll vs. Camber Rear Left');

            subplot(3, 2, 4);
            TREV2Parameters.RollCRR_plot();
            title('Roll vs. Camber Rear Right');

            subplot(3, 2, 5);
            TREV2Parameters.steerCamberLHS_plot();
            title("Steer vs. Camber LHS")

            subplot(3, 2, 6);
            TREV2Parameters.steerCamberRHS_plot();
            title("Steer vs. Camber RHS")
        end


        % Setting all points, look here for values
        function obj = TREV2Parameters()
            parameters = readtable('TREV2 Cookbook.xlsx','Sheet', 'Parameters','VariableNamingRule','preserve');
            points = readtable('TREV2 Cookbook.xlsx','Sheet', 'Geo Points','VariableNamingRule','preserve');

            
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
       
            obj.FinalDrive = parameters{30,3};

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


        
         end

    end

    
    methods (Static)

        function output = getProportion(x)
            output = ((x / 25.4) * 90) / (1.625);
        end

        function output = RollCFL_plot()
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.1422 -0.1031 -0.0700 -0.0429 -0.0221 -0.0078 0 0.0010 -0.0048 -0.0177 -0.0379 -0.0654 -0.1004];

            output = plot(X, Y);
        end

        function output = RollCFR_plot()
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.1004 -0.0654 -0.0379 -0.0177 -0.0048 0.0010 0 -0.0078 -0.0221 -0.0429 -0.0700 -0.1031 -0.1422];
            
            output = plot(X, Y);
        end

        function output = RollCRL_plot()
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.2835  -0.2222  -0.1663  -0.1161  -0.0715  -0.0328   0.0000   0.0268   0.0475   0.0620   0.0702   0.0719   0.0672];
            
            output = plot(X, Y);
        end

        function output = RollCRR_plot()
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [0.0672 0.0719 0.0702 0.0620 0.0475 0.0268 0 -0.0328 -0.0715 -0.1161 -0.1663 -0.2222 -0.2835];
            
            output = plot(X, Y);
        end

        function output = steerCamberLHS_plot()
            % X and Y coordinates in matrix form 
            % Added -90 and 90 for the graph - for visual completeness puproses 
            X = [-90 TREV2Parameters.getProportion(-30) TREV2Parameters.getProportion(-25) TREV2Parameters.getProportion(-20) TREV2Parameters.getProportion(-15) TREV2Parameters.getProportion(-10) TREV2Parameters.getProportion(-5) TREV2Parameters.getProportion(0) TREV2Parameters.getProportion(5) TREV2Parameters.getProportion(10) TREV2Parameters.getProportion(15) TREV2Parameters.getProportion(20) TREV2Parameters.getProportion(25) TREV2Parameters.getProportion(30) 90];
            Y = [9.0338 5.01 3.78 2.79 1.95 1.22 0.58 0 -0.54 -1.05 -1.54 -2.03 -2.54 -3.09 -4.7438];

            output = plot(X, Y);
        end

        function output = steerCamberRHS_plot()
            % X and Y coordinates in matrix form 
            % Added -90 and 90 for the graph - for visual completeness puproses 
            X = [-90 TREV2Parameters.getProportion(-30) TREV2Parameters.getProportion(-25) TREV2Parameters.getProportion(-20) TREV2Parameters.getProportion(-15) TREV2Parameters.getProportion(-10) TREV2Parameters.getProportion(-5) TREV2Parameters.getProportion(0) TREV2Parameters.getProportion(5) TREV2Parameters.getProportion(10) TREV2Parameters.getProportion(15) TREV2Parameters.getProportion(20) TREV2Parameters.getProportion(25) TREV2Parameters.getProportion(30) 90];
            Y = [-4.7438 -3.09 -2.54 -2.03 -1.54 -1.05 -0.54 0 0.58 1.22 1.95 2.79 3.78 5.01 9.0338];

            output = plot(X, Y);
        end

        
    end
end