function [latTrngData,tireID,testID] = createLatTrngData(filename)
%LJ Hamilton, 8 Jan 2022
%   a function that puts lateral tire data into a table
t = load(filename);
tireID = t.tireid;
testID = t.testid;

corr = 0.625;%factor to compensate for road surface friction
    SA =t.SA'; %slip angle (deg)
    P = t.P'; %pressure (psi)
    FY = corr*t.FY'; %lateral force(lb)
    IA = t.IA'; %inlcination angle (deg)
    FZ = t.FZ'; %normal force (lbf)
    MZ = -corr*t.MZ'; %aligning torque (lbf-ft)
    MuY = corr*t.NFY'; %coefficient of lateral friction, muy
    RL = t.RL'; %Loaded Tire Radius (in)

latTrngData = [SA' IA' FZ' P' FY' MuY' MZ' RL'];
