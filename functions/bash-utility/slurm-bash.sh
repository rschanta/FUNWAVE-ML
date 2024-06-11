#########################################################
# create_batch_folders
#	- creates directories to store the slurm logs and 
#     batch scripts associated with a run.
#########################################################
function create_batch_folders {
## Arguments

## Make directories
	mkdir -p "${WD}funwave-runs/${RN}"
	mkdir -p "${WD}funwave-runs/${RN}/slurm_logs/"
	mkdir -p "${WD}funwave-runs/${RN}/batch-scripts/"

}

#########################################################
# get_slurm_dir
#	- gets the name of the directory where all the slurm
#     logs are set to generate associated with a run.
#########################################################
function get_slurm_dir {
## Arguments
## Return the directory name
    local slurm_dir="${WD}funwave-runs/${RN}/slurm_logs/"
    echo "$slurm_dir"
}

#########################################################
# get_batch_dir
#	- gets the name of the directory with all the batch
#	  scripts associated with a run.
#########################################################
function get_batch_dir {
## Arguments
## Return the directory name
    local batch_dir="${WD}funwave-runs/${RN}/batch-scripts/"
    echo "$batch_dir"
}

#########################################################
# create_batch_basic
#	- creates a basic batch script under a given name
#     specifying partition and tasks-per-node, with 
#     no slurm arrays or dependencies.
#########################################################
function create_batch_basic {
## Arguments
	file_path=$1
	partition=$2
	tasks_per_node=$3

## Contents of the batch script
FILE_CONTENT=$(cat <<EOF
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=${tasks_per_node}
#SBATCH --job-name=${job_name}
#SBATCH --partition=${partition}
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#

EOF
)

# Write the content to the batch script
	echo "$FILE_CONTENT" > "$1"
}

#########################################################
# create_batch_dep
#	- creates a batch script under a given name
#     specifying partition and tasks-per-node, with 
#     a dependency upon some other job (but no array)
#########################################################
function create_batch_dep {
## Arguments
	file_path=$1
	partition=$2
	tasks_per_node=$3
	dep=$4

## Contents of the batch script
FILE_CONTENT=$(cat <<EOF
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=${tasks_per_node}
#SBATCH --job-name=${job_name}
#SBATCH --partition=${partition}
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterany:${dep}
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#

EOF
)

# Write the content to the batch script
	echo "$FILE_CONTENT" > "$1"
}

#########################################################
# create_batch_arr
#	- creates a batch script under a given name
#     specifying partition and tasks-per-node, with 
#     a slurm array specified (but no dependency)
#########################################################
function create_batch_arr {
## Arguments
	file_path=$1
	job_name=$2
	partition=$3
	tasks_per_node=$4
	arr=$5

## Contents of the batch script
FILE_CONTENT=$(cat <<EOF
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=${tasks_per_node}
#SBATCH --job-name=${job_name}
#SBATCH --partition=${partition}
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --array=${arr}
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#

EOF
)

# Write the content to the batch script
	echo "$FILE_CONTENT" > "$1"
}

#########################################################
# create_batch_arr_dep
#	- creates a batch script under a given name
#     specifying partition and tasks-per-node, with 
#     a slurm array and dependency
#########################################################
function create_batch_arr_dep {
## Arguments
	file_path=$1
	partition=$2
	tasks_per_node=$3
	dep=$4
	arr=$5

## Contents of the batch script
FILE_CONTENT=$(cat <<EOF
#!/bin/bash -l
#
#
#SBATCH --nodes=1
#SBATCH --tasks-per-node=${tasks_per_node}
#SBATCH --job-name=${job_name}
#SBATCH --partition=${partition}
#SBATCH --time=7-00:00:00
#SBATCH --output=mylog.out
#SBATCH --error=myfail.out
#SBATCH --mail-user='rschanta@udel.edu'
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --export=ALL
#SBATCH --dependency=afterany:${dep}
#SBATCH --array=${arr}
#
#UD_QUIET_JOB_SETUP=YES
#UD_USE_SRUN_LAUNCHER=YES
#UD_DISABLE_CPU_AFFINITY=YES
#UD_MPI_RANK_DISTRIB_BY=CORE
#UD_DISABLE_IB_INTERFACES=YES
#UD_SHOW_MPI_DEBUGGING=YES
#
#

EOF
)

# Write the content to the batch script
	echo "$FILE_CONTENT" > "$1"
}

#########################################################
# run_batch
#	- run a batch script and return the job ID
#########################################################
function run_batch {
## Arguments
	file_name=$1
## Run using sbatch and parsable flag to get ID
    local ID=$(sbatch --parsable ${file_name})
    echo "$ID"
}

#########################################################
# set_slurm
#	- edit the value of some pre-existing flag in a 
#	  batch script already made
#   -example:
# 		set_slurm "job-name" "new_job_name" "run_sim.qs"
#########################################################
function set_slurm {
## Arguments
	setting=$1
	value=$2
	batch_file=$3

	local valuee=$(echo "$value" | sed 's/[\/%]/\\&/g')
## Define new parameter line and swap out.
	NEW_LINE="#SBATCH --"$setting"="$valuee""
	sed -i "s/.*"$setting".*/$NEW_LINE/" "$batch_file"
}

#########################################################
# remove_slurm
#	- remove some slurm flag from a pre-existing batch
#	  file.
#   -example:
# 		remove_slurm "dependency" "run_sim2.qs"
#########################################################
function remove_slurm {
## Arguments
	setting=$1
	batch_file=$2
## Define new parameter line and swap out.
	sed -i "/"$setting"/d" "$batch_file"
}

#########################################################
# set_slurm_names
#	- set the flags of a SLURM batch script having to do 
#	  with file names and logging, including:

# 		job-name- defaults to {fileID}_{run_name}
# 		output
# 		error
# 		mail-user
#########################################################
function set_slurm_names {
	# Parameters
		fileName=$1
		fileID=$2
		slurm_dir=$3

		local slurm_dire=$(echo "$slurm_dir" | sed 's/[\/%]/\\&/g')
	# Change the slurm settings
		set_slurm "job-name" "${fileID}_${run_name}" $1
		set_slurm "output" "${slurm_dire}${fileID}_out.out" $1
		set_slurm "error" "${slurm_dire}${fileID}_err.out" $1
		set_slurm "mail-user" "$EM" $1

} 