## LOAD IN BASH UTILITIES
. "/work/thsu/rschanta/RTS/functions/utility/bash-utils.sh"


## RUN NAME
super_path="/lustre/scratch/rschanta/"
run_name="make_FW3"
count="8"

## Make log and batch folders
slurm_dir=".\/${run_name}\/slurm_logs\/"
batch_dir="./${run_name}/batch-scripts/"
mkdir "./${run_name}/slurm_logs/"
mkdir "./${run_name}/batch-scripts/"

###################################################
# GENERATE INPUT FILES
###################################################
# Create a batch script and set relevant parameters
generation_file="${batch_dir}GEN_${run_name}.qs"
create_batch_script $generation_file
	set_slurm "job-name" "GEN_${run_name}" $generation_file
	set_slurm "partition" "thsu" $generation_file
	set_slurm "output" "${slurm_dir}GEN_out.out" $generation_file
	set_slurm "error" "${slurm_dir}GEN_err.out" $generation_file
	set_slurm "tasks-per-node" "32" $generation_file
	remove_slurm "array" $generation_file
	remove_slurm "dependency" $generation_file

cat <<EOF >> $generation_file
vpkg_require matlab
run_MATLAB_script "./${run_name}/${run_name}.m"
EOF

# Run the script
ID_Gen=$(sbatch --parsable $generation_file)

###################################################
# RUN FUNWAVE INPUTS IN PARALLEL, COMPRESS
###################################################
parallel_file="${batch_dir}RUN_${run_name}.qs"
create_batch_script $parallel_file
	set_slurm "job-name" "RUN_${run_name}" $parallel_file
	set_slurm "partition" "thsu" $parallel_file
	set_slurm "output" "${slurm_dir}RUN_out_%a.out" $parallel_file
	set_slurm "error" "${slurm_dir}RUN_err_%a.out" $parallel_file
	set_slurm "tasks-per-node" "32" $parallel_file
	set_slurm "array" 1-$count "$parallel_file"
	set_slurm "dependency" "afterok:$ID_Gen" $parallel_file


## BODY OF FILE
cat <<EOF >> $parallel_file
. /opt/shared/slurm/templates/libexec/openmpi.sh
vpkg_require openmpi

## FUNWAVE Executable Path
fun_ex="/work/thsu/rschanta/RTS/funwave/v3.6/exec/FW-REG"

## Construct Input File Name 
in_dir="${super_path}${run_name}/inputs/"
NUM=\$(printf "%05d" \$SLURM_ARRAY_TASK_ID)
input_file="\${in_dir}input_\${NUM}.txt"

## Run FUNWAVE
\${UD_MPIRUN} "\$fun_ex" "\$input_file"

## Compress outputs from run to single structure
args="'${super_path}','${run_name}',\${NUM}"
run_compress_out_i \$args

rm -rf "${super_path}${run_name}/outputs-raw/out_\$(printf "%05d" \$SLURM_ARRAY_TASK_ID)/"

EOF

ID_Run=$(sbatch --parsable $parallel_file)


###################################################
# COMPRESS ALL TO SINGLE STRUCTURE AND CLEAN
###################################################
compress_file="${batch_dir}COMP_${run_name}.qs"
create_batch_script $compress_file
	set_slurm "job-name" "COMP_${run_name}" $compress_file
	set_slurm "partition" "thsu" $compress_file
	set_slurm "output" "${slurm_dir}COMP_out.out" $compress_file
	set_slurm "error" "${slurm_dir}COMP_err.out" $compress_file
	set_slurm "tasks-per-node" "32" $compress_file
	remove_slurm "array" $compress_file
	set_slurm "dependency" "afterok:$ID_Run" $compress_file


## BODY OF FILE
cat <<EOF >> $compress_file
vpkg_require matlab

## Compress outputs from all runs to a single structure
args="'${super_path}','${run_name}'"
run_compress_out \$args

rm -rf "${super_path}${run_name}/outputs-proc/"
rm -rf "${super_path}${run_name}/outputs-raw/"
EOF

ID_Comp=$(sbatch --parsable $compress_file)

###################################################
# COPY RESULTS TO WORK DIRECTORY
###################################################
copy_file="${batch_dir}COPY_${run_name}.qs"
create_batch_script $copy_file
	set_slurm "job-name" "COPY_${run_name}" $copy_file
	set_slurm "partition" "thsu" $copy_file
	set_slurm "output" "${slurm_dir}COPY_out.out" $copy_file
	set_slurm "error" "${slurm_dir}COPY_err.out" $copy_file
	set_slurm "tasks-per-node" "32" $copy_file
	remove_slurm "array" $copy_file
	set_slurm "dependency" "afterok:$ID_Comp" $copy_file


## BODY OF FILE
cat <<EOF >> $copy_file
cp "${super_path}${run_name}/inputs.mat" "./${run_name}/inputs.mat"
cp "${super_path}${run_name}/outputs.mat" "./${run_name}/outputs.mat"
EOF

ID_Copy=$(sbatch --parsable $copy_file)