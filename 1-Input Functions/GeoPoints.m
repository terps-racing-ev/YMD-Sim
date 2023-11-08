<<<<<<< Updated upstream:1-Input Functions/GeoPoints.m
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
=======
%% Force Calculator
>>>>>>> Stashed changes:2-Setup Sims and Calcs/Calculators/ForceCalc.m

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

    %% A matrix and A^-1 matrix
    properties (SetAccess = private)
        A_FL
        A_FR
        A_RL
        A_RR

        % Inverses
        A_I_FL
        A_I_FR
        A_I_RL
        A_I_RR

        masterInverseMatrix
        R
    end
       
    %% Methods

    methods
        % Setting all points, look here for values
        function obj = GeoPoints()
                       filePath= 'TREV2 Cookbook.csv';
            points= readtable(filePath, 'VariableNamingRule', 'preserve');

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

            % A matrices

            % FL
            obj.A_FL = [obj.U_TR_FL(1) obj.U_LAA_F_FL(1) obj.U_LAA_A_FL(1) obj.U_UAA_F_FL(1) obj.U_UAA_A_FL(1) obj.U_PR_FL(1); 
                        obj.U_TR_FL(2) obj.U_LAA_F_FL(2) obj.U_LAA_A_FL(2) obj.U_UAA_F_FL(2) obj.U_UAA_A_FL(2) obj.U_PR_FL(2); 
                        obj.U_TR_FL(3) obj.U_LAA_F_FL(3) obj.U_LAA_A_FL(3) obj.U_UAA_F_FL(3) obj.U_UAA_A_FL(3) obj.U_PR_FL(3)
                        obj.M1_FL_TR(1) obj.M1_FL_LAAF(1) obj.M1_FL_LAAA(1) obj.M1_FL_UAAF(1) obj.M1_FL_UAAA(1) obj.M1_FL_PR(1)
                        obj.M1_FL_TR(2) obj.M1_FL_LAAF(2) obj.M1_FL_LAAA(2) obj.M1_FL_UAAF(2) obj.M1_FL_UAAA(2) obj.M1_FL_PR(2)
                        obj.M1_FL_TR(3) obj.M1_FL_LAAF(3) obj.M1_FL_LAAA(3) obj.M1_FL_UAAF(3) obj.M1_FL_UAAA(3) obj.M1_FL_PR(3)];

            % FR
            obj.A_FR = [obj.U_TR_FR(1) obj.U_LAA_F_FR(1) obj.U_LAA_A_FR(1) obj.U_UAA_F_FR(1) obj.U_UAA_A_FR(1) obj.U_PR_FR(1); 
                        obj.U_TR_FR(2) obj.U_LAA_F_FR(2) obj.U_LAA_A_FR(2) obj.U_UAA_F_FR(2) obj.U_UAA_A_FR(2) obj.U_PR_FR(2); 
                        obj.U_TR_FR(3) obj.U_LAA_F_FR(3) obj.U_LAA_A_FR(3) obj.U_UAA_F_FR(3) obj.U_UAA_A_FR(3) obj.U_PR_FR(3); 
                        obj.M1_FR_TR(1) obj.M1_FR_LAAF(1) obj.M1_FR_LAAA(1) obj.M1_FR_UAAF(1) obj.M1_FR_UAAA(1) obj.M1_FR_PR(1); 
                        obj.M1_FR_TR(2) obj.M1_FR_LAAF(2) obj.M1_FR_LAAA(2) obj.M1_FR_UAAF(2) obj.M1_FR_UAAA(2) obj.M1_FR_PR(2); 
                        obj.M1_FR_TR(3) obj.M1_FR_LAAF(3) obj.M1_FR_LAAA(3) obj.M1_FR_UAAF(3) obj.M1_FR_UAAA(3) obj.M1_FR_PR(3)];

            % RL
            obj.A_RL = [obj.U_TR_RL(1) obj.U_LAA_F_RL(1) obj.U_LAA_A_RL(1) obj.U_UAA_F_RL(1) obj.U_UAA_A_RL(1) obj.U_PR_RL(1); 
                        obj.U_TR_RL(2) obj.U_LAA_F_RL(2) obj.U_LAA_A_RL(2) obj.U_UAA_F_RL(2) obj.U_UAA_A_RL(2) obj.U_PR_RL(2); 
                        obj.U_TR_RL(3) obj.U_LAA_F_RL(3) obj.U_LAA_A_RL(3) obj.U_UAA_F_RL(3) obj.U_UAA_A_RL(3) obj.U_PR_RL(3); 
                        obj.M1_RL_TR(1) obj.M1_RL_LAAF(1) obj.M1_RL_LAAA(1) obj.M1_RL_UAAF(1) obj.M1_RL_UAAA(1) obj.M1_RL_PR(1); 
                        obj.M1_RL_TR(2) obj.M1_RL_LAAF(2) obj.M1_RL_LAAA(2) obj.M1_RL_UAAF(2) obj.M1_RL_UAAA(2) obj.M1_RL_PR(2); 
                        obj.M1_RL_TR(3) obj.M1_RL_LAAF(3) obj.M1_RL_LAAA(3) obj.M1_RL_UAAF(3) obj.M1_RL_UAAA(3) obj.M1_RL_PR(3)];

            % RR
            obj.A_RR = [obj.U_TR_RR(1) obj.U_LAA_F_RR(1) obj.U_LAA_A_RR(1) obj.U_UAA_F_RR(1) obj.U_UAA_A_RR(1) obj.U_PR_RR(1); 
                        obj.U_TR_RR(2) obj.U_LAA_F_RR(2) obj.U_LAA_A_RR(2) obj.U_UAA_F_RR(2) obj.U_UAA_A_RR(2) obj.U_PR_RR(2); 
                        obj.U_TR_RR(3) obj.U_LAA_F_RR(3) obj.U_LAA_A_RR(3) obj.U_UAA_F_RR(3) obj.U_UAA_A_RR(3) obj.U_PR_RR(3); 
                        obj.M1_RR_TR(1) obj.M1_RR_LAAF(1) obj.M1_RR_LAAA(1) obj.M1_RR_UAAF(1) obj.M1_RR_UAAA(1) obj.M1_RR_PR(1); 
                        obj.M1_RR_TR(2) obj.M1_RR_LAAF(2) obj.M1_RR_LAAA(2) obj.M1_RR_UAAF(2) obj.M1_RR_UAAA(2) obj.M1_RR_PR(2); 
                        obj.M1_RR_TR(3) obj.M1_RR_LAAF(3) obj.M1_RR_LAAA(3) obj.M1_RR_UAAF(3) obj.M1_RR_UAAA(3) obj.M1_RR_PR(3)];

            % A Inverse Matrices

            % FL
            obj.A_I_FL = inv(obj.A_FL);

            % FR
            obj.A_I_FR = inv(obj.A_FR);

            % RL
            obj.A_I_RL = inv(obj.A_RL);

            % RR
            obj.A_I_RR = inv(obj.A_RR);

            obj.masterInverseMatrix = [obj.A_I_FL obj.A_I_FR; obj.A_I_RL obj.A_I_RR];
            obj.R = [0 0 8];

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

%         % Generates 3D points as a column vector and converts mm to in
%         function output = generatePoint(~, x, y, z)
%             output = [x/25.4 y/25.4 z/25.4];
%         end
    end
end