nthreads=90
for((i=1;  i<=18; i++))
do
	j=$(($i*5))
	echo "For the $j th file"
	tail -13 output_gelin_folder_relations/out-gelin_gathering-relations-thread-$j.dat
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	echo " "
	echo " "
	echo " "
done
