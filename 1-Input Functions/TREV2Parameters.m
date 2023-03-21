classdef TREV2Parameters
    % This class holds general vehicle parameters that can be used
    % in various calculations and simulations

    %% Car Properties
    % Given
    properties (Constant)
        TotalWeight = 650;
        FrontPercent = 0.48;
        Wheelbase = 61;
        FrontTrackWidth = 48;
        RearTrackWidth = 44;
        CoGHeight = 9.84;
        TireRadius = 8;
        FrontAxleH = 8;
        RearAxleH = 8;
        RollAxisF = 1.0159;
        RollAxisR = 4.4544;
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
        Cd = 0;
        Af = 0;
    end

    %% Alignment and Tuning
    % Given
    properties (Constant)
        K_s = [200 200; 250 250]; %lbf/in
        K_ARB = [0; 0]; %lbf/in
        MR_s = [1 1; 1 1];
        MR_ARB = [0.5; 0.5];
        Ackermann = -0.12655; % 1 = 100% Ackermann, -1 = 100% Anti-Ackermann, 0 = parallel)
        Toe = [-0.5, -0.5; 0, 0];
        Camber = [0, 0; 0, 0];
        TirePressure = [14, 14; 14, 14];
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
            Y = [-0.1422 -0.1031 -0.0700 -0.0429 -0.0221 -0.0078 0 0.0010 -0.0048 -0.0177 -0.0379 -0.0654 -0.1004];
            
            % 4th order polynomial
            p = polyfit(X, Y, 4);
            
            % Constructing our function
            f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
            y = f(x);
            output = y;
        end
        function output = RollCFR(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.1004 -0.0654 -0.0379 -0.0177 -0.0048 0.0010 0 -0.0078 -0.0221 -0.0429 -0.0700 -0.1031 -0.1422];
            
            % 4th order polynomial
            p = polyfit(X, Y, 4);
            
            % Constructing our function
            f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
            y = f(x);
            output = y;
        end
        function output = RollCRL(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.2835  -0.2222  -0.1663  -0.1161  -0.0715  -0.0328   0.0000   0.0268   0.0475   0.0620   0.0702   0.0719   0.0672];
            
            % 4th order polynomial
            p = polyfit(X, Y, 4);
            
            % Constructing our function
            f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
            y = f(x);
            output = y;
        end
        function output = RollCRR(~, x)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [0.0672 0.0719 0.0702 0.0620 0.0475 0.0268 0 -0.0328 -0.0715 -0.1161 -0.1663 -0.2222 -0.2835];
            
            % 4th order polynomial
            p = polyfit(X, Y, 4);
            
            % Constructing our function
            f = @(x) p(1)*x.^4 + p(2)*x.^3 + p(3)*x.^2 + p(4)*x + p(5);
            
            y = f(x);
            output = y;
        end
        function graphRolls(~)
            % Create a 2x2 grid of subplots
            subplot(2, 2, 1);
            VehicleParameters.RollCFL_plot();
            title('Roll vs. Camber Front Left');

            subplot(2, 2, 2);
            VehicleParameters.RollCFR_plot();
            title('Roll vs. Camber Front Right');
            
            subplot(2, 2, 3);
            VehicleParameters.RollCRL_plot();
            title('Roll vs. Camber Rear Left');

            subplot(2, 2, 4);
            VehicleParameters.RollCRR_plot();
            title('Roll vs. Camber Rear Right');
        end

    end


    methods (Static)
        function output = RollCFL_plot(~)
            % X and Y coordinates in matrix form 
            X = [-3.00 -2.50 -2.00 -1.50 -1.00 -0.50 0 0.50 1.00 1.50 2.00 2.50 3.00];
            Y = [-0.1422 -0.1031 -0.0700 -0.0429 -0.0221 -0.0078 0 0.0010 -0.0048 -0.0177 -0.0379 -0.0654 -0.1004];

            output = plot(X, Y);
        end

        function output = RollCFR_plot(~)
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
    end
end