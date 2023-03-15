for((i=1;  i<=25; i++))
do
	j=$(($i*1))
	echo "For the $j th file"
	#tail -2 out-gathering-relations-thread-$j.dat
	#tail -16 output_folder_relations/out-gathering-relations-thread-$j.dat	
	tail -16 output_folder_relations/out-gathering-relations-thread-$j.dat
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	echo " "
	echo " "
	echo " "
done
