# Generate Inputs

The following code snippet as part of ***run-fw.sh*** is used to generate the input files:

```bash
###################################################
# GENERATE INPUT FILES
###################################################
# Batch File Name
g_file="${batch_dir}GEN_${run_name}.qs"

# Create Default Batch Template, change parameters accordingly
create_batch $g_file "GEN_${run_name}" $par $tpn
	set_slurm "output" "${slurm_dir}GEN_out.out" $generation_file
	set_slurm "error" "${slurm_dir}GEN_err.out" $generation_file

# Add on necessary lines
cat <<EOF >> $g_file
vpkg_require matlab
run_MATLAB_script "./${run_name}/${run_name}.m"
EOF

# Run the script
IDG=$(run_batch "$g_file")
```

Here, the name of the file is generated and a default batch script is generated using the basic 
template `create_batch` as found in the ***sbatch-slurm-utils.sh*** script.

Then, the necessary lines are concatenated onto the default template. Here, we need to get MATLAB
via VALET and then run the script corresponding to the run name. The helper function `run_MATLAB_script`
from `bash-utils.sh` is used for this.

Finally, the script is run via `sbatch`. The `run_batch` helper function from ***sbatch-slurm-utils.sh*** is 
used for this, which returns the **job-id**, which we'll need for other scripts