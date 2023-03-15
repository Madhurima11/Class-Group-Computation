//This program returns k as valid if proper R,q,r can be computed.

load "field_now.m";

k:=4;

fb:=FactorBasis(ok, BachBound(K));
q:=Floor(#fb/k);
r:=#fb-(q*k);
 table_size:=2*q;
if(q ge r) then
	R:=Floor(table_size/q);
	printf "\n k=%o, R=%o, q=%o, r=%o",k,R,q,r;
	approx_length_of_table:=R*q;
	PrintFile("approx_length_of_table.txt",approx_length_of_table:Overwrite:=true);
	PrintFile("integer_k_number_of_ideals_taken.m",k:Overwrite:=true);
	PrintFile("number_of_terms_each_round_product_k_plus_one_ideals_r.txt",r:Overwrite:=true);
	PrintFile("number_of_terms_each_round_q.txt",q:Overwrite:=true);
	PrintFile("number_of_times_ideal_below_bb_R.txt",R:Overwrite:=true);
else
	printf "\n INVALID k";
end if;
