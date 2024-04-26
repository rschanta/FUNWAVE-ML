# Copy Files
The following code snippet is used to copy over the output compressed arrays to the work 
directory.

```
###################################################
# COPY RESULTS TO WORK DIRECTORY
###################################################
copy_file="${batch_dir}COPY_${run_name}.qs"
create_batch_script $copy_file
	set_slurm "job-name" "COPY_${run_name}" $copy_file
	set_slurm "partition" "thsu" $copy_file
	set_slurm "output" "${slurm_dir}COPY_out.out" $copy_file
	set_slurm "error" "${slurm_dir}COPY_err.out" $copy_file
	set_slurm "tasks-per-node" "32" $copy_file
	remove_slurm "array" $copy_file
	set_slurm "dependency" "afterok:$ID_Comp" $copy_file


## BODY OF FILE
cat <<EOF >> $copy_file
cp "${super_path}${run_name}/inputs.mat" "./${run_name}/inputs.mat"
cp "${super_path}${run_name}/outputs.mat" "./${run_name}/outputs.mat"
EOF

ID_Copy=$(sbatch --parsable $copy_file)
```

Here, a simple batch script with a dependency is made as before, the files are simply copied over
in standard command line commands.