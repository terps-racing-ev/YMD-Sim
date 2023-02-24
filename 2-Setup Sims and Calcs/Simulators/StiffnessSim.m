function [Kw,Kr] = StiffnessSim(Ks,KARB,Kt,MRs,MRARB)
    Kw = [(Ks(1,1).*(MRs(1,1)).^2)+(KARB(:,1).*(MRARB(:,1)).^2),(Ks(1,2).*(MRs(1,2)).^2)+(KARB(:,1).*(MRARB(:,1)).^2);
    (Ks(2,1).*(MRs(2,1)).^2)+(KARB(:,2).*(MRARB(:,2)).^2),(Ks(2,2).*(MRs(2,2)).^2)+(KARB(:,2).*(MRARB(:,2))^2)];

    Kr = [(Kt(1,1)*Kw(1,1))/(Kt(1,1)+Kw(1,1)) (Kt(1,2)*Kw(1,2))/(Kt(1,2)+Kw(1,2));
    (Kt(2,1)*Kw(2,1))/(Kt(2,1)+Kw(2,1)) (Kt(2,2)*Kw(2,2))/(Kt(2,2)+Kw(2,2))];
end