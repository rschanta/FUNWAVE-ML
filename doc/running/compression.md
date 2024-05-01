# Compress File
The following code snippet is used to compress all of the output structures ***out_XXXXX.mat*** into a 
single structure
```
###################################################
# COMPRESS ALL TO SINGLE STRUCTURE AND CLEAN
###################################################
# Batch script name
	fileID="COMP"
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a batch script with a dependency
	create_batch_dep $file_name $par $tpn $ID_Ska $dep $arr
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email
	


## BODY OF FILE
cat <<EOF >> $file_name
## Load in utilities and VALET
. "${work_dir}functions/bash-utility/slurm-bash.sh"
. "${work_dir}functions/bash-utility/matlab-bash.sh"
. "${work_dir}functions/bash-utility/misc-bash.sh"
	vpkg_require matlab

## Compress outputs from all runs to a single structure
	run_compress_out $super_path $run_name $work_dir

## Keep for now
	#rm -rf "${super_path}${run_name}/outputs-proc/"
	rm -rf "${super_path}${run_name}/outputs-raw/"
EOF

ID_Comp=$(sbatch --parsable $file_name)
```

First, the name of the file is constructed an a simple batch script from a template is created. 
Then, neccessary dependencies are concatenated. MATLAB is added, as well and the arguments to `compress_out`
are constructed. The function `run_compress_out` is then run, which is a helper function that runs the 
`compress_out` function.