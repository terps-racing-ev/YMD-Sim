classdef TREV2Parameters
    % This class holds general vehicle parameters that can be used
    % in various calculations and simulations

    %% Car Properties
    % Given
    properties (Constant)
        TotalWeight = 650;
        FrontPercent = 0.45;
        Wheelbase = 61;
        FrontTrackWidth = 48;
        RearTrackWidth = 44;
        CoGHeight = 9.84;
        TireRadius = 8;
        FrontAxleH = 8;
        RearAxleH = 8;
        RollAxisF = 0.9374;
        RollAxisR = 1.9547;
    end
    % Calculated
    properties (Dependent)
        RearPercent
        FrontAxleToCoG
        CoGToRearAxle
        FrontStatic
        RearStatic
        CoGhZrF
        CoGhZrR
        CoGhRA
    end

    %% Aero Properties
    % Given
    properties (Constant)
        liftFactor = -6;
        Cl = -1.88;
        Cd = 0.904;
        Af = 1019.902; %in^2
        air_density = 4.3e-5; %lb/in^3
        FrontAeroPercent = 0.25;
    end
    % Calculated
    properties (Dependent)
        RearAeroPercent
    end

    %% Alignment and Tuning
    % Given
    properties (Constant)
        K_s = [350 350; 400 400]; %lbf/in
        K_ARB = [0; 0]; %lbf/in
        MR_s = [0.8 0.8; 0.9 0.9];
        MR_ARB = [0.5; 0.5];
        DampC_Low = [12 12; 12 12];
        DampC_High = [12 12; 12 12];
        Ackermann = -0.12655; % 1 = 100% Ackermann, -1 = 100% Anti-Ackermann, 0 = parallel)
        Toe = [-0.5, -0.5; 0, 0];
        Camber = [0, 0; 0, 0];
        TirePressure = [12, 12; 12, 12];
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
            output = [obj.FrontStatic, obj.FrontStatic; obj.RearStatic, obj.RearStatic];
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