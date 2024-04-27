# Compress File
The following code snippet is used to compress all of the output structures ***out_XXXXX.mat*** into a 
single structure
```
compress_file="${batch_dir}COMP_${run_name}.qs"
create_batch_script $compress_file
	set_slurm "job-name" "COMP_${run_name}" $compress_file
	set_slurm "partition" "thsu" $compress_file
	set_slurm "output" "${slurm_dir}COMP_out.out" $compress_file
	set_slurm "error" "${slurm_dir}COMP_err.out" $compress_file
	set_slurm "tasks-per-node" "32" $compress_file
	remove_slurm "array" $compress_file
	set_slurm "dependency" "afterok:$ID_Run" $compress_file


## BODY OF FILE
cat <<EOF >> $compress_file
vpkg_require matlab

## Compress outputs from all runs to a single structure
args="'${super_path}','${run_name}'"
run_compress_out \$args

## Delete outputs-raw folder
rm -rf "${super_path}${run_name}/outputs-raw/"
EOF

ID_Comp=$(sbatch --parsable $compress_file)
```

First, the name of the file is constructed an a simple batch script from a template is created. 
Then, neccessary dependencies are concatenated. MATLAB is added, as well and the arguments to `compress_out`
are constructed. The function `run_compress_out` is then run, which is a helper function that runs the 
`compress_out` function.