classdef GeoPoints
    % Helps create points in 3D space, generating unit vectors and lengths
    % of A-Arms and Control Arms

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

    %% Unit Vectors (FR, FL, RR, RL)
    properties (SetAccess = private)
        % FR
        U_TR_FR
        U_LAA_F_FR
        U_LAA_A_FR
        U_UAA_F_FR
        U_UAA_A_FR
        U_PR_FR
        % FL
        U_TR_FL
        U_LAA_F_FL
        U_LAA_A_FL
        U_UAA_F_FL
        U_UAA_A_FL
        U_PR_FL
        % RR
        U_TR_RR
        U_LAA_F_RR
        U_LAA_A_RR
        U_UAA_F_RR
        U_UAA_A_RR
        U_PR_RR
        % RL
        U_TR_RL
        U_LAA_F_RL
        U_LAA_A_RL
        U_UAA_F_RL
        U_UAA_A_RL
        U_PR_RL 
    end

    %% "Rs" (FL, FR, RL, RR)
    properties(SetAccess = private)
        % FR
        R_FR_TR
        R_FR_LAAF
        R_FR_LAAA
        R_FR_UAAF
        R_FR_UAAA
        R_FR_PR
        % FL
        R_FL_TR
        R_FL_LAAF
        R_FL_LAAA
        R_FL_UAAF
        R_FL_UAAA
        R_FL_PR
        % RR
        R_RR_TR
        R_RR_LAAF
        R_RR_LAAA
        R_RR_UAAF
        R_RR_UAAA
        R_RR_PR
        % RL
        R_RL_TR
        R_RL_LAAF
        R_RL_LAAA
        R_RL_UAAF
        R_RL_UAAA
        R_RL_PR
    end


    %% Moments (FL, FR, RL, RR)
    properties (SetAccess = private)
        % FR
        M1_FR_TR
        M1_FR_LAAF
        M1_FR_LAAA
        M1_FR_UAAF
        M1_FR_UAAA
        M1_FR_PR
        % FL
        M1_FL_TR
        M1_FL_LAAF
        M1_FL_LAAA
        M1_FL_UAAF
        M1_FL_UAAA
        M1_FL_PR
        % RR
        M1_RR_TR
        M1_RR_LAAF
        M1_RR_LAAA
        M1_RR_UAAF
        M1_RR_UAAA
        M1_RR_PR
        % RL
        M1_RL_TR
        M1_RL_LAAF
        M1_RL_LAAA
        M1_RL_UAAF
        M1_RL_UAAA
        M1_RL_PR
    end

    %% Methods

    methods
        % Setting all points, look here for values
        function obj = GeoPoints()
            % FR Suspension Points:
            obj.p1F = obj.generatePoint(-898.68, 188.1, 63.5);
            obj.p2F = obj.generatePoint(-573.654, 213.0934, 73.2599);
            obj.p3F = obj.generatePoint(-760.59, 570.43, 117.46);
            obj.p5F = obj.generatePoint(-909, 240.04, 175.94);
            obj.p6F = obj.generatePoint(-571.981, 243.9088, 160.3162);
            obj.p7F = obj.generatePoint(-740.35, 554.62, 291.63);
            obj.p8F = obj.generatePoint(-748.725, 520.9286, 269.0795);
            obj.p9F = obj.generatePoint(-738.288, 351.8476, 140.5161);
            obj.p11F = obj.generatePoint(-810.79, 564.67, 144.71);
            obj.p12F = obj.generatePoint(-812.36, 212.62, 84.48);
            obj.p16F = obj.generatePoint(-752.892, 276.446, 354.2944);
            obj.p17F = obj.generatePoint(-740.601, 277.4926, 174.3678);
            obj.p18F = obj.generatePoint(-743.71, 647.7, 207.01);
            obj.p19F = obj.generatePoint(-743.71, 609.6, 207.01);
            obj.p20F = obj.generatePoint(-728.819, 275.6476, 141.6539);
            obj.p21F = obj.generatePoint(-747.824, 275.6476, 139.2736);
            obj.p99F = obj.generatePoint(-743.71, 609.6, 3.81);

            % RR Suspension Points
            obj.p1R = obj.generatePoint(572.5599, 188.26, 102.4402);
            obj.p2R = obj.generatePoint(880.2599, 209.26, 72.1202);
            obj.p3R = obj.generatePoint(807.26, 522.1, 109.44);
            obj.p5R = obj.generatePoint(657.9677, 246.63, 193.3564);
            obj.p6R = obj.generatePoint(885.01, 246.63, 184.08);
            obj.p7R = obj.generatePoint(830.75, 503.79, 302.64);
            obj.p8R = obj.generatePoint(783.32, 520.85, 127.28);
            obj.p9R = obj.generatePoint(801.28, 338.38, 333.11);
            obj.p11R = obj.generatePoint(872.4299, 503.79, 300.15);
            obj.p12R = obj.generatePoint(938.01, 236.17, 179.9302);
            obj.p16R = obj.generatePoint(801.9, 91.24, 340.28);
            obj.p17R = obj.generatePoint(801.45, 262.2, 335.05);
            obj.p18R = obj.generatePoint(805.69, 596.9, 207.01);
            obj.p19R = obj.generatePoint(805.69, 558.8, 207.01);
            obj.p20R = obj.generatePoint(805.14, 260.45, 265.92);
            obj.p21R = obj.generatePoint(785.91, 260.45, 267.59);
            obj.p99R = obj.generatePoint(805.69, 558.8, 3.81);

            % Unit Vectors

            % FR
            obj.U_TR_FR = obj.unit(obj.p11F - obj.p12F);
            obj.U_LAA_F_FR = obj.unit(obj.p3F - obj.p1F);
            obj.U_LAA_A_FR = obj.unit(obj.p3F - obj.p2F);
            obj.U_UAA_F_FR = obj.unit(obj.p7F - obj.p5F);
            obj.U_UAA_A_FR = obj.unit(obj.p7F - obj.p6F);
            obj.U_PR_FR = obj.unit(obj.p8F - obj.p9F);

            % FL
            obj.U_TR_FL = obj.makeYNegative(obj.U_TR_FR);
            obj.U_LAA_F_FL = obj.makeYNegative(obj.U_LAA_F_FR);
            obj.U_LAA_A_FL = obj.makeYNegative(obj.U_LAA_A_FR);
            obj.U_UAA_F_FL = obj.makeYNegative(obj.U_UAA_F_FR);
            obj.U_UAA_A_FL = obj.makeYNegative(obj.U_UAA_A_FR);
            obj.U_PR_FL = obj.makeYNegative(obj.U_PR_FR);
            
            % RR
            obj.U_TR_RR = obj.unit(obj.p11R - obj.p12R);
            obj.U_LAA_F_RR = obj.unit(obj.p3R - obj.p1R);
            obj.U_LAA_A_RR = obj.unit(obj.p3R - obj.p2R);
            obj.U_UAA_F_RR = obj.unit(obj.p7R - obj.p5R);
            obj.U_UAA_A_RR = obj.unit(obj.p7R - obj.p6R);
            obj.U_PR_RR = obj.unit(obj.p8R - obj.p9R);

            % RL
            obj.U_TR_RL = obj.makeYNegative(obj.U_TR_RR);
            obj.U_LAA_F_RL = obj.makeYNegative(obj.U_LAA_F_RR);
            obj.U_LAA_A_RL = obj.makeYNegative(obj.U_LAA_A_RR);
            obj.U_UAA_F_RL = obj.makeYNegative(obj.U_UAA_F_RR);
            obj.U_UAA_A_RL = obj.makeYNegative(obj.U_UAA_A_RR);
            obj.U_PR_RL = obj.makeYNegative(obj.U_PR_RR);

            % "Rs"

            % FR
            obj.R_FR_TR = obj.p11F - obj.p19F;
            obj.R_FR_LAAF = obj.p3F - obj.p19F;
            obj.R_FR_LAAA = obj.p3F - obj.p19F;
            obj.R_FR_UAAF = obj.p7F - obj.p19F;
            obj.R_FR_UAAA = obj.p7F - obj.p19F;
            obj.R_FR_PR = obj.p8F - obj.p19F;

            % FL
            obj.R_FL_TR = obj.makeYNegative(obj.R_FR_TR);
            obj.R_FL_LAAF = obj.makeYNegative(obj.R_FR_LAAF);
            obj.R_FL_LAAA = obj.makeYNegative(obj.R_FR_LAAA);
            obj.R_FL_UAAF = obj.makeYNegative(obj.R_FR_UAAF);
            obj.R_FL_UAAA = obj.makeYNegative(obj.R_FR_UAAA);
            obj.R_FL_PR = obj.makeYNegative(obj.R_FR_PR);

            % RR
            obj.R_RR_TR = obj.p11R - obj.p19R;
            obj.R_RR_LAAF = obj.p3R - obj.p19R;
            obj.R_RR_LAAA = obj.p3R - obj.p19R;
            obj.R_RR_UAAF = obj.p7R - obj.p19R;
            obj.R_RR_UAAA = obj.p7R - obj.p19R;
            obj.R_RR_PR = obj.p8R - obj.p19R;

            % RL
            obj.R_RL_TR = obj.makeYNegative(obj.R_RR_TR);
            obj.R_RL_LAAF = obj.makeYNegative(obj.R_RR_LAAF);
            obj.R_RL_LAAA = obj.makeYNegative(obj.R_RR_LAAA);
            obj.R_RL_UAAF = obj.makeYNegative(obj.R_RR_UAAF);
            obj.R_RL_UAAA = obj.makeYNegative(obj.R_RR_UAAA);
            obj.R_RL_PR = obj.makeYNegative(obj.R_RR_PR);

            % Moments 

            % FR
            obj.M1_FR_TR = [((obj.U_TR_FR(3) * obj.R_FR_TR(2)) - (obj.U_TR_FR(2) * obj.R_FR_TR(3))) ((obj.U_TR_FR(3) * obj.R_FR_TR(1)) - (obj.U_TR_FR(1) * obj.R_FR_TR(3))) ((obj.U_TR_FR(2) * obj.R_FR_TR(1)) - (obj.U_TR_FR(1) * obj.R_FR_TR(2)))];
            obj.M1_FR_LAAF = [((obj.U_LAA_F_FR(3) * obj.R_FR_LAAF(2)) - (obj.U_LAA_F_FR(2) * obj.R_FR_LAAF(3))) ((obj.U_LAA_F_FR(3) * obj.R_FR_LAAF(1)) - (obj.U_LAA_F_FR(1) * obj.R_FR_LAAF(3))) ((obj.U_LAA_F_FR(2) * obj.R_FR_LAAF(1)) - (obj.U_LAA_F_FR(1) * obj.R_FR_LAAF(2)))];
            obj.M1_FR_LAAA = [((obj.U_LAA_A_FR(3) * obj.R_FR_LAAA(2)) - (obj.U_LAA_A_FR(2) * obj.R_FR_LAAA(3))) ((obj.U_LAA_A_FR(3) * obj.R_FR_LAAA(1)) - (obj.U_LAA_A_FR(1) * obj.R_FR_LAAA(3))) ((obj.U_LAA_A_FR(2) * obj.R_FR_LAAA(1)) - (obj.U_LAA_A_FR(1) * obj.R_FR_LAAA(2)))];
            obj.M1_FR_UAAF = [((obj.U_UAA_F_FR(3) * obj.R_FR_UAAF(2)) - (obj.U_UAA_F_FR(2) * obj.R_FR_UAAF(3))) ((obj.U_UAA_F_FR(3) * obj.R_FR_UAAF(1)) - (obj.U_UAA_F_FR(1) * obj.R_FR_UAAF(3))) ((obj.U_UAA_F_FR(2) * obj.R_FR_UAAF(1)) - (obj.U_UAA_F_FR(1) * obj.R_FR_UAAF(2)))];
            obj.M1_FR_UAAA = [((obj.U_UAA_A_FR(3) * obj.R_FR_UAAA(2)) - (obj.U_UAA_A_FR(2) * obj.R_FR_UAAA(3))) ((obj.U_UAA_A_FR(3) * obj.R_FR_UAAA(1)) - (obj.U_UAA_A_FR(1) * obj.R_FR_UAAA(3))) ((obj.U_UAA_A_FR(2) * obj.R_FR_UAAA(1)) - (obj.U_UAA_A_FR(1) * obj.R_FR_UAAA(2)))];
            obj.M1_FR_PR = [((obj.U_PR_FR(3) * obj.R_FR_PR(2)) - (obj.U_PR_FR(2) * obj.R_FR_PR(3))) ((obj.U_PR_FR(3) * obj.R_FR_PR(1)) - (obj.U_PR_FR(1) * obj.R_FR_PR(3))) ((obj.U_PR_FR(2) * obj.R_FR_PR(1)) - (obj.U_PR_FR(1) * obj.R_FR_PR(2)))];
            
            % FL
            obj.M1_FL_TR = [((obj.U_TR_FL(3) * obj.R_FL_TR(2)) - (obj.U_TR_FL(2) * obj.R_FL_TR(3))) ((obj.U_TR_FL(3) * obj.R_FL_TR(1)) - (obj.U_TR_FL(1) * obj.R_FL_TR(3))) ((obj.U_TR_FL(2) * obj.R_FL_TR(1)) - (obj.U_TR_FL(1) * obj.R_FL_TR(2)))];
            obj.M1_FL_LAAF = [((obj.U_LAA_F_FL(3) * obj.R_FL_LAAF(2)) - (obj.U_LAA_F_FL(2) * obj.R_FL_LAAF(3))) ((obj.U_LAA_F_FL(3) * obj.R_FL_LAAF(1)) - (obj.U_LAA_F_FL(1) * obj.R_FL_LAAF(3))) ((obj.U_LAA_F_FL(2) * obj.R_FL_LAAF(1)) - (obj.U_LAA_F_FL(1) * obj.R_FL_LAAF(2)))];
            obj.M1_FL_LAAA = [((obj.U_LAA_A_FL(3) * obj.R_FL_LAAA(2)) - (obj.U_LAA_A_FL(2) * obj.R_FL_LAAA(3))) ((obj.U_LAA_A_FL(3) * obj.R_FL_LAAA(1)) - (obj.U_LAA_A_FL(1) * obj.R_FL_LAAA(3))) ((obj.U_LAA_A_FL(2) * obj.R_FL_LAAA(1)) - (obj.U_LAA_A_FL(1) * obj.R_FL_LAAA(2)))];
            obj.M1_FL_UAAF = [((obj.U_UAA_F_FL(3) * obj.R_FL_UAAF(2)) - (obj.U_UAA_F_FL(2) * obj.R_FL_UAAF(3))) ((obj.U_UAA_F_FL(3) * obj.R_FL_UAAF(1)) - (obj.U_UAA_F_FL(1) * obj.R_FL_UAAF(3))) ((obj.U_UAA_F_FL(2) * obj.R_FL_UAAF(1)) - (obj.U_UAA_F_FL(1) * obj.R_FL_UAAF(2)))];
            obj.M1_FL_UAAA = [((obj.U_UAA_A_FL(3) * obj.R_FL_UAAA(2)) - (obj.U_UAA_A_FL(2) * obj.R_FL_UAAA(3))) ((obj.U_UAA_A_FL(3) * obj.R_FL_UAAA(1)) - (obj.U_UAA_A_FL(1) * obj.R_FL_UAAA(3))) ((obj.U_UAA_A_FL(2) * obj.R_FL_UAAA(1)) - (obj.U_UAA_A_FL(1) * obj.R_FL_UAAA(2)))];
            obj.M1_FL_PR = [((obj.U_PR_FL(3) * obj.R_FL_PR(2)) - (obj.U_PR_FL(2) * obj.R_FL_PR(3))) ((obj.U_PR_FL(3) * obj.R_FL_PR(1)) - (obj.U_PR_FL(1) * obj.R_FL_PR(3))) ((obj.U_PR_FL(2) * obj.R_FL_PR(1)) - (obj.U_PR_FL(1) * obj.R_FL_PR(2)))];
            
            % RR
            obj.M1_RR_TR = [((obj.U_TR_RR(3) * obj.R_RR_TR(2)) - (obj.U_TR_RR(2) * obj.R_RR_TR(3))) ((obj.U_TR_RR(3) * obj.R_RR_TR(1)) - (obj.U_TR_RR(1) * obj.R_RR_TR(3))) ((obj.U_TR_RR(2) * obj.R_RR_TR(1)) - (obj.U_TR_RR(1) * obj.R_RR_TR(2)))];
            obj.M1_RR_LAAF = [((obj.U_LAA_F_RR(3) * obj.R_RR_LAAF(2)) - (obj.U_LAA_F_RR(2) * obj.R_RR_LAAF(3))) ((obj.U_LAA_F_RR(3) * obj.R_RR_LAAF(1)) - (obj.U_LAA_F_RR(1) * obj.R_RR_LAAF(3))) ((obj.U_LAA_F_RR(2) * obj.R_RR_LAAF(1)) - (obj.U_LAA_F_RR(1) * obj.R_RR_LAAF(2)))];
            obj.M1_RR_LAAA = [((obj.U_LAA_A_RR(3) * obj.R_RR_LAAA(2)) - (obj.U_LAA_A_RR(2) * obj.R_RR_LAAA(3))) ((obj.U_LAA_A_RR(3) * obj.R_RR_LAAA(1)) - (obj.U_LAA_A_RR(1) * obj.R_RR_LAAA(3))) ((obj.U_LAA_A_RR(2) * obj.R_RR_LAAA(1)) - (obj.U_LAA_A_RR(1) * obj.R_RR_LAAA(2)))];
            obj.M1_RR_UAAF = [((obj.U_UAA_F_RR(3) * obj.R_RR_UAAF(2)) - (obj.U_UAA_F_RR(2) * obj.R_RR_UAAF(3))) ((obj.U_UAA_F_RR(3) * obj.R_RR_UAAF(1)) - (obj.U_UAA_F_RR(1) * obj.R_RR_UAAF(3))) ((obj.U_UAA_F_RR(2) * obj.R_RR_UAAF(1)) - (obj.U_UAA_F_RR(1) * obj.R_RR_UAAF(2)))];
            obj.M1_RR_UAAA = [((obj.U_UAA_A_RR(3) * obj.R_RR_UAAA(2)) - (obj.U_UAA_A_RR(2) * obj.R_RR_UAAA(3))) ((obj.U_UAA_A_RR(3) * obj.R_RR_UAAA(1)) - (obj.U_UAA_A_RR(1) * obj.R_RR_UAAA(3))) ((obj.U_UAA_A_RR(2) * obj.R_RR_UAAA(1)) - (obj.U_UAA_A_RR(1) * obj.R_RR_UAAA(2)))];
            obj.M1_RR_PR = [((obj.U_PR_RR(3) * obj.R_RR_PR(2)) - (obj.U_PR_RR(2) * obj.R_RR_PR(3))) ((obj.U_PR_RR(3) * obj.R_RR_PR(1)) - (obj.U_PR_RR(1) * obj.R_RR_PR(3))) ((obj.U_PR_RR(2) * obj.R_RR_PR(1)) - (obj.U_PR_RR(1) * obj.R_RR_PR(2)))];

            % RL
            obj.M1_RL_TR = [((obj.U_TR_RL(3) * obj.R_RL_TR(2)) - (obj.U_TR_RL(2) * obj.R_RL_TR(3))) ((obj.U_TR_RL(3) * obj.R_RL_TR(1)) - (obj.U_TR_RL(1) * obj.R_RL_TR(3))) ((obj.U_TR_RL(2) * obj.R_RL_TR(1)) - (obj.U_TR_RL(1) * obj.R_RL_TR(2)))];
            obj.M1_RL_LAAF = [((obj.U_LAA_F_RL(3) * obj.R_RL_LAAF(2)) - (obj.U_LAA_F_RL(2) * obj.R_RL_LAAF(3))) ((obj.U_LAA_F_RL(3) * obj.R_RL_LAAF(1)) - (obj.U_LAA_F_RL(1) * obj.R_RL_LAAF(3))) ((obj.U_LAA_F_RL(2) * obj.R_RL_LAAF(1)) - (obj.U_LAA_F_RL(1) * obj.R_RL_LAAF(2)))];
            obj.M1_RL_LAAA = [((obj.U_LAA_A_RL(3) * obj.R_RL_LAAA(2)) - (obj.U_LAA_A_RL(2) * obj.R_RL_LAAA(3))) ((obj.U_LAA_A_RL(3) * obj.R_RL_LAAA(1)) - (obj.U_LAA_A_RL(1) * obj.R_RL_LAAA(3))) ((obj.U_LAA_A_RL(2) * obj.R_RL_LAAA(1)) - (obj.U_LAA_A_RL(1) * obj.R_RL_LAAA(2)))];
            obj.M1_RL_UAAF = [((obj.U_UAA_F_RL(3) * obj.R_RL_UAAF(2)) - (obj.U_UAA_F_RL(2) * obj.R_RL_UAAF(3))) ((obj.U_UAA_F_RL(3) * obj.R_RL_UAAF(1)) - (obj.U_UAA_F_RL(1) * obj.R_RL_UAAF(3))) ((obj.U_UAA_F_RL(2) * obj.R_RL_UAAF(1)) - (obj.U_UAA_F_RL(1) * obj.R_RL_UAAF(2)))];
            obj.M1_RL_UAAA = [((obj.U_UAA_A_RL(3) * obj.R_RL_UAAA(2)) - (obj.U_UAA_A_RL(2) * obj.R_RL_UAAA(3))) ((obj.U_UAA_A_RL(3) * obj.R_RL_UAAA(1)) - (obj.U_UAA_A_RL(1) * obj.R_RL_UAAA(3))) ((obj.U_UAA_A_RL(2) * obj.R_RL_UAAA(1)) - (obj.U_UAA_A_RL(1) * obj.R_RL_UAAA(2)))];
            obj.M1_RL_PR = [((obj.U_PR_RL(3) * obj.R_RL_PR(2)) - (obj.U_PR_RL(2) * obj.R_RL_PR(3))) ((obj.U_PR_RL(3) * obj.R_RL_PR(1)) - (obj.U_PR_RL(1) * obj.R_RL_PR(3))) ((obj.U_PR_RL(2) * obj.R_RL_PR(1)) - (obj.U_PR_RL(1) * obj.R_RL_PR(2)))];


        end

        % Unitizes a given vector A
        function output = unit(~, A)
            output = A/norm(A);
        end

        % Makes the y-coordinate of the unit vector negative
        function output = makeYNegative(~, A)
            A(2) = -(A(2));
            output = A;
        end

        % Generates 3D points as a column vector and converts mm to in
        function output = generatePoint(~, x, y, z)
            output = [x/25.4 y/25.4 z/25.4];
        end
    end
end