
omega:=3;
function subexponential_complexity(N1,alpha1,c1) 
	very_small:=1/(10^25);
	f1:=c1+very_small;
	f2:=Log(N1)^alpha1;
	f3:=(Log(Log(N1)))^(1-alpha1);
	return Exp(f1*f2*f3);
end function;

function get_walk_seq(k_integer_seq,non_zero_seq)
	seq:=[];
	j:=1;
	for i in [1..#k_integer_seq] do
		//seq[k_integer_seq[i]]:=non_zero_seq[j];seq;
		Insert(~seq,k_integer_seq[i] , non_zero_seq[j]);		
		j:=j+1;
	end for;
	//seq;
	for i in [1..num_fb] do
		if(IsDefined(seq, i) eq false)then
			seq[i]:=0;
		end if;
	end for;
	return seq;
end function;



//function products_of_ideal_and_exponent returns the product of exactly number_of_ideals wanted and the corresponding exponent seq as a list
function products_of_ideal_and_exponent(number_of_ideals,bound_on_exponents)
	k_index_of_fb:=[];
	tmp:=[i: i in [1..num_fb]];
	repeat
		ran:=Random(tmp);
		Append(~k_index_of_fb,ran);
		Exclude(~tmp,ran);
	until(#k_index_of_fb ge number_of_ideals);
	Sort(~k_index_of_fb);
	exp_non_zero:=[Random(1,bound_on_exponents) : i in [1..number_of_ideals]];	
	prime_ideal_seq:=[ideal<ok|factor_basis[k_index_of_fb[i]]> : i in [1..number_of_ideals]]; 		
	exponent_walk_ideal:=get_walk_seq(k_index_of_fb,exp_non_zero);
	return [* &*[prime_ideal_seq[i]^exp_non_zero[i] : i in [1..number_of_ideals]],exponent_walk_ideal*];
end function;



/*
function default_precision_requirements_bkz_met_or_not(input_ideal)
	try
		lat_input:=Lattice(input_ideal); 
		catch e;
	end try;
	if(assigned lat_input) then
		if( IsPositiveDefinite(GramMatrix(Lattice(input_ideal: Precision:=500))))then
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
*/
// function BKZ which given an ideal returns the shortest vector if other restrictive conditions of positive definiteness are met
function bkz(ideal,lat_ideal, block_size)
	B,T:= BKZ(lat_ideal, block_size);
	BC := CoordinateLattice(B); 
	if( IsPositiveDefinite(GramMatrix(BC))) then
		short_in_lattice:=Vector(Coordinates(ShortestVectors(BC)[1]));
		a1 := short_in_lattice*T;
		basis_ideal := Basis(ideal);
		x_v := &+ [ a1[i] * basis_ideal[i] : i in [1..#basis_ideal]];
		return x_v;
	else
		return 0;	
	end if;
end function;

function get_fac_seq(fac_seq,exp_seq)
	t1:=[fac_seq[i][1] : i in [1..#fac_seq]];
	t2:=[fac_seq[i][2] : i in [1..#fac_seq]];
	list_fact:=[* *];
	for i in [1..#exp_seq] do
		if(exp_seq[i] gt 0) then
			tmp:=ideal<ok|factor_basis[i]>;
			if(tmp in t1) then
				j:=Index(t1,tmp);	
				exp:=t2[j]+exp_seq[i];
				Remove(~t1, j);
				Remove(~t2, j);	
			else
				exp:=exp_seq[i];
			end if;	
			Append(~list_fact,[*tmp,exp*]);	
		end if;
	end for;
	for i in [1..#t1] do
		Append(~list_fact,[*t1[i],t2[i]*]);
	end for;
	return list_fact;
end function;

function get_walk_seq(k_integer_seq,non_zero_seq)
	seq:=[];
	j:=1;
	for i in [1..#k_integer_seq] do
		//seq[k_integer_seq[i]]:=non_zero_seq[j];seq;
		Insert(~seq,k_integer_seq[i] , non_zero_seq[j]);		
		j:=j+1;
	end for;
	//seq;
	for i in [1..num_fb] do
		if(IsDefined(seq, i) eq false)then
			seq[i]:=0;
		end if;
	end for;
	return seq;
end function;
