###################################################
# INPUTS
###################################################
# Basic Info
	super_path="/lustre/scratch/rschanta/"
	work_dir="/work/thsu/rschanta/RTS/"
	run_name="debug_run_66"
	count="4"
# Partition
	par="standard"
# Tasks per Node
	tpn="32"
# Version of FUNWAVE
	vs="3.6"
# Module of FUNWAVE
	mod="REG"
# Mail-User (for Slurm)
	email="rschanta@udel.edu"
# List of analysis functions (enter "{}" for no functions)
	f_list="{'new_ska'}"

	

###################################################
# SETUP
###################################################
## Load in bash functions
export work_dir
	. "${work_dir}functions/bash-utility/get_bash.sh"
## Path to functions
    w="${work_dir}functions"
## Path to FUNWAVE executable
	fun_ex="${work_dir}funwave/v${vs}/exec/FW-${mod}"
## Make log and batch folders, get their names
	create_batch_folders $run_name
	slurm_dir=$(get_slurm_dir "$run_name")
	batch_dir=$(get_batch_dir "$run_name")

###################################################
# GENERATE INPUT FILES
###################################################
## Batch script name
	fileID="GEN" #identifier for script
	file_name="${batch_dir}${fileID}_${run_name}.qs"
## Create a basic batch script
	create_batch_basic $file_name $par $tpn
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email
## Add onto template
	cat <<EOF >> $file_name
	## Load in bash functions and VALET packages
		. "${work_dir}functions/bash-utility/get_bash.sh"
		vpkg_require matlab
	## Run Generation Script
		run_MATLAB_script "./${run_name}/${run_name}.m" "$w"
EOF
## Run the script and get Job ID
	IDG=$(run_batch "$file_name")

###################################################
# RUN FUNWAVE INPUTS IN PARALLEL, CALCULATE 
# STATISTICS, AND COMPRESS
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
## Add onto template
	cat <<EOF >> $file_name
		## Load in bash functions and VALET packages
			. "${work_dir}functions/bash-utility/get_bash.sh"
			vpkg_require openmpi
			vpkg_require matlab
		## Get input file name
			input_file=\$(get_input_dir "$super_path" "$run_name" "\$SLURM_ARRAY_TASK_ID")
		## Run FUNWAVE
			\${UD_MPIRUN} "$fun_ex" "\$input_file"
		## Compress outputs from run to single structure, calculate skew and asymmetry too
			run_comp_i ${super_path} ${run_name} "\$SLURM_ARRAY_TASK_ID" "$f_list" "$w"
		## Delete raw files from run
			# rm_raw_out_i ${super_path} ${run_name} "\$SLURM_ARRAY_TASK_ID"
EOF
## Run the script and get Job ID
	IDP=$(run_batch "$file_name")


