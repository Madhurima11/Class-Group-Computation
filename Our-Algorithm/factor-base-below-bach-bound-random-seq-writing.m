// May be replaced by any field of choice
load "field_now.m";
load "sizes_of_associated_quantities_file.m";

//fb:=FactorBasis(ok, BachBound(K));
load "factor_base.m";
//fb_basis_of_ideals:=[Basis(fb[i]) : i in [1..#fb]];
fb_basis_of_ideals:=factor_basis; 
nbb:=#fb_basis_of_ideals;

//PrintFile("factor_base.m","factor_basis:=":Overwrite:=true);
//PrintFile("factor_base.m",fb_basis_of_ideals);
//PrintFile("factor_base.m",";");

R:=StringToInteger(Read("number_of_times_ideal_below_bb_R.txt"));
q:=StringToInteger(Read("number_of_terms_each_round_q.txt"));
r:=StringToInteger(Read("number_of_terms_each_round_product_k_plus_one_ideals_r.txt"));

printf "\n nbb=%o, R=%o, q=%o, r=%o",nbb,R,q,r;
function get_indexes_to_add(number_of_terms_to_select, parent_set)
	tmp:=parent_set;
	child_set:={};
	for i in [1..number_of_terms_to_select] do
		random_elm:=Random(tmp);
		Exclude(~tmp,random_elm);
		Include(~child_set, random_elm);	
	end for;
	return [child_set,tmp];
end function;


seq_of_indexes_for_precomputed_table:=[];
for i in [1..R] do
	indexes_now:={index:index in [1..nbb]};	nn:=#indexes_now;
	for j in [1..q] do
		if(j le r) then
			number_of_terms:=bound_k+1;
			
		else	
			number_of_terms:=bound_k;
		end if;	
		random_indexes,indexes_now:=Explode(get_indexes_to_add(number_of_terms,indexes_now));
		Append(~seq_of_indexes_for_precomputed_table, SetToSequence(random_indexes));
		//printf "\n (nn-#indexes_now) eq number_of_terms=%o", (nn-#indexes_now) eq number_of_terms; 
		nn:=#indexes_now;
				
	end for;
	//printf "\n #indexes_now=%o",#indexes_now;
end for;

PrintFile("index_for_precomputed_table.m","seq_of_indexes_for_precomputed_table:=":Overwrite:=true);

PrintFile("index_for_precomputed_table.m",seq_of_indexes_for_precomputed_table);
PrintFile("index_for_precomputed_table.m",";");



/* Below lines are needed only when ideals above Bach Bound are considered 
greater_fb:=FactorBasis(ok,fb_bound_B);
greater_fb_basis_of_ideals:=[Basis(greater_fb[i]) : i in [1..#greater_fb]];
greater_nbb:=#greater_fb;

PrintFile("greater_factor_base.m","greater_factor_basis:=":Overwrite:=true);
PrintFile("greater_factor_base.m",greater_fb_basis_of_ideals);
PrintFile("greater_factor_base.m",";");


/* Till here */
