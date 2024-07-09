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
	par="standard"
# Tasks per Node
	tpn="32"
# Version of FUNWAVE
	vs="3.6H"
# Module of FUNWAVE
	mod="REG"
# List of analysis functions (enter "{}" for no functions)
	f_list="{'new_ska'}"

	

###################################################
# SETUP
###################################################
## Load in bash functions
	. "${WORK_DIR}functions/bash-utility/get_bash.sh"
## Export relevant environment variables
	export_vars "$SUPER_PATH" "$WORK_DIR" "$RUN_NAME" "$EMAIL_ADD"
## Path to FUNWAVE executable
	fun_ex="${WD}funwave/v${vs}/exec/FW-${mod}"
## Make log and batch folders, get their names
	create_batch_folders $RN
	slurm_dir=$(get_slurm_dir "$RN")
	batch_dir=$(get_batch_dir "$RN")
    echo "File Setup Successful!"

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
		vpkg_require matlab/r2023b
	## Run Generation Script
		run_gen 
EOF
## Run the script and get Job ID
	IDG=$(run_batch "$file_name")
    echo "Generation script successfully created!"
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
			vpkg_require matlab/r2023b
		## Get input file name
			input_file=\$(get_input_dir "\$SLURM_ARRAY_TASK_ID")
		## Run FUNWAVE
			\${UD_MPIRUN} "$fun_ex" "\$input_file"
		## Compress outputs from run to single structure, calculate skew and asymmetry too
			run_comp_i "\$SLURM_ARRAY_TASK_ID" "$f_list"
		## Create an animation
			run_animate_eta "\$SLURM_ARRAY_TASK_ID" 
			run_animate_velocity "\$SLURM_ARRAY_TASK_ID" 
			run_animate_undertow "\$SLURM_ARRAY_TASK_ID" 
		## Delete raw files from run
			#rm_raw_out_i "\$SLURM_ARRAY_TASK_ID"
EOF
## Run the script and get Job ID
	IDP=$(run_batch "$file_name")
    echo "Run script successfully created!"
## Display Success
    echo "Job submitted!"
	echo "Check batch logs/outputs to see if job was successful!"