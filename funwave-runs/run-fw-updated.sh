###################################################
# INPUTS
###################################################
# Basic Info
	super_path="/lustre/scratch/rschanta/"
	work_dir="/work/thsu/rschanta/RTS/"
	run_name="trial_8"
	count="4"
# Partition
	par="thsu"
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
. "${work_dir}functions/utility/bash-utils.sh"
. "${work_dir}functions/utility/sbatch-slurm-utils2.sh"



## Make log and batch folders, get their names
create_batch_folders $run_name
slurm_dir=$(get_slurm_dir "$run_name")
batch_dir=$(get_batch_dir "$run_name")



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
	. "${work_dir}functions/utility/bash-utils.sh"
	vpkg_require matlab

## Run Generation Script
	run_MATLAB_script "./${run_name}/${run_name}.m"
EOF

# Run the script
IDG=$(run_batch "$file_name")

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
	. "${work_dir}functions/utility/bash-utils.sh"
	. /opt/shared/slurm/templates/libexec/openmpi.sh
	vpkg_require openmpi
	vpkg_require matlab

## FUNWAVE Executable Path
	fun_ex="${work_dir}funwave/v${vs}/exec/FW-${mod}"
	echo "\$fun_ex"

## Get input file name
	input_file=\$(get_input_dir "$super_path" "$run_name" "\$SLURM_ARRAY_TASK_ID")
	echo "Before Input File"
	echo "\$input_file"
	echo "After Input File"

## Run FUNWAVE
	\${UD_MPIRUN} "\$fun_ex" "\$input_file"

## Compress outputs from run to single structure
	run_compress_out_i ${super_path} ${run_name} "\$SLURM_ARRAY_TASK_ID"

#rm -rf "${super_path}${run_name}/outputs-raw/out_\$(printf "%05d" \$SLURM_ARRAY_TASK_ID)/"

EOF

IDP=$(run_batch "$file_name")


###################################################
# COMPRESS ALL TO SINGLE STRUCTURE AND CLEAN
###################################################
# Batch script name
	fileID="COMP"
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a batch script with a dependency
	create_batch_dep $file_name $par $tpn $IDP $dep $arr
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email
	


## BODY OF FILE
cat <<EOF >> $file_name
## Load in utilities and VALET
	. "${work_dir}functions/utility/bash-utils.sh"
	vpkg_require matlab

## Compress outputs from all runs to a single structure
args="'${super_path}','${run_name}'"
run_compress_out \$args

## Keep for now
#rm -rf "${super_path}${run_name}/outputs-proc/"
rm -rf "${super_path}${run_name}/outputs-raw/"
EOF

ID_Comp=$(sbatch --parsable $file_name)

###################################################
# COPY RESULTS TO WORK DIRECTORY
###################################################
# Batch script name
	fileID="COPY"
	file_name="${batch_dir}${fileID}_${run_name}.qs"
# Create a batch script with a dependency
	create_batch_dep $file_name $par $tpn $IDP $dep $arr
# Set names in batch script
	set_slurm_names $file_name $fileID $slurm_dir $run_name $email


## BODY OF FILE
cat <<EOF >> $file_name
cp "${super_path}${run_name}/inputs.mat" "./${run_name}/inputs.mat"
cp "${super_path}${run_name}/outputs.mat" "./${run_name}/outputs.mat"
EOF

ID_Copy=$(sbatch --parsable $file_name)