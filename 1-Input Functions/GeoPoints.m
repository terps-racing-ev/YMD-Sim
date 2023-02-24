classdef GeoPoints
    % Helps create points in 3D space, generating unit vectors and lengths
    % of A-Arms and Control Arms

    %% Front Suspension Points
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

    %% Rear Suspension Points
    properties (SetAccess = private)
        % Finish This!
    end
    %% Methods

    methods
        % Setting all points, look here for values
        function obj = GeoPoints()
            % Front Suspension Points:
            obj.p1F = obj.generatePoint(-898.68, 188.1, 63.5);
            obj.p2F = obj.generatePoint(-573.654, 213.0934, 73.2599);
            obj.p3F = obj.generatePoint(-760.59, 570.43, 117.46);
            obj.p5F = obj.generatePoint(-909, 240.04, 175.94);
            obj.p6F = obj.generatePoint(-571.981, 243.9088, 160.3162);
            obj.p7F = obj.generatePoint(-740.35, 554.62, 291.63);
            obj.p8F = obj.generatePoint(-748.725, 520.9286, 269.0795);
            obj.p9F = obj.generatePoint(-738.288, 351.8476, 351.8476);
            obj.p11F = obj.generatePoint(-810.79, 564.67, 144.71);
            obj.p12F = obj.generatePoint(-812.36, 212.62, 84.48);
            obj.p16F = obj.generatePoint(-752.892, 276.446, 354.2944);
            obj.p17F = obj.generatePoint(-740.601, 277.4926, 174.3678);
            obj.p18F = obj.generatePoint(-743.71, 647.7, 207.01);
            obj.p19F = obj.generatePoint(-743.71, 609.6, 207.01);
            obj.p20F = obj.generatePoint(-728.819, 275.6476, 141.6539);
            obj.p21F = obj.generatePoint(-747.824, 275.6476, 139.2736);
            obj.p99F = obj.generatePoint(-743.71, 609.6, 3.81);

            % Rear Suspension Points
        end
        % Generates 3D points as a column vector and converts mm to in
        function output = generatePoint(~, x, y, z)
            output = [x/25.4 y/25.4 z/25.4];
        end
    end
end