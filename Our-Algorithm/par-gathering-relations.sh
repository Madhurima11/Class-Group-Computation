nthreads=$(<nthreads.txt)


rm -r part_relation_folder/
rm -r output_folder_relations/
rm invalid_relations.txt

t0=$(date +"%s")
echo " Yes getting"
for((i=1;  i<=$nthreads; i++))
do	
	#hi=$(($lo+$small_step))
	output_file=out-gathering-relations-thread-$i.dat
	file_relation_alg_integer_seq=file_relation_alg_integer_seq-thread-$i.m			file_relation_prime_ideal_seq_of_seq=file_relation_prime_ideal_seq_of_seq-thread-$i.m
			file_relation_exponents_integer_seq_of_seq=file_relation_exponents_integer_seq_of_seq-thread-$i.m
	magma strthread_id:=$i strnthreads:=$nthreads file_relation_alg_integer_seq:=$file_relation_alg_integer_seq file_relation_prime_ideal_seq_of_seq:=$file_relation_prime_ideal_seq_of_seq file_relation_exponents_integer_seq_of_seq:=$file_relation_exponents_integer_seq_of_seq gathering_relations.m > $output_file &
done
wait
echo "OVER"
t1=$(date +"%s")
diff=$(($t1-$t0))
echo "$(($diff / 60)) minutes and $(($diff % 60))seconds elapsed">details.txt 

mkdir part_relation_folder/
mv file_relation_alg_integer_seq-thread-* part_relation_folder/
mv file_relation_prime_ideal_seq_of_seq-thread-* part_relation_folder/
mv file_relation_exponents_integer_seq_of_seq-thread-* part_relation_folder/

mkdir output_folder_relations/
mv out-gathering-relations-thread-* output_folder_relations/
