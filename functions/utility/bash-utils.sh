# bash-utils.sh
#########################################################



#########################################################
# run_MATLAB_script
#	- runs a given MATLAB script specified by filepath
#########################################################
function run_MATLAB_script {
## Arguments
	
	# Runs a MATLAB script specified 'file_name.mat' in Caviness
	matlab -nodisplay -nosplash -nodesktop -r "run('"$1"');exit;"
}

#########################################################
# run_MATLAB_function
#	- runs a given MATLAB function at a given path with 
#     a string corresponding to its arguments. This is a 
#     a bit clunky, so wrapper functions for individual 
#     MATLAB functions are useful for this.
#	- example: calling an interpolation function called 
#     'ínterp3' with arguments x, v, xq, and 'spline' would
# 			- path = '/path_to_function_dir'
#			- func = 'interp3'
#			- args = "x,v,'linear'"
#########################################################
function run_MATLAB_function {
## Arguments
    path=$1
	func=$2
	args=$3
## cd to path where function is, execute function under arguments
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}


#########################################################
# run_compress_out_i
#	- the 'compress_out_i' function to compress the outputs
#	  to compress the outputs of an individual FUNWAVE run
#	  to a single structure
#########################################################
function run_compress_out_i {

## Arguments
	super_path=$1
	run_name=$2
	slurm_array_number=$3
		
## Path to and name of function
	path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
	func="compress_out_i"
	
## Construct Trial Number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct arguments to matlab function
	args="'${super_path}','${run_name}',${tri_no}"

## Run function
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}

#########################################################
# run_compress_out
#	- the 'compress_out' function to compress the outputs
#	  to compress the outputs of all FUNWAVE runs from a
#	  given run to a single structure, memory permitting
#########################################################
function run_compress_out {
## Arguments
	args=$1
## Path to and name of function
	path="/work/thsu/rschanta/RTS/functions/FW-tools/FW-compress"
	func="compress_out"
## Run function
	matlab -nodisplay -r "cd('"$path"'); "$func"("$args");exit"
}



#########################################################
# get_input_dir
#	- gets the input folder associated with a trial under
#     a given run (eg- input_00004)
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

