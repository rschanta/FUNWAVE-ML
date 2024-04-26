#########################################################
# CREATE FOLDERS FOR .QS SCRIPTS AND LOG FILES
#########################################################
function create_batch_folders {
run_name=$1

slurm_dir=".\/${run_name}\/slurm_logs\/"
batch_dir="./${run_name}/batch-scripts/"
mkdir "./${run_name}/slurm_logs/"
mkdir "./${run_name}/batch-scripts/"

}

#########################################################
# CREATE A BASIC BATCH SCRIPT
#########################################################

function create_batch {
## Specify Arguments
file_path=$1
job_name=$2
partition=$3
tasks_per_node=$4

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

# Write the content to my_file.sh
echo "$FILE_CONTENT" > "$1"
}

#########################################################
# CREATE A BATCH SCRIPT WITH A DEPENDENCY
#########################################################

function create_batch_d {
## Specify Arguments
file_path=$1
job_name=$2
partition=$3
tasks_per_node=$4
dep=$5

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
#SBATCH --dependency=afterok:${dep}
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

# Write the content to my_file.sh
echo "$FILE_CONTENT" > "$1"
}

#########################################################
# CREATE A BATCH SCRIPT WITH AN ARRAY
#########################################################

function create_batch_a {
## Specify Arguments
file_path=$1
job_name=$2
partition=$3
tasks_per_node=$4
arr=$5

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
#SBATCH --dependency=afterok:${dep}
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

# Write the content to my_file.sh
echo "$FILE_CONTENT" > "$1"
}

#########################################################
# CREATE A BATCH SCRIPT WITH AN ARRAY AND A DEPENDENCY
#########################################################

function create_batch_ad {
## Specify Arguments
file_path=$1
job_name=$2
partition=$3
tasks_per_node=$4
dep=$5
arr=$6

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

# Write the content to my_file.sh
echo "$FILE_CONTENT" > "$1"
}

#########################################################
# RUN A BATCH SCRIPT AND GET THE ID
#########################################################
function run_batch {
	file_name=$1
    local ID=$(sbatch --parsable ${file_name})
    echo "$ID"
}