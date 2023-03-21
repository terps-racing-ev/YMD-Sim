classdef TREV1Parameters
    % This class holds general vehicle parameters that can be used
    % in various calculations and simulations

    %% Car Properties
    % Given
    properties (Constant)
        TotalWeight = 700;
        FrontPercent = 0.48;
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
        Cd = 0;
        Af = 0;
    end

    %% Alignment and Tuning
    % Given
    properties (Constant)
        K_s = [500 500; 550 550]; %lbf/in
        K_ARB = [0; 0]; %lbf/in
        MR_s = [0.5 0.5; 0.5 0.5];
        MR_ARB = [0.5; 0.5];
        Ackermann = -0.2223; % 1 = 100% Ackermann, -1 = 100% Anti-Ackermann, 0 = parallel)
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
        
    end
end