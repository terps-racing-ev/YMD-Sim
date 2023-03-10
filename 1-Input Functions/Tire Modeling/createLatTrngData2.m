function [latTrngData,tireID] = createLatTrngData2(filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
t = load(filename);
tireID = t.tireid;
testID = t.testid;

corr = 0.625; %correction factor for sandpaper

    SA =t.SA';
    P = t.P';
    FY = corr*t.FY';
    IA = t.IA';
    FZ = t.FZ';
    FX = t.FX';
    MX = t.MX';
    NFX = t.NFX';
    NFY = corr*t.NFY';
    MZ = corr*t.MZ';
    SR = t.SR';
  
latTrngData = [SA' IA' FZ' P' FY' FX' MZ'];
