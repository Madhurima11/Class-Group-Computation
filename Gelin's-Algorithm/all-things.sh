#field
#size
#bach bound or not
# fill initially
echo " "
echo " will do initial work"
bash initially-required-values.sh
wait
echo " "
echo " will compute factor base"
magma factor-base-comp.m &
wait
echo " "
echo " will do gathering of relations"
bash par-gelin-gathering-relations.sh
wait
echo " "
echo " will verify relations"
magma gelin-verify-all-relations.m &
wait
echo " "
echo " will see output files"
bash view-relation-files.sh > out-view-relations.dat
wait
mv out-view-relations.dat output_gelin_folder_relations/

