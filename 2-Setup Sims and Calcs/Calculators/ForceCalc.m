%% Force Simulator

classdef ForceCalc
    % output 6x1
    % Input Fx, Fy, Fz for test case
    % Calculate forces in each member (FL,FR,RL,RR)
   
    
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
        function obj = ForceCalc(~)
        point= TREV3Parameters();

            % Unit Vectors

            % FR
            obj.U_TR_FR = obj.unit(point.p11F - point.p12F);
            obj.U_LAA_F_FR = obj.unit(point.p3F - point.p1F);
            obj.U_LAA_A_FR = obj.unit(point.p3F - point.p2F);
            obj.U_UAA_F_FR = obj.unit(point.p7F - point.p5F);
            obj.U_UAA_A_FR = obj.unit(point.p7F - point.p6F);
            obj.U_PR_FR = obj.unit(point.p8F - point.p9F);

            % FL
            obj.U_TR_FL = obj.makeYNegative(obj.U_TR_FR);
            obj.U_LAA_F_FL = obj.makeYNegative(obj.U_LAA_F_FR);
            obj.U_LAA_A_FL = obj.makeYNegative(obj.U_LAA_A_FR);
            obj.U_UAA_F_FL = obj.makeYNegative(obj.U_UAA_F_FR);
            obj.U_UAA_A_FL = obj.makeYNegative(obj.U_UAA_A_FR);
            obj.U_PR_FL = obj.makeYNegative(obj.U_PR_FR);
            
            % RR
            obj.U_TR_RR = obj.unit(point.p11R - point.p12R);
            obj.U_LAA_F_RR = obj.unit(point.p3R - point.p1R);
            obj.U_LAA_A_RR = obj.unit(point.p3R - point.p2R);
            obj.U_UAA_F_RR = obj.unit(point.p7R - point.p5R);
            obj.U_UAA_A_RR = obj.unit(point.p7R - point.p6R);
            obj.U_PR_RR = obj.unit(point.p8R - point.p9R);

            % RL
            obj.U_TR_RL = obj.makeYNegative(obj.U_TR_RR);
            obj.U_LAA_F_RL = obj.makeYNegative(obj.U_LAA_F_RR);
            obj.U_LAA_A_RL = obj.makeYNegative(obj.U_LAA_A_RR);
            obj.U_UAA_F_RL = obj.makeYNegative(obj.U_UAA_F_RR);
            obj.U_UAA_A_RL = obj.makeYNegative(obj.U_UAA_A_RR);
            obj.U_PR_RL = obj.makeYNegative(obj.U_PR_RR);

            % "Rs"

            % FR
            obj.R_FR_TR = point.p11F - point.p19F;
            obj.R_FR_LAAF = point.p3F - point.p19F;
            obj.R_FR_LAAA = point.p3F - point.p19F;
            obj.R_FR_UAAF = point.p7F - point.p19F;
            obj.R_FR_UAAA = point.p7F - point.p19F;
            obj.R_FR_PR = point.p8F - point.p19F;

            % FL
            obj.R_FL_TR = obj.makeYNegative(obj.R_FR_TR);
            obj.R_FL_LAAF = obj.makeYNegative(obj.R_FR_LAAF);
            obj.R_FL_LAAA = obj.makeYNegative(obj.R_FR_LAAA);
            obj.R_FL_UAAF = obj.makeYNegative(obj.R_FR_UAAF);
            obj.R_FL_UAAA = obj.makeYNegative(obj.R_FR_UAAA);
            obj.R_FL_PR = obj.makeYNegative(obj.R_FR_PR);

            % RR
            obj.R_RR_TR = point.p11R - point.p19R;
            obj.R_RR_LAAF = point.p3R - point.p19R;
            obj.R_RR_LAAA = point.p3R - point.p19R;
            obj.R_RR_UAAF = point.p7R - point.p19R;
            obj.R_RR_UAAA = point.p7R - point.p19R;
            obj.R_RR_PR = point.p8R - point.p19R;

            % RL
            obj.R_RL_TR = obj.makeYNegative(obj.R_RR_TR);
            obj.R_RL_LAAF = obj.makeYNegative(obj.R_RR_LAAF);
            obj.R_RL_LAAA = obj.makeYNegative(obj.R_RR_LAAA);
            obj.R_RL_UAAF = obj.makeYNegative(obj.R_RR_UAAF);
            obj.R_RL_UAAA = obj.makeYNegative(obj.R_RR_UAAA);
            obj.R_RL_PR = obj.makeYNegative(obj.R_RR_PR);

            % Moments 

            % FR
            obj.M1_FR_TR = [((obj.U_TR_FR(3) * obj.R_FR_TR(2)) - (obj.U_TR_FR(2) * obj.R_FR_TR(3))) ((obj.U_TR_FR(1) * obj.R_FR_TR(3)) - (obj.U_TR_FR(3) * obj.R_FR_TR(1))) ((obj.U_TR_FR(2) * obj.R_FR_TR(1)) - (obj.U_TR_FR(1) * obj.R_FR_TR(2)))];
            obj.M1_FR_LAAF = [((obj.U_LAA_F_FR(3) * obj.R_FR_LAAF(2)) - (obj.U_LAA_F_FR(2) * obj.R_FR_LAAF(3))) ((obj.U_LAA_F_FR(1) * obj.R_FR_LAAF(3)) - (obj.U_LAA_F_FR(3) * obj.R_FR_LAAF(1))) ((obj.U_LAA_F_FR(2) * obj.R_FR_LAAF(1)) - (obj.U_LAA_F_FR(1) * obj.R_FR_LAAF(2)))];
            obj.M1_FR_LAAA = [((obj.U_LAA_A_FR(3) * obj.R_FR_LAAA(2)) - (obj.U_LAA_A_FR(2) * obj.R_FR_LAAA(3))) ((obj.U_LAA_A_FR(1) * obj.R_FR_LAAA(3)) - (obj.U_LAA_A_FR(3) * obj.R_FR_LAAA(1))) ((obj.U_LAA_A_FR(2) * obj.R_FR_LAAA(1)) - (obj.U_LAA_A_FR(1) * obj.R_FR_LAAA(2)))];
            obj.M1_FR_UAAF = [((obj.U_UAA_F_FR(3) * obj.R_FR_UAAF(2)) - (obj.U_UAA_F_FR(2) * obj.R_FR_UAAF(3))) ((obj.U_UAA_F_FR(1) * obj.R_FR_UAAF(3)) - (obj.U_UAA_F_FR(3) * obj.R_FR_UAAF(1))) ((obj.U_UAA_F_FR(2) * obj.R_FR_UAAF(1)) - (obj.U_UAA_F_FR(1) * obj.R_FR_UAAF(2)))];
            obj.M1_FR_UAAA = [((obj.U_UAA_A_FR(3) * obj.R_FR_UAAA(2)) - (obj.U_UAA_A_FR(2) * obj.R_FR_UAAA(3))) ((obj.U_UAA_A_FR(1) * obj.R_FR_UAAA(3)) - (obj.U_UAA_A_FR(3) * obj.R_FR_UAAA(1))) ((obj.U_UAA_A_FR(2) * obj.R_FR_UAAA(1)) - (obj.U_UAA_A_FR(1) * obj.R_FR_UAAA(2)))];
            obj.M1_FR_PR = [((obj.U_PR_FR(3) * obj.R_FR_PR(2)) - (obj.U_PR_FR(2) * obj.R_FR_PR(3))) ((obj.U_PR_FR(1) * obj.R_FR_PR(3)) - (obj.U_PR_FR(3) * obj.R_FR_PR(1))) ((obj.U_PR_FR(2) * obj.R_FR_PR(1)) - (obj.U_PR_FR(1) * obj.R_FR_PR(2)))];
            
            % FL
            obj.M1_FL_TR = [((obj.U_TR_FL(3) * obj.R_FL_TR(2)) - (obj.U_TR_FL(2) * obj.R_FL_TR(3))) ((obj.U_TR_FL(1) * obj.R_FL_TR(3)) - (obj.U_TR_FL(3) * obj.R_FL_TR(1))) ((obj.U_TR_FL(2) * obj.R_FL_TR(1)) - (obj.U_TR_FL(1) * obj.R_FL_TR(2)))];
            obj.M1_FL_LAAF = [((obj.U_LAA_F_FL(3) * obj.R_FL_LAAF(2)) - (obj.U_LAA_F_FL(2) * obj.R_FL_LAAF(3))) ((obj.U_LAA_F_FL(1) * obj.R_FL_LAAF(3)) - (obj.U_LAA_F_FL(3) * obj.R_FL_LAAF(1))) ((obj.U_LAA_F_FL(2) * obj.R_FL_LAAF(1)) - (obj.U_LAA_F_FL(1) * obj.R_FL_LAAF(2)))];
            obj.M1_FL_LAAA = [((obj.U_LAA_A_FL(3) * obj.R_FL_LAAA(2)) - (obj.U_LAA_A_FL(2) * obj.R_FL_LAAA(3))) ((obj.U_LAA_A_FL(1) * obj.R_FL_LAAA(3)) - (obj.U_LAA_A_FL(3) * obj.R_FL_LAAA(1))) ((obj.U_LAA_A_FL(2) * obj.R_FL_LAAA(1)) - (obj.U_LAA_A_FL(1) * obj.R_FL_LAAA(2)))];
            obj.M1_FL_UAAF = [((obj.U_UAA_F_FL(3) * obj.R_FL_UAAF(2)) - (obj.U_UAA_F_FL(2) * obj.R_FL_UAAF(3))) ((obj.U_UAA_F_FL(1) * obj.R_FL_UAAF(3)) - (obj.U_UAA_F_FL(3) * obj.R_FL_UAAF(1))) ((obj.U_UAA_F_FL(2) * obj.R_FL_UAAF(1)) - (obj.U_UAA_F_FL(1) * obj.R_FL_UAAF(2)))];
            obj.M1_FL_UAAA = [((obj.U_UAA_A_FL(3) * obj.R_FL_UAAA(2)) - (obj.U_UAA_A_FL(2) * obj.R_FL_UAAA(3))) ((obj.U_UAA_A_FL(1) * obj.R_FL_UAAA(3)) - (obj.U_UAA_A_FL(3) * obj.R_FL_UAAA(1))) ((obj.U_UAA_A_FL(2) * obj.R_FL_UAAA(1)) - (obj.U_UAA_A_FL(1) * obj.R_FL_UAAA(2)))];
            obj.M1_FL_PR = [((obj.U_PR_FL(3) * obj.R_FL_PR(2)) - (obj.U_PR_FL(2) * obj.R_FL_PR(3))) ((obj.U_PR_FL(1) * obj.R_FL_PR(3)) - (obj.U_PR_FL(3) * obj.R_FL_PR(1))) ((obj.U_PR_FL(2) * obj.R_FL_PR(1)) - (obj.U_PR_FL(1) * obj.R_FL_PR(2)))];
            
            % RR
            obj.M1_RR_TR = [((obj.U_TR_RR(3) * obj.R_RR_TR(2)) - (obj.U_TR_RR(2) * obj.R_RR_TR(3))) ((obj.U_TR_RR(1) * obj.R_RR_TR(3)) - (obj.U_TR_RR(3) * obj.R_RR_TR(1))) ((obj.U_TR_RR(2) * obj.R_RR_TR(1)) - (obj.U_TR_RR(1) * obj.R_RR_TR(2)))];
            obj.M1_RR_LAAF = [((obj.U_LAA_F_RR(3) * obj.R_RR_LAAF(2)) - (obj.U_LAA_F_RR(2) * obj.R_RR_LAAF(3))) ((obj.U_LAA_F_RR(1) * obj.R_RR_LAAF(3)) - (obj.U_LAA_F_RR(3) * obj.R_RR_LAAF(1))) ((obj.U_LAA_F_RR(2) * obj.R_RR_LAAF(1)) - (obj.U_LAA_F_RR(1) * obj.R_RR_LAAF(2)))];
            obj.M1_RR_LAAA = [((obj.U_LAA_A_RR(3) * obj.R_RR_LAAA(2)) - (obj.U_LAA_A_RR(2) * obj.R_RR_LAAA(3))) ((obj.U_LAA_A_RR(1) * obj.R_RR_LAAA(3)) - (obj.U_LAA_A_RR(3) * obj.R_RR_LAAA(1))) ((obj.U_LAA_A_RR(2) * obj.R_RR_LAAA(1)) - (obj.U_LAA_A_RR(1) * obj.R_RR_LAAA(2)))];
            obj.M1_RR_UAAF = [((obj.U_UAA_F_RR(3) * obj.R_RR_UAAF(2)) - (obj.U_UAA_F_RR(2) * obj.R_RR_UAAF(3))) ((obj.U_UAA_F_RR(1) * obj.R_RR_UAAF(3)) - (obj.U_UAA_F_RR(3) * obj.R_RR_UAAF(1))) ((obj.U_UAA_F_RR(2) * obj.R_RR_UAAF(1)) - (obj.U_UAA_F_RR(1) * obj.R_RR_UAAF(2)))];
            obj.M1_RR_UAAA = [((obj.U_UAA_A_RR(3) * obj.R_RR_UAAA(2)) - (obj.U_UAA_A_RR(2) * obj.R_RR_UAAA(3))) ((obj.U_UAA_A_RR(1) * obj.R_RR_UAAA(3)) - (obj.U_UAA_A_RR(3) * obj.R_RR_UAAA(1))) ((obj.U_UAA_A_RR(2) * obj.R_RR_UAAA(1)) - (obj.U_UAA_A_RR(1) * obj.R_RR_UAAA(2)))];
            obj.M1_RR_PR = [((obj.U_PR_RR(3) * obj.R_RR_PR(2)) - (obj.U_PR_RR(2) * obj.R_RR_PR(3))) ((obj.U_PR_RR(1) * obj.R_RR_PR(3)) - (obj.U_PR_RR(3) * obj.R_RR_PR(1))) ((obj.U_PR_RR(2) * obj.R_RR_PR(1)) - (obj.U_PR_RR(1) * obj.R_RR_PR(2)))];

            % RL
            obj.M1_RL_TR = [((obj.U_TR_RL(3) * obj.R_RL_TR(2)) - (obj.U_TR_RL(2) * obj.R_RL_TR(3))) ((obj.U_TR_RL(1) * obj.R_RL_TR(3)) - (obj.U_TR_RL(3) * obj.R_RL_TR(1))) ((obj.U_TR_RL(2) * obj.R_RL_TR(1)) - (obj.U_TR_RL(1) * obj.R_RL_TR(2)))];
            obj.M1_RL_LAAF = [((obj.U_LAA_F_RL(3) * obj.R_RL_LAAF(2)) - (obj.U_LAA_F_RL(2) * obj.R_RL_LAAF(3))) ((obj.U_LAA_F_RL(1) * obj.R_RL_LAAF(3)) - (obj.U_LAA_F_RL(3) * obj.R_RL_LAAF(1))) ((obj.U_LAA_F_RL(2) * obj.R_RL_LAAF(1)) - (obj.U_LAA_F_RL(1) * obj.R_RL_LAAF(2)))];
            obj.M1_RL_LAAA = [((obj.U_LAA_A_RL(3) * obj.R_RL_LAAA(2)) - (obj.U_LAA_A_RL(2) * obj.R_RL_LAAA(3))) ((obj.U_LAA_A_RL(1) * obj.R_RL_LAAA(3)) - (obj.U_LAA_A_RL(3) * obj.R_RL_LAAA(1))) ((obj.U_LAA_A_RL(2) * obj.R_RL_LAAA(1)) - (obj.U_LAA_A_RL(1) * obj.R_RL_LAAA(2)))];
            obj.M1_RL_UAAF = [((obj.U_UAA_F_RL(3) * obj.R_RL_UAAF(2)) - (obj.U_UAA_F_RL(2) * obj.R_RL_UAAF(3))) ((obj.U_UAA_F_RL(1) * obj.R_RL_UAAF(3)) - (obj.U_UAA_F_RL(3) * obj.R_RL_UAAF(1))) ((obj.U_UAA_F_RL(2) * obj.R_RL_UAAF(1)) - (obj.U_UAA_F_RL(1) * obj.R_RL_UAAF(2)))];
            obj.M1_RL_UAAA = [((obj.U_UAA_A_RL(3) * obj.R_RL_UAAA(2)) - (obj.U_UAA_A_RL(2) * obj.R_RL_UAAA(3))) ((obj.U_UAA_A_RL(1) * obj.R_RL_UAAA(3)) - (obj.U_UAA_A_RL(3) * obj.R_RL_UAAA(1))) ((obj.U_UAA_A_RL(2) * obj.R_RL_UAAA(1)) - (obj.U_UAA_A_RL(1) * obj.R_RL_UAAA(2)))];
            obj.M1_RL_PR = [((obj.U_PR_RL(3) * obj.R_RL_PR(2)) - (obj.U_PR_RL(2) * obj.R_RL_PR(3))) ((obj.U_PR_RL(1) * obj.R_RL_PR(3)) - (obj.U_PR_RL(3) * obj.R_RL_PR(1))) ((obj.U_PR_RL(2) * obj.R_RL_PR(1)) - (obj.U_PR_RL(1) * obj.R_RL_PR(2)))];

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
    end



    methods (Static)
        function [SUSPForces] = Forces_FL(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            obj = ForceCalc();
        
            B_FL = [Fx;
                    Fy;
                    Fz;
                    ((Fz*obj.R(2)) - (Fy*obj.R(3)));
                    ((Fx*obj.R(3) - (Fz*obj.R(1))));
                    ((Fy*obj.R(1)) - (Fx*obj.R(2)))];
        
            [SUSPForces] = obj.A_I_FL * B_FL;
        end
        
        function [SUSPForces] = Forces_FR(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            obj = ForceCalc();

            
            B_FR = [Fx; 
                    Fy; 
                    Fz; 
                    ((Fz*obj.R(2)) - (Fy*obj.R(3))); 
                    ((Fx*obj.R(3)) - (Fz*obj.R(1))); 
                    ((Fy*obj.R(1)) - (Fx*obj.R(2)))];
        
            [SUSPForces] = obj.A_I_FR * B_FR;
        end
        
        function [SUSPForces] = Forces_RL(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            obj = ForceCalc();


            B_RL = [Fx; 
                    Fy; 
                    Fz; 
                    ((Fz*obj.R(2)) - (Fy*obj.R(3))); 
                    ((Fx*obj.R(3)) - (Fz*obj.R(1))); 
                    ((Fy*obj.R(1)) - (Fx*obj.R(2)))];
        
            [SUSPForces] = obj.A_I_RL * B_RL;
        end
        
        function [SUSPForces] = Forces_RR(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            obj = ForceCalc();
        

            B_RR = [Fx; 
                    Fy; 
                    Fz; 
                    ((Fz*obj.R(2)) - (Fy*obj.R(3))); 
                    ((Fx*obj.R(3)) - (Fz*obj.R(1))); 
                    ((Fy*obj.R(1)) - (Fx*obj.R(2)))];
        
            [SUSPForces] = obj.A_I_RR * B_RR;
        end
    end 
end
