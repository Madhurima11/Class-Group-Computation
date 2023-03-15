nthreads=$(<nthreads.txt)
lo=1
precomputed_table_length=$(<approx_length_of_table.txt)

total=$precomputed_table_length
small_step=$((($total-$lo+1)/$nthreads))
nbigsteps=$((($total-$lo+1)-($nthreads*$small_step)))

rm -r part_table_folder/
rm -r output_folder_precomputing/

for((i=1; i<=$nbigsteps; i++))
do	
	hi=$(($lo+$small_step))
	output_file=out-precomputing-thread_id-$i.dat
	file_table_part=table-part-$i.m
	magma strlo:=$lo strhi:=$hi file_table_part:=$file_table_part precomputing.m > $output_file &
	lo=$(($hi+1))
done
for((i=$(($nbigsteps+1)); i<=$nthreads; i++))
do	
	hi=$(($lo+$small_step-1))
	output_file=out-precomputing-thread_id-$i.dat
	file_table_part=table-part-$i.m
	magma strlo:=$lo strhi:=$hi file_table_part:=$file_table_part precomputing.m > $output_file &
	lo=$(($hi+1))    
done
wait

mkdir part_table_folder/
mv table-part-* part_table_folder/

mkdir output_folder_precomputing/
mv out-precomputing-thread_id-* output_folder_precomputing/

wait

table_making_file=get-full-table.m
echo "load \"field_now.m\";">$table_making_file
echo "seq:=[];">>$table_making_file
for((i=1; i<=$nthreads; i++))
do
	echo "load \"part_table_folder/table-part-$i.m\";">>$table_making_file 
	echo "seq:=seq cat part_precomputed_table;">>$table_making_file
done
echo "cart:=car<Parent(seq[1][1]),Parent(seq[1][2])>;	
tt:={@[cart!<seq[i][1],seq[i][2]>] : i in [1..#seq]@};
seq:=SetToSequence(tt);
delete tt;
printf \"\n distinct terms of seq=%o\",#seq;
precomputed_table:=seq;
printf \"\n #precomputed_table=%o\",#precomputed_table;	
PrintFile(\"table_precomputed.m\",\"precomputed_table:=\":Overwrite:=true);
PrintFile(\"table_precomputed.m\",precomputed_table);
PrintFile(\"table_precomputed.m\",\";\");">>$table_making_file
wait
magma get-full-table.m &
wait 
