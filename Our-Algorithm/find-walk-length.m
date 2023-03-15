load "field_now.m";
load "sizes_of_associated_quantities_file.m";
load "table_precomputed.m";
load "factor_base.m";
num_fb:=#factor_basis;
load "fun.m";


printf "\n fb_bound_B=%o, bound_k=%o, bound_A=%o, bl_size_beta=%o, alpha=%o\n",fb_bound_B,bound_k,bound_A,bl_size_beta,alpha;

R:=StringToInteger(Read("number_of_times_ideal_below_bb_R.txt"));
q:=StringToInteger(Read("number_of_terms_each_round_q.txt"));
r:=StringToInteger(Read("number_of_terms_each_round_product_k_plus_one_ideals_r.txt"));

printf "\n #precomputed_table eq (R*q)=%o", #precomputed_table eq (R*q);
printf "\n fb_bound_B=%o, bound_k=%o, R=%o, q=%o, r=%o, table_size=%o",fb_bound_B,bound_k,R,q,r,#precomputed_table;
number_of_relations_obtained:=0;
relation_alg_integer_seq:=[];
relation_prime_ideal_seq_of_seq:=[];
relation_exponents_integer_seq_of_seq:=[];
set_of_prime_ideals_that_occur:={@@};

itr:=0;
number_of_relations_obtained:=0;
relation_bound:=StringToInteger(Read("relation_per_thread.txt"));
printf "\n relation_bound=%o",relation_bound;

t0:=Cputime();
tr:=Realtime();
j:=0;
bound_on_exp:=1;


function next_ideal(input_ideal,exp_seq,table_length)
	i:=Hash(input_ideal) mod (table_length);i:=i+1;
	e1:=precomputed_table[i][1][2];
	new_exp:=[e1[i]+exp_seq[i] : i in [1..#exp_seq]];
	new_ideal:=input_ideal*ideal<ok|precomputed_table[i][1][1]>;
	return [*new_ideal,new_exp*];
end function;


prec_lattice:= 4000 ;
prec_positive_def:= 10000   ;
function default_precision_requirements_bkz_met_or_not(input_ideal)
	try
		//lat_input:=Lattice(input_ideal); 
		lat_input:=Lattice(input_ideal:Precision:=prec_lattice);
		catch e;
	end try;
	if(assigned lat_input) then
		//if( IsPositiveDefinite(GramMatrix(Lattice(input_ideal: Precision:=500))))then
		if( IsPositiveDefinite(GramMatrix(Lattice(input_ideal: Precision:=prec_positive_def))))then	
			//printf "\n into option 1";
			return [*lat_input,1*];
		else
			//printf "\n into option 2";
			return [*0,0*];	
		end if;
	else
		return [*0,0*];	
	end if;
end function;


printf "\n prec_lattice=%o, prec_positive_def=%o",prec_lattice,prec_positive_def;
fp:=10;
for i in [1..fp] do
	ideal_for_random_walk,exponent_walk_ideal:=Explode(products_of_ideal_and_exponent(2,bound_on_exp));
	req_lattice:=default_precision_requirements_bkz_met_or_not(ideal_for_random_walk);
	
	len:=0;
	while((req_lattice[2] eq 1))do
		len:=len+1;
		/*x_v:= bkz(ideal_for_random_walk,req_lattice[1], bl_size_beta);
		abs:= AbsoluteValue(Norm(x_v) div Norm(ideal_for_random_walk));
		if(abs gt 0) then
			if(abs gt 1) then
				tmp:=Factorization(abs);
				max_norm:= tmp[#tmp][1];
				if(max_norm lt fb_bound_B) then
				number_of_relations_obtained:=number_of_relations_obtained+1;
					idealb:= ideal<ok|x_v>*(ideal_for_random_walk^(-1));
					fac_for_b:=Factorization(idealb);
					Append(~relation_alg_integer_seq,x_v);  
					fac_seq_for_x_v:=get_fac_seq(fac_for_b,exponent_walk_ideal);		
					Append(~relation_prime_ideal_seq_of_seq,[fac_seq_for_x_v[i][1] :i in [1..#fac_seq_for_x_v]]);
					Append(~relation_exponents_integer_seq_of_seq,[fac_seq_for_x_v[i][2] :i in [1..#fac_seq_for_x_v]]);
				end if;	
			end if;	*/
			next:=next_ideal(ideal_for_random_walk,exponent_walk_ideal,#precomputed_table);
			ideal_for_random_walk:=next[1];
			exponent_walk_ideal:=next[2];
			itr:=itr+1;
			if((itr mod 100) eq 1) then
				printf "\n till now number_of_relations_obtained=%o, itr=%o",number_of_relations_obtained,itr;
	end if;
			req_lattice:=default_precision_requirements_bkz_met_or_not(ideal_for_random_walk);	
		/*else
			break;
		end if;
		printf "\n at walk point=%o, number_of_relations_obtained=%o, max_norm=%o, fps till now=%o",len,number_of_relations_obtained,max_norm,i;*/
		printf "\n at walk point=%o, number_of_relations_obtained=%o,  fps till now=%o",len,number_of_relations_obtained,i;
	end while;
	printf "\n \n FOR THIS ELEMENT len=%o",len;
end for;

printf "\n TOTAL number_of_relations_obtained=%o, itr=%o, full-products=%o",number_of_relations_obtained,itr,fp;
