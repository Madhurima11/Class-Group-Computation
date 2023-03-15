lo:=StringToInteger(strlo);
hi:=StringToInteger(strhi);
nthreads:=StringToInteger(strnthreads);
thread_id:=StringToInteger(strthread_id);

//lo:=1;hi:=7;nthreads:=3;thread_id:=1;
printf "\n lo=%o, hi=%o \n",lo,hi;

load "field_now.m";
load "sizes_of_associated_quantities_file.m";
load "factor_base.m";

num_fb:=#factor_basis;

load "fun-gelin.m";

printf "\n fb_bound_B=%o, bound_k=%o, bound_A=%o, bl_size_beta=%o\n",fb_bound_B,bound_k,bound_A,bl_size_beta;
number_of_relations_obtained:=0;
relation_alg_integer_seq:=[];
relation_prime_ideal_seq_of_seq:=[];
relation_exponents_integer_seq_of_seq:=[];
set_of_prime_ideals_that_occur:={@@};

printf "\n abs_dis=%o",abs_dis;
printf "\n alpha gt (1/2) =%o",alpha gt (1/2);
//printf "\n number_of_prime_ideals_below_bach_bound=%o",number_of_prime_ideals_below_bach_bound;

itr:=0;
number_of_relations_obtained:=0;
number_of_relations_wanted:=hi-lo+1;
//number_of_relations_wanted:=tringToInteger(Read("relation_per_thread.txt"));
relation_index:=number_of_relations_obtained+lo-1;
printf "\n number_of_relations_wanted=%o",number_of_relations_wanted;
prec_lattice:= 2000 ;
prec_positive_def:= 6000   ;
printf "\n  bl_size_beta=%o, prec_lattice=%o", bl_size_beta,prec_lattice;

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

t0:=Cputime();
tr:=Realtime();
time while(number_of_relations_obtained lt number_of_relations_wanted) do
	itr:=itr+1;//printf "\n itr=%o, signal=%o",itr,signal;
	ideal_for_random_walk,exponent_walk_ideal:=Explode(products_of_ideal_and_exponent(bound_k,bound_A));
	req_lattice:=default_precision_requirements_bkz_met_or_not(ideal_for_random_walk);
	if((itr mod 100) eq 1) then
		printf "\n itr=%o, number_of_relations_obtained=%o",itr,number_of_relations_obtained;
	end if;
	if(req_lattice[2] eq 1)then		
		x_v:= bkz(ideal_for_random_walk,req_lattice[1], bl_size_beta);
		abs:= AbsoluteValue(Norm(x_v) div Norm(ideal_for_random_walk));
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
	end if;	
end while;
printf "\n fb_bound_B=%o, bound_k=%o, bound_A=%o, bl_size_beta=%o, alpha=%o\n",fb_bound_B,bound_k,bound_A,bl_size_beta,alpha;

printf "\n Cputime(t0)=%o, Realtime(tr)=%o ",Cputime(t0),Realtime(tr);

printf "\n number_of_relations_obtained=%o in itr=%o, relation_index=%o ",number_of_relations_obtained,itr, relation_index;

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
