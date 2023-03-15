//CREATING THE NUMBER FIELD
QQ:=RationalField();
_<x>:=PolynomialRing(QQ);


f:=x^10 - 20*x^8 - 170*x^6 - 1704*x^5 - 2100*x^4 - 1680*x^3 - 23865*x^2 - 36360*x + 15984;
 
abs_dis:=(2^30)*(3^5)*(5^11);


n:=Degree(f);
