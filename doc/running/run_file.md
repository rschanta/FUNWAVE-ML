# Run File

The following code snippet is used to send in an sbatch SLURM array script that will run 
through all the FUNWAVE inputs in parallel as much as possible on the given partition:

```bash
###################################################
# RUN FUNWAVE INPUTS IN PARALLEL, COMPRESS
###################################################
# Batch script name
	fileID="RUN" #identifier for script
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a batch script with an array and a dependency
	arr="1-${count}"
	create_batch_arr_dep $file_name $par $tpn $IDG $dep $arr 
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email
	set_slurm "output" "${slurm_dir}RUN_out_%a.out" $file_name
	set_slurm "error" "${slurm_dir}RUN_err_%a.out" $file_name



## BODY OF FILE
cat <<EOF >> $file_name
## Load in utilities and VALET
. "${work_dir}functions/bash-utility/slurm-bash.sh"
. "${work_dir}functions/bash-utility/matlab-bash.sh"
. "${work_dir}functions/bash-utility/misc-bash.sh"
	. /opt/shared/slurm/templates/libexec/openmpi.sh
	vpkg_require openmpi
	vpkg_require matlab

## FUNWAVE Executable Path
	fun_ex="${work_dir}funwave/v${vs}/exec/FW-${mod}"
	echo "\$fun_ex"

## Get input file name
	input_file=\$(get_input_dir "$super_path" "$run_name" "\$SLURM_ARRAY_TASK_ID")

## Run FUNWAVE
	\${UD_MPIRUN} "\$fun_ex" "\$input_file"

## Compress outputs from run to single structure
	run_compress_out_i ${super_path} ${run_name} "\$SLURM_ARRAY_TASK_ID" "$work_dir"

EOF

IDP=$(run_batch "$file_name")
```

Here, the name of the file is generated and a parallel batch script is generated using the 
template `create_batch_ad` as found in the ***sbatch-slurm-utils.sh*** script.

Then, the necessary lines are concatenated onto the template. Here, we need to get MATLAB
via VALET as well as openmpi. We also need to specify the path to the FUNWAVE executable for **fun_ex**.
We need the directory where all the inputs are stored <ins>*super_path/run_name/inputs/*</ins>

Then, the specific input file number is constructed from the **SLURM_ARRAY_TASK_ID** 
(see section on slurm arrays for further explanation).

FUNWAVE is then run using the `UD_MPIRUN` command.

Next, the `compress_out_i` helper function is used to compress all of the outputs from the FUNWAVE trial
into a single matlab structure, saving the file in <ins>*outputs-proc*</ins>. 

Finally, the batch script is run and the ID is gotten as before.