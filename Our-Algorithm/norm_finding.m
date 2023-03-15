


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
relation_bound:=60;
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


prec_lattice:= 2000 ;
prec_positive_def:= 6000   ;


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

walk_length:=8;
norm_seq:=[];
time for i in [1..100] do
	j:=j+1;
	ideal_for_random_walk,exponent_walk_ideal:=Explode(products_of_ideal_and_exponent(2,bound_on_exp));PrintFile("ideal_now",ideal_for_random_walk:Overwrite:=true); 	
	req_lattice:=Lattice(ideal_for_random_walk:Precision:=prec_lattice);
	itr:=itr+1;
	if((itr mod 10) eq 1) then
		printf "\n itr=%o",itr;	
		printf "\n norm_seq=%o",norm_seq;
	end if;
	length_now:=0;
	while(length_now le walk_length)do
		//printf "\n at 0";	
		length_now:=length_now+1;
		x_v:= bkz(ideal_for_random_walk,req_lattice, 2);//printf "\n at 1";
		abs:= AbsoluteValue(Norm(x_v) div Norm(ideal_for_random_walk));
		Append(~norm_seq,Floor(Log(2,abs)));
		next:=next_ideal(ideal_for_random_walk,exponent_walk_ideal,#precomputed_table);
		ideal_for_random_walk:=next[1];PrintFile("ideal_now",ideal_for_random_walk); 	
		exponent_walk_ideal:=next[2];
		itr:=itr+1;
		req_lattice:=Lattice(ideal_for_random_walk:Precision:=prec_lattice);	
		if((itr mod 10) eq 1) then
			printf "\n itr=%o",itr;
			printf "\n norm_seq=%o",norm_seq;
		end if;
		if(abs eq 0) then
			printf "\n breaking as abs = 0";
			break;	
		end if;
	end while;
end for;
printf "\n after everything norm_seq=%o",norm_seq;
printf "\n #precomputed_table eq (R*q)=%o", #precomputed_table eq (R*q);
printf "\n fb_bound_B=%o, bound_k=%o, R=%o, q=%o, r=%o, table_size=%o",fb_bound_B,bound_k,R,q,r,#precomputed_table;




