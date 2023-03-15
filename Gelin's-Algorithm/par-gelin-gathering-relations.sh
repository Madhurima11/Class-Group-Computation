nthreads=$(<nthreads.txt)
lo=1
number_of_relations_wanted=$(<number_of_relations_wanted.txt)

total=$number_of_relations_wanted
small_step=$((($total-$lo+1)/$nthreads))
nbigsteps=$((($total-$lo+1)-($nthreads*$small_step)))

rm -r part_gelin_relation_folder/
rm -r output_gelin_folder_relations/
t0=$(date +"%s")
for((i=1; i<=$nbigsteps; i++))
do	
	hi=$(($lo+$small_step))
	output_file=out-gelin_gathering-relations-thread-$i.dat
		file_relation_alg_integer_seq=file_gelin_relation_alg_integer_seq-thread-$i.m
	file_relation_prime_ideal_seq_of_seq=file_gelin_relation_prime_ideal_seq_of_seq-thread-$i.m
			file_relation_exponents_integer_seq_of_seq=file_gelin_relation_exponents_integer_seq_of_seq-thread-$i.m
	magma strlo:=$lo strhi:=$hi strthread_id:=$i strnthreads:=$nthreads file_relation_alg_integer_seq:=$file_relation_alg_integer_seq file_relation_prime_ideal_seq_of_seq:=$file_relation_prime_ideal_seq_of_seq file_relation_exponents_integer_seq_of_seq:=$file_relation_exponents_integer_seq_of_seq gelin_gathering_relations.m > $output_file &
	lo=$(($hi+1))
done
for((i=$(($nbigsteps+1)); i<=$nthreads; i++))
do	
	hi=$(($lo+$small_step-1))
	output_file=out-gelin_gathering-relations-thread-$i.dat
	file_relation_alg_integer_seq=file_gelin_relation_alg_integer_seq-thread-$i.m
	file_relation_prime_ideal_seq_of_seq=file_gelin_relation_prime_ideal_seq_of_seq-thread-$i.m
			file_relation_exponents_integer_seq_of_seq=file_gelin_relation_exponents_integer_seq_of_seq-thread-$i.m
	magma strlo:=$lo strhi:=$hi strthread_id:=$i strnthreads:=$nthreads file_relation_alg_integer_seq:=$file_relation_alg_integer_seq file_relation_prime_ideal_seq_of_seq:=$file_relation_prime_ideal_seq_of_seq file_relation_exponents_integer_seq_of_seq:=$file_relation_exponents_integer_seq_of_seq gelin_gathering_relations.m > $output_file &
	lo=$(($hi+1))    
done

wait
t1=$(date +"%s")
diff=$(($t1-$t0))
echo "$(($diff / 60)) minutes and $(($diff % 60))seconds elapsed">details.txt 

mkdir part_gelin_relation_folder/
mv file_gelin_relation_alg_integer_seq-thread-* part_gelin_relation_folder/
mv file_gelin_relation_prime_ideal_seq_of_seq-thread-* part_gelin_relation_folder/
mv file_gelin_relation_exponents_integer_seq_of_seq-thread-* part_gelin_relation_folder/

mkdir output_gelin_folder_relations/
mv out-gelin_gathering-relations-thread* output_gelin_folder_relations/
