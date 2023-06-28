
function [Fx,Fy,Mz,muy] = findTireFM(model,alphasD,gammas,FZ,P)
    % Credit: LJ Hamilton
    %   Inputs: alpha, inclination angle, Fz, P
    %   Outputs: Fx, Fy, Mz, mux, muy
    
    for k = 1:2
        for m = 1
            Fx(m,k) = model.FxFront.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
            Fy(m,k) = model.FyFront.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
            Mz(m,k) = model.MzFront.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
            %mux(m,k) = model.muxFront.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
<<<<<<< HEAD
            muy(m,k) = model.muyFront.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
=======
            muy(m,k) = model.muyFront.predictFcn([alphasD(m,k),abs(gammas(m,k)),FZ(m,k),P(m,k)]);
>>>>>>> Yash-Goswami
        end
        for m = 2
            Fx(m,k) = model.FxRear.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
            Fy(m,k) = model.FyRear.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
            Mz(m,k) = model.MzRear.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
            %mux(m,k) = model.muxRear.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
<<<<<<< HEAD
            muy(m,k) = model.muyRear.predictFcn([alphasD(m,k),gammas(m,k),FZ(m,k),P(m,k)]);
=======
            muy(m,k) = model.muyRear.predictFcn([alphasD(m,k),abs(gammas(m,k)),FZ(m,k),P(m,k)]);
>>>>>>> Yash-Goswami
        end
    end
end
