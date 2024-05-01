# Generate Inputs

The following code snippet as part of ***run-fw.sh*** is used to generate the input files:

```bash
###################################################
# GENERATE INPUT FILES
###################################################
# Batch script name
	fileID="GEN" #identifier for script
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a basic batch script
	create_batch_basic $file_name $par $tpn
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email



cat <<EOF >> $file_name
## Load in utilities and VALET
. "${work_dir}functions/bash-utility/slurm-bash.sh"
. "${work_dir}functions/bash-utility/matlab-bash.sh"
. "${work_dir}functions/bash-utility/misc-bash.sh"
	vpkg_require matlab

## Run Generation Script
	run_MATLAB_script "./${run_name}/${run_name}.m" "$w"
EOF

# Run the script
IDG=$(run_batch "$file_name")
```

Here, the name of the file is generated and a default batch script is generated using the basic 
template `create_batch` as found in the ***sbatch-slurm-utils.sh*** script.

Then, the necessary lines are concatenated onto the default template. Here, we need to get MATLAB
via VALET and then run the script corresponding to the run name. The helper function `run_MATLAB_script`
from `bash-utils.sh` is used for this.

Finally, the script is run via `sbatch`. The `run_batch` helper function from ***sbatch-slurm-utils.sh*** is 
used for this, which returns the **job-id**, which we'll need for other scripts