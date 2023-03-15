lo:=StringToInteger(strlo);
hi:=StringToInteger(strhi);
//lo:=1;hi:=10;
printf "\n lo=%o, hi=%o \n",lo,hi;
load "field_now.m";
load "sizes_of_associated_quantities_file.m";
load "factor_base.m";
load "index_for_precomputed_table.m";

PrintFile(file_table_part,"part_precomputed_table:=":Overwrite:=true);
part_precomputed_table:=[];

num_fb:=#factor_basis; 


printf "\n number of factor basis elements=%o",num_fb;
for i in [lo..hi] do
	//exponent_seq:=[0: j in [1..num_fb]];
	if( (i mod 50) eq 0) then
		printf "\n at i=%o",i;
	end if;
	indexes:=seq_of_indexes_for_precomputed_table[i];
	prod_ideal:=&*[ideal<ok|factor_basis[indexes[j]]> : j in [1..#indexes]]; 
	/*for j in [1..#indexes] do
		exponent_seq[indexes[j]]:=1;
	end for;*/
	Append(~part_precomputed_table,[*Basis(prod_ideal) , indexes*]);
end for;

PrintFile(file_table_part,part_precomputed_table);
PrintFile(file_table_part,";");


