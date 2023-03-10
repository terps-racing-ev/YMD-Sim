function [Fx,Fy,Mz] = findTireFM(model,SlipAngles,Camber,Fz,TirePressure)
% Credit: LJ Hamilton
%   Inputs: alpha, inclination angle, Fz, P
%   Outputs: Fx, Fy, Mz
Fxi = [0 0 0 0];
Fyi = [0 0 0 0];
Mzi = [0 0 0 0];
for m = 1:2
    Fxi(m) = model.FxFront.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
    Fyi(m) = model.FyFront.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
    Mzi(m) = model.MzFront.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
end

for m = 3:4
    Fxi(m) = model.FxRear.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
    Fyi(m) = model.FyRear.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
    Mzi(m) = model.MzRear.predictFcn([SlipAngles(m),Camber(m),Fz(m),TirePressure(m)]);
end

Fx = reshape(Fxi,[2,2]);
Fy = reshape(Fyi,[2,2]);
Mz = reshape(Mzi,[2,2]);
