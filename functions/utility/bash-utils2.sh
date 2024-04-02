# bash-utils2.sh
#########################################################
# BASH utilities that are a little more specific

. "/work/thsu/rschanta/RTS/functions/utility/bash-utils.sh"
# THIS IS A COMMENT


## Create Generation File
function create_generation_file {
	generation_file=$1
	slurm_dir=$2
	
	set_slurm "job-name" "GEN" $1
	set_slurm "partition" "thsu" $1
	set_slurm "output" ""$2"GEN_out.out" $1
	set_slurm "error" ""$2"GEN_err.out" $1
	set_slurm "tasks-per-node" "32" $1
	remove_slurm "array" $2
	remove_slurm "dependency" $2
}
generation_file="${batch_dir}GEN_${run_name}.qs"
create_batch_script $generation_file
	

## Create Run File
function create_run_file {
	run_file=$1
	slurm_dir=$2
	count=$3
	ID_GEN=$4
	
	set_slurm "job-name" "RUN__%a.out" $1
	set_slurm "partition" "thsu" $1
	set_slurm "output" ""$2"RUN_out_%a.out" $1
	set_slurm "error" ""$2"RUN_err_%a.out" $1
	set_slurm "tasks-per-node" "32" $1
	set_slurm "array" 1-$3 "$parallel_file"
	set_slurm "dependency" "afterok:$4" $1
}

create_batch_script $parallel_file
	set_slurm "job-name" "RUN_${run_name}" $parallel_file
	set_slurm "partition" "thsu" $parallel_file
	set_slurm "output" "${slurm_dir}RUN_out_%a.out" $parallel_file
	set_slurm "error" "${slurm_dir}RUN_err_%a.out" $parallel_file
	set_slurm "tasks-per-node" "32" $parallel_file
	set_slurm "array" 1-$count "$parallel_file"
	set_slurm "dependency" "afterok:$ID_Gen" $parallel_file
