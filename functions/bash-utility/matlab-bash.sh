#########################################################
# run_MATLAB_script
#	- runs a given MATLAB script specified by filepath
#     and makes sure helper functions are in path
#########################################################
function run_MATLAB_script {
## Arguments
    path=$1
	w=$2 
	
# Runs a MATLAB script specified 'file_name.mat' in Caviness
	matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('"$2"'));run('"$1"');exit;"
}


#######################2##################################
# run_MATLAB_function
#	- runs a given MATLAB function at a given path with 
#     a string corresponding to its arguments. This is a 
#     a bit clunky, so wrapper functions for individual 
#     MATLAB functions are useful for this. Additionally,
#     the helper functions are added to the path
#	- example: calling an interpolation function called 
#     'ínterp3' with arguments x, v, xq, and 'spline' would
# 			- path = '/path_to_function_dir'
#			- func = 'interp3'
#			- args = "x,v,'linear'"
#########################################################
function run_MATLAB_function {
## Arguments
	func=$1
	args=$2
	w=$3
## cd to path where function is, execute function under arguments
	matlab -nodisplay -nosplash -r "addpath(genpath('"$4"')); "$func"("$args");exit"
}

#########################################################
# run_compress_out
#	- the 'compress_out' function to compress the outputs
#	  to compress the outputs of all FUNWAVE runs from a
#	  given run to a single structure, memory permitting
#########################################################
function run_compress_out {
## Arguments
	super_path=$1
	run_name=$2
	w=$3
	
## Path to and name of function
	func="compress_out"
	
## Construct arguments
	args="'${super_path}','${run_name}'"
	
## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$w"')); "$func"("$args");exit"
}


#########################################################
# run_comp_i
#	- the 'comp_i' function compresses all the outputs
#     from a given trial to a single MATLAB structure,
#     and runs the functions listed in $f_list as well
#########################################################
function run_comp_i {

## Arguments
	super_path=$1
	run_name=$2
	slurm_array_number=$3
	f_list=$4
	w=$5
	
## Name of function
	func="comp_i_stat"
	
## Construct Trial Number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct arguments to matlab function
	args="'${super_path}','${run_name}',${tri_no},${f_list}"

## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$w"')); "$func"("$args");exit"
}