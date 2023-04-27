classdef TREV1Parameters
    % This class holds general vehicle parameters that can be used
    % in various calculations and simulations

    %% Car Properties
    % Given
    properties (Constant)
        TotalWeight = 700;
        FrontPercent = 0.40;
        Wheelbase = 61;
        FrontTrackWidth = 48;
        RearTrackWidth = 48;
        CoGHeight = 9.84;
        TireRadius = 9;
        FrontAxleH = 9;
        RearAxleH = 9;
        RollAxisF = 1.5834;
        RollAxisR = 6.0487;
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
        liftFactor = -1.70355;
        Cd = 0; %???
        Af = 0; %???
    end

    %% Alignment and Tuning
    % Given
    properties (Constant)
        K_s = [400 400; 450 450]; %lbf/in
        K_ARB = [0; 0]; %lbf/in
        MR_s = [0.5 0.5; 0.5 0.5];
        MR_ARB = [0.5; 0.5];
        DampC_Low = [10 10; 10 10];
        DampC_High = [15 15; 15 15];
        Ackermann = -0.2223; % 1 = 100% Ackermann, -1 = 100% Anti-Ackermann, 0 = parallel)
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
            Y = [-1.8427 -1.5315 -1.2218 -0.9138 -0.6074 -0.3028 0 0.3008 0.5996 0.8963 1.1908 1.4830 1.7728];
            
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
            Y = [1.7728 1.4830 1.1908 0.8963 0.5996 0.3008 0 -0.3028 -0.6074 -0.9138 -1.2218 -1.5315 -1.8427];
            
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
            Y = [-1.1517  -0.9529  -0.7566  -0.5631  -0.3723  -0.1846   0.0000   0.1813   0.3592   0.5336   0.0741   0.8708   1.0334];
            
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
            Y = [1.0334 0.8708 0.7041 0.5336 0.3592 0.1813 0 -0.1846 -0.3723 -0.5631 -0.7566 -0.9529 -1.1517];
            
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
            X = [TREV1Parameters.getProportion(-30) TREV1Parameters.getProportion(-25) TREV1Parameters.getProportion(-20) TREV1Parameters.getProportion(-15) TREV1Parameters.getProportion(-10) TREV1Parameters.getProportion(-5) TREV1Parameters.getProportion(0) TREV1Parameters.getProportion(5) TREV1Parameters.getProportion(10) TREV1Parameters.getProportion(15) TREV1Parameters.getProportion(20) TREV1Parameters.getProportion(25) TREV1Parameters.getProportion(30)];
            Y = [2.27 1.78 1.36 0.99 0.64 0.32 0 -0.32 -0.65 -1.01 -1.41 -1.89 -2.52];

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
            X = [TREV1Parameters.getProportion(-30) TREV1Parameters.getProportion(-25) TREV1Parameters.getProportion(-20) TREV1Parameters.getProportion(-15) TREV1Parameters.getProportion(-10) TREV1Parameters.getProportion(-5) TREV1Parameters.getProportion(0) TREV1Parameters.getProportion(5) TREV1Parameters.getProportion(10) TREV1Parameters.getProportion(15) TREV1Parameters.getProportion(20) TREV1Parameters.getProportion(25) TREV1Parameters.getProportion(30)];
            Y = [-2.52 -1.89 -1.41 -1.01 -0.65 -0.32 0 0.32 0.64 0.99 1.36 1.78 2.27];

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
            TREV1Parameters.RollCFL_plot();
            title('Roll vs. Camber Front Left');

            subplot(3, 2, 2);
            TREV1Parameters.RollCFR_plot();
            title('Roll vs. Camber Front Right');
            
            subplot(3, 2, 3);
            TREV1Parameters.RollCRL_plot();
            title('Roll vs. Camber Rear Left');

            subplot(3, 2, 4);
            TREV1Parameters.RollCRR_plot();
            title('Roll vs. Camber Rear Right');

            subplot(3, 2, 5);
            TREV1Parameters.steerCamberLHS_plot();
            title("Steer vs. Camber LHS")

            subplot(3, 2, 6);
            TREV1Parameters.steerCamberRHS_plot();
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
            X = [-90 TREV1Parameters.getProportion(-30) TREV1Parameters.getProportion(-25) TREV1Parameters.getProportion(-20) TREV1Parameters.getProportion(-15) TREV1Parameters.getProportion(-10) TREV1Parameters.getProportion(-5) TREV1Parameters.getProportion(0) TREV1Parameters.getProportion(5) TREV1Parameters.getProportion(10) TREV1Parameters.getProportion(15) TREV1Parameters.getProportion(20) TREV1Parameters.getProportion(25) TREV1Parameters.getProportion(30) 90];
            Y = [9.0338 5.01 3.78 2.79 1.95 1.22 0.58 0 -0.54 -1.05 -1.54 -2.03 -2.54 -3.09 -4.7438];

            output = plot(X, Y);
        end

        function output = steerCamberRHS_plot()
            % X and Y coordinates in matrix form 
            % Added -90 and 90 for the graph - for visual completeness puproses 
            X = [-90 TREV1Parameters.getProportion(-30) TREV1Parameters.getProportion(-25) TREV1Parameters.getProportion(-20) TREV1Parameters.getProportion(-15) TREV1Parameters.getProportion(-10) TREV1Parameters.getProportion(-5) TREV1Parameters.getProportion(0) TREV1Parameters.getProportion(5) TREV1Parameters.getProportion(10) TREV1Parameters.getProportion(15) TREV1Parameters.getProportion(20) TREV1Parameters.getProportion(25) TREV1Parameters.getProportion(30) 90];
            Y = [-4.7438 -3.09 -2.54 -2.03 -1.54 -1.05 -0.54 0 0.58 1.22 1.95 2.79 3.78 5.01 9.0338];

            output = plot(X, Y);
        end
       
    end
end