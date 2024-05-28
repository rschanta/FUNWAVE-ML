###################################################
# INPUTS
###################################################
# Basic Info
	# Edit
	super_path="/lustre/scratch/rschanta/"
	work_dir="/work/thsu/rschanta/RTS/"
	run_name="model_run_4"
	count="4000"
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
	

###################################################
# SETUP
###################################################
## Load in Bash Utilities

. "${work_dir}functions/bash-utility/slurm-bash.sh"
. "${work_dir}functions/bash-utility/matlab-bash.sh"
. "${work_dir}functions/bash-utility/misc-bash.sh"

## Directory for functions
w="${work_dir}functions"


## Make log and batch folders, get their names
	#create_batch_folders $run_name
	slurm_dir=$(get_slurm_dir "$run_name")
	batch_dir=$(get_batch_dir "$run_name")






###################################################
# COMPRESS SKEW AND ASYMMETRY
###################################################
# Batch script name
	fileID="SKA" #identifier for script
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a basic batch script
	create_batch_basic $file_name $par $tpn
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email
	


## BODY OF FILE
cat <<EOF >> $file_name
## Load in utilities and VALET
. "${work_dir}functions/bash-utility/slurm-bash.sh"
. "${work_dir}functions/bash-utility/matlab-bash.sh"
. "${work_dir}functions/bash-utility/misc-bash.sh"
	vpkg_require matlab

## Calculate skew and asymmetry
	run_comp_ska $super_path $run_name $work_dir


EOF

ID_Ska=$(sbatch --parsable $file_name)

