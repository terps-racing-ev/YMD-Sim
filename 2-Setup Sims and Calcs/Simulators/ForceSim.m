%% Force Simulator

classdef ForceSim
    % output 2x2
    % Input Fx, Fy, Fz for test case
    % Calculate forces in each member (FL,FR,RL,RR)
    
    methods (Static)
        function [SUSPForces] = Forces_FL(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            currentFolder = pwd;
            addpath([currentFolder, filesep, '1-Input Functions']);
            vObj = GeoPoints();
        
            B_FL = [Fx(1, 1); Fy(1, 1); Fz(1, 1); ((Fz(1, 1)*vObj.R(2)) - (Fy(1, 1)*vObj.R(3))); ((Fx(1, 1)*vObj.R(3)) - (Fz(1, 1)*vObj.R(1))); ((Fy(1, 1)*vObj.R(1)) - (Fx(1, 1)*vObj.R(2)))];
        
            [SUSPForces] = vObj.A_I_FL * B_FL;
        end
        
        function [SUSPForces] = Forces_FR(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            currentFolder = pwd;
            addpath([currentFolder, filesep, '1-Input Functions']);
            vObj = GeoPoints();
        
            B_FR = [Fx(1, 2); 
                    Fy(1, 2); 
                    Fz(1, 2); 
                    ((Fz(1, 2)*vObj.R(2)) - (Fy(1, 2)*vObj.R(3))); 
                    ((Fx(1, 2)*vObj.R(3)) - (Fz(1, 2)*vObj.R(1))); 
                    ((Fy(1, 2)*vObj.R(1)) - (Fx(1, 2)*vObj.R(2)))];
        
            [SUSPForces] = vObj.A_I_FR * B_FR;
        end
        
        function [SUSPForces] = Forces_RL(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            currentFolder = pwd;
            addpath([currentFolder, filesep, '1-Input Functions']);
            vObj = GeoPoints();
        
            B_RL = [Fx(2, 1); 
                    Fy(2, 1); 
                    Fz(2, 1); 
                    ((Fz(2, 1)*vObj.R(2)) - (Fy(2, 1)*vObj.R(3))); 
                    ((Fx(2, 1)*vObj.R(3)) - (Fz(2, 1)*vObj.R(1))); 
                    ((Fy(2, 1)*vObj.R(1)) - (Fx(2, 1)*vObj.R(2)))];
        
            [SUSPForces] = vObj.A_I_RL * B_RL;
        end
        
        function [SUSPForces] = Forces_RR(Fx,Fy,Fz)
            % Adding Vehicle Parameters
            currentFolder = pwd;
            addpath([currentFolder, filesep, '1-Input Functions']);
            vObj = GeoPoints();
        
            B_RR = [Fx(2, 2); 
                    Fy(2, 2); 
                    Fz(2, 2); 
                    ((Fz(2, 2)*vObj.R(2)) - (Fy(2, 2)*vObj.R(3))); 
                    ((Fx(2, 2)*vObj.R(3)) - (Fz(2, 2)*vObj.R(1))); 
                    ((Fy(2, 2)*vObj.R(1)) - (Fx(2, 2)*vObj.R(2)))];
        
            [SUSPForces] = vObj.A_I_RR * B_RR;
        end
    end 
end
