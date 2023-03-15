// May be replaced by any field of choice
load "all-fields/field-1-10.m";
printf "\n defining poly=%o",f;
K<y>:=NumberField(f); //THE NUMBER FIELD
printf "\n will do ring of integers";
time ok:=RingOfIntegers(K);
ZZ:=IntegerRing();

