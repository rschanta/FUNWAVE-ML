# bash-utils.sh
#########################################################



#########################################################
# FUNCTIONS TO RUN MATLAB SCRIPTS AND FUNCTIONS
#########################################################
function run_MATLAB_script {
	# Runs a MATLAB script specified 'file_name.mat' in Caviness
	matlab -nodisplay -nosplash -nodesktop -r "run('"$1"');exit;"
}

function run_MATLAB_function {
	# Runs a MATLAB function named 'func' stored at path 'path' 
	# with arguments specified in string 'args'
	
	# For example, calling an interpolation function called 
	# 'ínterp3' with arguments x, v, xq, and 'spline' would have
		# path = '/path_to_function_dir'
		# func = 'interp3'
		# args = "x,v,'linear'"
		
    path=$1
	func=$2
	args=$3
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}


#########################################################
# FUNCTIONS TO RUN SPECIFIC MATLAB FUNCTIONS/SCRIPTS
#########################################################
function run_compress_out_i {
	# Runs the 'compress_out_i' function to compress the outputs
	# of an individual FUNWAVE wave to a single structure
	
	# args = '"super_path","run_name","tri_no"'
	
	path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
	func="compress_out_i"
	args=$1
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}

function run_compress_out {
	# Runs the 'compress_out' function to compress the outputs of 
	# all FUNWAVE runs from a given trial to a single structure,
	# memory permitting
	
	# args = '"super_path','run_name'"
	
	path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
	func="compress_out"
	args=$1
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}




#########################################################
# CREATE DEFAULT BATCH SCRIPTS
#########################################################


function create_batch_script {
	# Creates a batch script for the UD CAVINESS HPC system
	# with the text specified below in 'batch_contents'. 
	# Care should be taken to edit as needed to personalize/
	# edit any fields
	
	# batch_script_name = "my_batch_script.qs" (for example)
	
	batch_script_name=$1

batch_contents=$(cat <<EOF
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
echo "$batch_contents" > "$batch_script_name"
}


#########################################################
# EDIT DEFAULT BATCH SCRIPTS
	# The following functions take a .qs batch script 
	# created by 'create_batch_script' and edit lines of
	# it as needed
#########################################################


function set_slurm {
	# Changes a slurm setting in a previously created 
	# batch script
	
	# For example, let's take a batch script called 
	# 'run_sim.qs' and change the 'job-name' setting
	# to 'new_job_name'
	
		# set_slurm "job-name" "new_job_name" "run_sim.qs"
		
	setting=$1
	value=$2
	batch_file=$3
	
	NEW_LINE="#SBATCH --"$setting"="$value""
	sed -i "s/.*"$setting".*/$NEW_LINE/" "$batch_file"
}

function remove_slurm {
	# Removes a slurm setting from a preiviously created
	# batch script
	
	# For example, let's take a batch script called 
	# 'run_sim2.qs' and remove the 'dependency' option
	# since we may not need it to wait on anything
		
		# remove_slurm "dependency" "run_sim2.qs"
	
	setting=$1
	batch_file=$2
	
	sed -i "/"$setting"/d" "$batch_file"
}

