load "field_now.m";
load "sizes_of_associated_quantities_file.m";
fb:=FactorBasis(ok,fb_bound_B);
//fb:=FactorBasis(ok, BachBound(K));
fb_basis_of_ideals:=[Basis(fb[i]) : i in [1..#fb]];
PrintFile("factor_base.m","factor_basis:=":Overwrite:=true);
PrintFile("factor_base.m",fb_basis_of_ideals);
PrintFile("factor_base.m",";");
