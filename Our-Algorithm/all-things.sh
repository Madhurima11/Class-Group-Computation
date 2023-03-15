#change field_now.m
# find validity of k
#fill threads-and-relations.sh
magma find-validity-of-k.m
wait
nano threads-and-relations.sh
wait
magma factor-base-below-bach-bound-random-seq-writing.m 
wait
bash par-precomputing.sh
wait
bash par-gathering-relations.sh
wait
bash view-relation-files.sh > out-view-relation-files.dat
mv out-view-relation-files.dat output_folder_relations/
