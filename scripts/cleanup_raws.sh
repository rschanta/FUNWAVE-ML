###################################################
# INPUTS
###################################################
## DIRECTORY SETUP AND NAME
	SUPER_PATH="/lustre/scratch/rschanta/"
	WORK_DIR="/work/thsu/rschanta/RTS/"
	RUN_NAME="ValAll"
	count="20"
	# Mail-User (for Slurm)
	EMAIL_ADD="rschanta@udel.edu"
# Partition
	par="thsu"
# Tasks per Node
	tpn="32"



	

###################################################
# SETUP
###################################################
## Load in bash functions
	. "${WORK_DIR}functions/bash-utility/get_bash.sh"
## Export relevant environment variables
	export_vars "$SUPER_PATH" "$WORK_DIR" "$RUN_NAME" "$EMAIL_ADD"


###################################################
# RUN FUNWAVE INPUTS IN PARALLEL, CALCULATE 
# STATISTICS, AND COMPRESS
###################################################
# Batch script name
	fileID="CLEAN" #identifier for script
	file_name="${batch_dir}${fileID}_${RN}.qs"
# Create a batch script with an array and a dependency
	arr="1-${count}"
	create_batch_arr $file_name $fileID $par $tpn $arr
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
		## Delete raw files from run
			rm_raw_out_i "\$SLURM_ARRAY_TASK_ID"
EOF
## Run the script and get Job ID
	IDP=$(run_batch "$file_name")
    echo "Run script successfully created!"
## Display Success
    echo "Job submitted!"
	echo "Check batch logs/outputs to see if job was successful!"