rm -r output_norm_finding-/

for((i=1; i<=10; i++))
do	
      	output_file=out-norm_finding-$i.dat
	magma norm_finding.m > $output_file &
done

mkdir output_norm_finding-/
mv out-norm_finding-* output_norm_finding-/
