

//function products_of_ideal_and_exponent returns the product of exactly number_of_ideals wanted and the corresponding non zero exponent seq as a list
//new one
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
	exponent_walk_ideal:=k_index_of_fb;//get_walk_seq(k_index_of_fb,exp_non_zero);
	return [* &*[prime_ideal_seq[i]^exp_non_zero[i] : i in [1..number_of_ideals]],exponent_walk_ideal*];
end function;



// function BKZ which given an ideal returns the shortest vector if other restrictive conditions of positive definiteness are met
function bkz(ideal,lat_ideal, block_size)
	B,T:= BKZ(lat_ideal,block_size); 
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



//new one
function get_fac_seq(fac_seq,exp_seq)
	t1:=[fac_seq[i][1] : i in [1..#fac_seq]];
	t2:=[fac_seq[i][2] : i in [1..#fac_seq]];
	list_fact:=[* *];
	for i in [1..#exp_seq] do
		tmp:=ideal<ok|factor_basis[exp_seq[i]]>;
		if(tmp in t1) then
			j:=Index(t1,tmp);	
			exp:=t2[j]+1;
			Remove(~t1, j);
			Remove(~t2, j);	
		else
			exp:=1;	
		end if;
		Append(~list_fact,[*tmp,exp*]);
	end for;
	for i in [1..#t1] do
		Append(~list_fact,[*t1[i],t2[i]*]);
	end for;
	return list_fact;
end function;

