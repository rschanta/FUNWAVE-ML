# bash-utils.sh
#########################################################

function run_MATLAB_script {
	matlab -nodisplay -nosplash -nodesktop -r "run('"$1"');exit;"
}

function run_MATLAB_function {
    path=$1
	func=$2
	args=$3
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}

function run_compress_out_i {
	path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
	func="compress_out_i"
	args=$1
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}

function run_compress_out {
	path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
	func="compress_out"
	args=$1
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}


#########################################################

#########################################################
# CREATE DEFAULT BATCH SCRIPTS
#########################################################

# Define the function
function create_batch_script {
MY_FILE_CONTENT=$(cat <<EOF
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --job-name=BATCH_SCRIPT
#SBATCH --partition=standard
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --array=1-3
#SBATCH --dependency=afterok:JOBID
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#

. /work/thsu/rschanta/RTS/functions/utility/bash-utils.sh
#

EOF
)

# Write the content to my_file.sh
echo "$MY_FILE_CONTENT" > "$1"
}


#########################################################
# SET/REMOVE SPECIFIC VARIABLES
#########################################################
function set_slurm {
	NEW_LINE="#SBATCH --"$1"="$2""
	sed -i "s/.*"$1".*/$NEW_LINE/" "$3"
}

function remove_slurm {
	sed -i "/"$1"/d" "$2"
}

