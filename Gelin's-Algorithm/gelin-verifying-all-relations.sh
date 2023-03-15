verifying_file=gelin-verify-all-relations.m
echo "load \"field_now.m\";" > $verifying_file
nthreads=$(<nthreads.txt)

echo "tmp_relation_alg_integer_seq:=[];">>$verifying_file
echo "tmp_relation_prime_ideal_seq_of_seq:=[];">>$verifying_file
echo "tmp_relation_exponents_integer_seq_of_seq:=[];">>$verifying_file

for((i=1; i<=$nthreads; i++))
do
	echo "load \"part_gelin_relation_folder/file_gelin_relation_alg_integer_seq-thread-$i.m\";">>$verifying_file 
	echo "load \"part_gelin_relation_folder/file_gelin_relation_prime_ideal_seq_of_seq-thread-$i.m\";">>$verifying_file 
	echo "load \"part_gelin_relation_folder/file_gelin_relation_exponents_integer_seq_of_seq-thread-$i.m\";">>$verifying_file 
	echo "tmp_relation_alg_integer_seq:=tmp_relation_alg_integer_seq cat relation_alg_integer_seq;">>$verifying_file
	echo "tmp_relation_prime_ideal_seq_of_seq:=tmp_relation_prime_ideal_seq_of_seq cat relation_prime_ideal_seq_of_seq;">>$verifying_file
	echo "tmp_relation_exponents_integer_seq_of_seq:=tmp_relation_exponents_integer_seq_of_seq cat relation_exponents_integer_seq_of_seq;">>$verifying_file
	echo "delete relation_alg_integer_seq;
	       delete relation_prime_ideal_seq_of_seq;
		delete relation_exponents_integer_seq_of_seq;" >> $verifying_file
done
wait
echo "gelin_relation_alg_integer_seq:=tmp_relation_alg_integer_seq;
gelin_relation_prime_ideal_seq_of_seq:=tmp_relation_prime_ideal_seq_of_seq;
gelin_relation_exponents_integer_seq_of_seq:=tmp_relation_exponents_integer_seq_of_seq;
gelin_relation_seq:=[];
printf \"\ntotal number of relations collected=%o\",#gelin_relation_alg_integer_seq;
for i in [1..#gelin_relation_alg_integer_seq] do
	i1:=ideal<ok|gelin_relation_alg_integer_seq[i]>;
	//i2:=&*[ideal<ok|gelin_relation_prime_ideal_seq_of_seq[i][j]>^gelin_relation_exponents_integer_seq_of_seq[i][j] : j in [1..#gelin_relation_exponents_integer_seq_of_seq[i]]];
	Append(~gelin_relation_seq,i1);
	/*if(i1 ne i2) then
		printf \"\n relation %o not valid\",i;break;
	elif( i eq #gelin_relation_alg_integer_seq) then
		printf \"ALL RELATIONS VALID\";
		if(#SequenceToSet(gelin_relation_seq) eq #gelin_relation_seq) then
			printf \"\n relations are distinct\";
			PrintFile(\"details.txt\",\"relations are distinct\");
		else
			printf \"\nrelations are NOT distinct\";
			PrintFile(\"details.txt\",\"relations are NOT distinct\");
			printf \"\n total number of relations=%o\",#gelin_relation_seq;
			printf \"\n number of distinct relations=%o\",#SequenceToSet(gelin_relation_seq);
			printf \"\n in terms of exponents distinct EXPONENTS=%o\",#SequenceToSet(gelin_relation_exponents_integer_seq_of_seq);
		end if;
	end if;*/
end for;


if(#SequenceToSet(gelin_relation_seq) eq #gelin_relation_seq) then
			printf \"\n relations are distinct\";
			PrintFile(\"details.txt\",\"relations are distinct\");
		else
			printf \"\nrelations are NOT distinct\";
			PrintFile(\"details.txt\",\"relations are NOT distinct\");
			printf \"\n total number of relations=%o\",#gelin_relation_seq;
			printf \"\n number of distinct relations=%o\",#SequenceToSet(gelin_relation_seq);
			printf \"\n in terms of exponents distinct EXPONENTS=%o\",#SequenceToSet(gelin_relation_exponents_integer_seq_of_seq);
		end if;
PrintFile(\"details.txt\",\"total number of relations=\");
PrintFile(\"details.txt\",#gelin_relation_seq);
PrintFile(\"details.txt\",\"number of distinct relations=\");
PrintFile(\"details.txt\",#SequenceToSet(gelin_relation_seq));
">>$verifying_file
wait
magma $verifying_file
wait
