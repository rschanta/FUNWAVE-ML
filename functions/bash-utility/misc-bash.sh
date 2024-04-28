#########################################################
# get_input_dir
#	- gets the input folder associated with a trial under
#     a given run (eg- input_00004) for use in a 
#	  slurm array script
#########################################################
function get_input_dir {
## Arguments
	super_path=$1
	run_name=$2
	slurm_array_number=$3
	
## Construct path to input directory
	in_dir="${super_path}${run_name}/inputs/"
## Fix trial number from slurm array number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct and echo input_file name
	input_file="${in_dir}input_${tri_no}.txt"
	echo "${input_file}"
}