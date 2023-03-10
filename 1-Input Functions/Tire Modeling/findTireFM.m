function [Fx,Fy,Mz] = findTireFM(model,tire)
% Credit: LJ Hamilton
%   Inputs: alpha, inclination angle, Fz, P
%   Outputs: Fx, Fy, Mz
Fx = [0 0; 0 0];
Fy = [0 0; 0 0];
Mz = [0 0; 0 0];
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

