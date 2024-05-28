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

#########################################################
# rm_raw_out_i
#	- delete the raw data from a FUNWAVE trial run in the
#     `out_XXXXX` folder
#########################################################
function rm_raw_out_i {
## Arguments
	super_path=$1
	run_name=$2
	slurm_array_number=$3
## Construct path to output directory
	in_dir="${super_path}${run_name}/inputs/"
## Fix trial number from slurm array number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct name of ouput directory
	out_i_dir="${super_path}${run_name}/outputs-raw/out_${tri_no}/"
## Delete Directory
	rm -rf "$out_i_dir" 
}