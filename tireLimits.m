function [TL]= tireLimits(BF,Fz)

TL_F = [((BF(1,:)/2)/(Fz(1,1))) ((BF(1,:)/2)/(Fz(1,2)))];
TL_R = [((BF(2,:)/2)/(Fz(2,1))) ((BF(2,:)/2)/(Fz(2,2)))];
    
TL = [TL_F;TL_R];

end