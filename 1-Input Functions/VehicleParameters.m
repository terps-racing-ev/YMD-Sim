classdef VehicleParameters
    % This class holds general vehicle parameters that can be used
    % in various calculations and simulations

    %% Car Properties
    % Given
    properties (Constant)
        TotalWeight = 650;
        FrontPercent = 0.48;
        WheelBase = 61;
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
    end

    %% Aero Properties
    % Given
    properties (Constant)
        liftFactor = -6;
    end

    %% Alignment and Tuning
    % Given
    properties (Constant)
        K_s = [200 200; 250 250]; %lbf/in
        K_ARB = [0 0]; %lbf/in
        MR_s = [0.5 0.5; 0.5 0.5];
        MR_ARB = [0.5 0.5];
        Ackermann = -0.2223;
        frontToe = -0.5;
        rearToe = 0;
        frontCamber = 0;
        rearCamber = 0;
        frontTirePressure = 14;
        rearTirePressure = 14;
    end

    %% Functions

    methods
        % Car Getters:
        function value = get.RearPercent(obj)
            value = 1 - obj.FrontPercent;
        end
        function value = get.FrontAxleToCoG(obj)
            value = obj.WheelBase * obj.RearPercent;
        end
        function value = get.CoGToRearAxle(obj)
            value = obj.WheelBase * obj.FrontPercent;
        end
        function value = get.FrontStatic(obj)
            value = (obj.TotalWeight * obj.FrontPercent) / 2;
        end
        function value = get.RearStatic(obj)
            value = (obj.TotalWeight * obj.RearPercent) / 2;
        end

        % Function Methods:
        function output = staticWeights(obj)
            % Defining output
            output = [obj.FrontStatic, obj.FrontStatic; obj.RearStatic, obj.RearStatic];
        end
    end
end