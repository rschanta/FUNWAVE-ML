# Copy Files
The following code snippet is used to copy over the output compressed arrays to the work 
directory.

``` bash
###################################################
# COPY RESULTS TO WORK DIRECTORY
###################################################
# Batch script name
	fileID="COPY"
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a batch script with a dependency
	create_batch_dep $file_name $par $tpn $ID_Comp $dep $arr
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email


## BODY OF FILE
cat <<EOF >> $file_name
	cp "${super_path}${run_name}/inputs.mat" "./${run_name}/inputs.mat"
	cp "${super_path}${run_name}/outputs.mat" "./${run_name}/outputs.mat"
EOF

ID_Copy=$(sbatch --parsable $file_name)
```

Here, a simple batch script with a dependency is made as before, the files are simply copied over
in standard command line commands.