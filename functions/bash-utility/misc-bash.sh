#########################################################
# get_input_dir
#	- gets the input folder associated with a trial under
#     a given run (eg- input_00004) for use in a 
#	  slurm array script
#########################################################
function get_input_dir {
## Arguments
	slurm_array_number=$1
	
## Construct path to input directory
	in_dir="${SP}${RN}/inputs/"
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
	slurm_array_number=$1
## Construct path to output directory
	in_dir="${SP}${RN}/inputs/"
## Fix trial number from slurm array number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct name of ouput directory
	out_i_dir="${SP}${RN}/outputs-raw/out_${tri_no}/"
## Delete Directory
	rm -rf "$out_i_dir" 
}

#########################################################
# export_env
#	- export environment variables to shell for session
#
#########################################################
function export_vars {
## Arguments
	## SUPER_PATH
		SP=$1
	## WORK_DIR
		WD=$2
	## RUN_NAME
		RN=$3
	## EMAIL ADDRESS
		EM=$4
	## Path to functions
		FCP="${WD}functions"

	export SP WD RN EM FCP

}

