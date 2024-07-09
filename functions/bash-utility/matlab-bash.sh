#########################################################
# run_MATLAB_script
#	- runs a given MATLAB script specified by filepath
#     and makes sure helper functions are in path
#########################################################
function run_MATLAB_script {
## Arguments
    path=$1
	
# Runs a MATLAB script specified 'file_name.mat' in Caviness
	matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('"$FCP"'));run('"$1"');exit;"
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
## cd to path where function is, execute function under arguments
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}

#########################################################
# run_gen
#	- the 'run_gen' function runs the function defined
#     by the run_name stored in run_name.m to generate
#     the input files for the run.
#########################################################
function run_gen {
## Arguments
	

	
## Construct arguments
	args="'${SP}','${RN}'"
## Path to generation folder
	GDIR="${WD}/input_definitions/"
	
## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$GDIR"'));addpath(genpath('"$FCP"')); "$RN"("$args");exit"
}

#########################################################
# run_animate_eta
#	- the 'animate_eta' function makes an AVI video for
#     the output
#########################################################
function run_animate_eta {

## Arguments
	slurm_array_number=$1
## Name of function
	func="animate_eta"
	
## Construct Trial Number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct arguments to matlab function
	args="'${SP}','${RN}',${tri_no}"

## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}

#########################################################
# run_animate_velocity
#	- the 'animate_velocity' function makes an AVI video for
#     the output
#########################################################
function run_animate_velocity {

## Arguments
	slurm_array_number=$1
## Name of function
	func="animate_velocity"
	
## Construct Trial Number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct arguments to matlab function
	args="'${SP}','${RN}',${tri_no}"

## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}

#########################################################
# run_animate_velocity
#	- the 'animate_velocity' function makes an AVI video for
#     the output
#########################################################
function run_animate_undertow {

## Arguments
	slurm_array_number=$1
## Name of function
	func="animate_undertow"
	
## Construct Trial Number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct arguments to matlab function
	args="'${SP}','${RN}',${tri_no}"

## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}
#########################################################
# run_compress_out
#	- the 'compress_out' function to compress the outputs
#	  to compress the outputs of all FUNWAVE runs from a
#	  given run to a single structure, memory permitting
#########################################################
function run_compress_out {
## Arguments
	
## Path to and name of function
	func="compress_out"
	
## Construct arguments
	args="'${SP}','${RN}'"
	
## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}


#########################################################
# run_comp_i
#	- the 'comp_i' function compresses all the outputs
#     from a given trial to a single MATLAB structure,
#     and runs the functions listed in $f_list as well
#########################################################
function run_comp_i {

## Arguments
	slurm_array_number=$1
	f_list=$2
## Name of function
	func="compress_i"
	
## Construct Trial Number
	tri_no=$(printf "%05d" $slurm_array_number)
## Construct arguments to matlab function
	args="'${SP}','${RN}',${tri_no},${f_list}"

## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}


#########################################################
# run_comp_D3_FW_mov
#	- the 'run_comp_D3_FW_mov' function compares FUNWAVE
#     outputs to the Dune3 data
#########################################################
function run_comp_D3_FW_mov {

## Arguments
	slurm_array_number=$1
## Name of function
	func="comp_D3_FW_mov"
## Construct Trial Number
	tri_no=$slurm_array_number
## Construct arguments to matlab function
	args="${tri_no},'${SP}','${RN}'"

## Run function
	matlab -nodisplay -nosplash -r "addpath(genpath('"$FCP"')); "$func"("$args");exit"
}