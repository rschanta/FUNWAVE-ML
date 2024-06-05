# Run File

The following code snippet is used to send in an sbatch SLURM array script that will run 
through all the FUNWAVE inputs in parallel as much as possible on the given partition:

```bash
###################################################
# RUN FUNWAVE INPUTS IN PARALLEL, CALCULATE 
# STATISTICS, AND COMPRESS
###################################################
# Batch script name
	fileID="RUN" #identifier for script
	file_name="${batch_dir}${fileID}_${RN}.qs"
# Create a batch script with an array and a dependency
	arr="1-${count}"
	create_batch_arr_dep $file_name $par $tpn $IDG $dep $arr 
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $email
	set_slurm "output" "${slurm_dir}RUN_out_%a.out" $file_name
	set_slurm "error" "${slurm_dir}RUN_err_%a.out" $file_name
## Add onto template
	cat <<EOF >> $file_name
		## Load in bash functions and VALET packages
			export WORK_DIR=${WORK_DIR}
			. "${WORK_DIR}functions/bash-utility/get_bash.sh"
			export_vars "$SUPER_PATH" "$WORK_DIR" "$RUN_NAME" "$EMAIL_ADD"
			vpkg_require openmpi
			vpkg_require matlab
		## Get input file name
			input_file=\$(get_input_dir "\$SLURM_ARRAY_TASK_ID")
		## Run FUNWAVE
			\${UD_MPIRUN} "$fun_ex" "\$input_file"
		## Compress outputs and get statistics
			run_comp_i "\$SLURM_ARRAY_TASK_ID" "$f_list"
		## Delete raw files from run
			rm_raw_out_i "\$SLURM_ARRAY_TASK_ID"
EOF
## Run the script and get Job ID
	IDP=$(run_batch "$file_name")
    echo "Run script successfully created!"
## Display Success
    echo "Job submitted!"
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