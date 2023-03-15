//CREATING THE NUMBER FIELD
QQ:=RationalField();
_<x>:=PolynomialRing(QQ);


f:=x^15 - 15*x^13 + 105*x^11 - 78*x^10 - 425*x^9 + 780*x^8 + 1050*x^7 - 3510*x^6 - 2832*x^5 + 7800*x^4 + 7660*x^3 - 7800*x^2 - 13320*x - 8856; 
abs_dis:= (2^10)*(3^7)*(5^26);
n:=Degree(f);

