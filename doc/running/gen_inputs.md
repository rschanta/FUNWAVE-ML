# Generate Inputs

The following code snippet as part of ***run-fw.sh*** is used to generate the input files:

```bash
###################################################
# GENERATE INPUT FILES
###################################################
## Batch script name
	fileID="GEN" #identifier for script
	file_name="${batch_dir}${fileID}_${RN}.qs"
## Create a basic batch script
	create_batch_basic $file_name $par $tpn
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $email
## Add onto template
	cat <<EOF >> $file_name
	## Load in bash functions and VALET packages
		export WORK_DIR=${WORK_DIR}
		. "${WORK_DIR}functions/bash-utility/get_bash.sh"
		export_vars "$SUPER_PATH" "$WORK_DIR" "$RUN_NAME" "$EMAIL_ADD"
		vpkg_require matlab
	## Run Generation Script
		run_MATLAB_script "${WD}funwave-runs/${RN}/${RN}.m"
EOF
## Run the script and get Job ID
	IDG=$(run_batch "$file_name")
    echo "Generation script successfully created!"
```

Here, the name of the file is generated and a default batch script is generated using the basic 
template `create_batch` as found in the ***sbatch-slurm-utils.sh*** script.

Then, the necessary lines are concatenated onto the default template. Here, we need to get MATLAB
via VALET and then run the script corresponding to the run name. The helper function `run_MATLAB_script`
from `bash-utils.sh` is used for this.

Finally, the script is run via `sbatch`. The `run_batch` helper function from ***sbatch-slurm-utils.sh*** is 
used for this, which returns the **job-id**, which we'll need for other scripts