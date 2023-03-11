function [Fx,Fy,Mz] = findTireFM(model,tire)
% Credit: LJ Hamilton
%   Inputs: alpha, inclination angle, Fz, P
%   Outputs: Fx, Fy, Mz

Fx = [0 0 0 0];
Fy = [0 0 0 0];
Mz = [0 0 0 0];
for m = 1:2
    Fx(m) = model.FxFront.predictFcn([tire.alphasD(m),tire.gammas(m),tire.FZ(m),tire.P(m)]);
    Fy(m) = model.FyFront.predictFcn([tire.alphasD(m),tire.gammas(m),tire.FZ(m),tire.P(m)]);
    Mz(m) = model.MzFront.predictFcn([tire.alphasD(m),tire.gammas(m),tire.FZ(m),tire.P(m)]);
end

for m = 3:4
    Fx(m) = model.FxRear.predictFcn([tire.alphasD(m),tire.gammas(m),tire.FZ(m),tire.P(m)]);
    Fy(m) = model.FyRear.predictFcn([tire.alphasD(m),tire.gammas(m),tire.FZ(m),tire.P(m)]);
    Mz(m) = model.MzRear.predictFcn([tire.alphasD(m),tire.gammas(m),tire.FZ(m),tire.P(m)]);
end

% Fxi = [0 0 0 0];
% Fyi = [0 0 0 0];
% Mzi = [0 0 0 0];
% for m = 1:2
%     Fxi(m) = model.FxFront.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
%     Fyi(m) = model.FyFront.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
%     Mzi(m) = model.MzFront.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
% end
% 
% for m = 3:4
%     Fxi(m) = model.FxRear.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
%     Fyi(m) = model.FyRear.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
%     Mzi(m) = model.MzRear.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
% end
% 
% Fxf = [Fx(1,1) Fx(1,2); Fx(1,3) Fx(1,4)];
% Fyf = [Fy(1,1) Fy(1,2); Fy(1,3) Fy(1,4)];
% Mzf = [Mz(1,1) Mz(1,2); Mz(1,3) Mz(1,4)];
end
