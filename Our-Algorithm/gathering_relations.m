
nthreads:=StringToInteger(strnthreads);
thread_id:=StringToInteger(strthread_id);

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
	new_exp:=e1 cat exp_seq;//[e1[i]+exp_seq[i] : i in [1..#exp_seq]];
	new_ideal:=input_ideal*ideal<ok|precomputed_table[i][1][1]>;
	return [*new_ideal,new_exp*];
end function;

prec_lattice:= 2000 ;
prec_positive_def:= 6000   ;
printf "\n  bl_size_beta=%o, prec_lattice=%o", bl_size_beta,prec_lattice;

walk_length:=8;
time while(number_of_relations_obtained lt relation_bound) do
	j:=j+1;
	ideal_for_random_walk,exponent_walk_ideal:=Explode(products_of_ideal_and_exponent(2,bound_on_exp));
	req_lattice:=Lattice(ideal_for_random_walk:Precision:=prec_lattice);
	itr:=itr+1;
	/*if((itr mod 10) eq 1) then
		printf "\n till now number_of_relations_obtained=%o, itr=%o",number_of_relations_obtained,itr;
	end if;*/
	length_now:=0;
	while((length_now lt walk_length) and (number_of_relations_obtained lt relation_bound))do
		x_v:= bkz(ideal_for_random_walk,req_lattice, bl_size_beta);
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
			end if;	
			next:=next_ideal(ideal_for_random_walk,exponent_walk_ideal,#precomputed_table);
			ideal_for_random_walk:=next[1];
			exponent_walk_ideal:=next[2];
			itr:=itr+1;
			if((itr mod 100) eq 1) then
				printf "\n till now number_of_relations_obtained=%o, itr=%o",number_of_relations_obtained,itr;
			end if;
			req_lattice:=Lattice(ideal_for_random_walk:Precision:=prec_lattice);
			length_now:=length_now+1;	
		else
			break;
		end if;
	end while;
end while;
printf "\n #precomputed_table eq (R*q)=%o", #precomputed_table eq (R*q);
printf "\n fb_bound_B=%o, bound_k=%o, R=%o, q=%o, r=%o, table_size=%o",fb_bound_B,bound_k,R,q,r,#precomputed_table;

printf "\n computed only %o elements as product of k ideals",j;
printf "\n relations collected=%o",number_of_relations_obtained;
printf "\n itr=%o",itr;
printf "\n RealField(4)!(itr/j)=%o\n \n",RealField(4)!(itr/j);

printf "\n Cputime(t0)=%o, Realtime(tr)=%o ",Cputime(t0),Realtime(tr);
PrintFile(file_relation_alg_integer_seq,"relation_alg_integer_seq:=":Overwrite:=true);
PrintFile(file_relation_alg_integer_seq,relation_alg_integer_seq);
PrintFile(file_relation_alg_integer_seq,";");
PrintFile(file_relation_prime_ideal_seq_of_seq,"relation_prime_ideal_seq_of_seq:=[":Overwrite:=true);

//delete relation_alg_integer_seq;


PrintFile(file_relation_exponents_integer_seq_of_seq,"relation_exponents_integer_seq_of_seq:=":Overwrite:=true);
time PrintFile(file_relation_exponents_integer_seq_of_seq,relation_exponents_integer_seq_of_seq);
PrintFile(file_relation_exponents_integer_seq_of_seq,";");


//delete relation_exponents_integer_seq_of_seq;

printf "will enter for loop";
t0:=Cputime();
tr:=Realtime();
time for j in [1..#relation_prime_ideal_seq_of_seq] do
	PrintFile(file_relation_prime_ideal_seq_of_seq,"[");	
	for k in [1..#relation_prime_ideal_seq_of_seq[j]] do
		PrintFile(file_relation_prime_ideal_seq_of_seq,Basis(relation_prime_ideal_seq_of_seq[j][k]));				
		if(k ne #relation_prime_ideal_seq_of_seq[j])then		
			PrintFile(file_relation_prime_ideal_seq_of_seq,",");
		elif(j ne #relation_prime_ideal_seq_of_seq) then
			PrintFile(file_relation_prime_ideal_seq_of_seq,"],");
		end if;
	end for;
	if(j eq #relation_prime_ideal_seq_of_seq) then
		PrintFile(file_relation_prime_ideal_seq_of_seq,"]");
	end if;
end for;
printf "\n  after printing Cputime(t0)=%o, Realtime(tr)=%o ",Cputime(t0),Realtime(tr);
PrintFile(file_relation_prime_ideal_seq_of_seq,"];");


/*to verify relations*/
/*
relation_seq:=[];
time for i in [1..#relation_alg_integer_seq] do
	i1:=ideal<ok|relation_alg_integer_seq[i]>;
	i2:=&*[ideal<ok|relation_prime_ideal_seq_of_seq[i][j]>^relation_exponents_integer_seq_of_seq[i][j] : j in [1..#relation_exponents_integer_seq_of_seq[i]]];
	Append(~relation_seq,i1);
	if(i1 ne i2) then
		PrintFile("invalid_relations.txt",thread_id);
		printf "\n relation %o not valid",i;break;
	elif( i eq #relation_alg_integer_seq) then
		printf "ALL RELATIONS VALID";
		if(#SequenceToSet(relation_seq) eq #relation_seq) then
			printf "\n for this thread relations are distinct";
		else
			printf "\nfor this thread relations are NOT distinct";
			printf "\nfor this thread total number of relations=%o",#relation_seq;
			printf "\n number of distinct relations=%o",#SequenceToSet(relation_seq);
		end if;
	end if;
end for;*/
