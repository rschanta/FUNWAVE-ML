# Run File

The following code snippet is used to send in an sbatch SLURM array script that will run 
through all the FUNWAVE inputs in parallel as much as possible on the given partition:

```bash
###################################################
# RUN FUNWAVE INPUTS IN PARALLEL, COMPRESS
###################################################
p_file="${batch_dir}RUN_${run_name}.qs"
arr="1-${count}"
create_batch_ad $p_file "RUN_${run_name}" $par $tpn $IDG $arr
	set_slurm "output" "${slurm_dir}RUN_out_%a.out" $p_file
	set_slurm "error" "${slurm_dir}RUN_err_%a.out" $p_file



## BODY OF FILE
cat <<EOF >> $p_file
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

IDP=$(run_batch "$p_file")
```

Here, the name of the file is generated and a parallel batch script is generated using the 
template `create_batch_ad` as found in the ***sbatch-slurm-utils.sh*** script.

Then, the necessary lines are concatenated onto the template. Here, we need to get MATLAB
via VALET as well as openmpi. We also need to specify the path to the FUNWAVE executable for **fun_ex**.
We need the directory where all the inputs are stored <ins>*super_path/run_name/inputs/*</ins>

Then, the specific input file number is constructed from the **SLURM_ARRAY_TASK_ID** 
(see section on slurm arrays for further explanation).

FUNWAVE is then run using the `UD_MPIRUN` command.

Next, the `compress_out_i` helper function is used to compress all of the outputs from the FUNWAVE trial
into a single matlab structure, saving the file in <ins>*outputs-proc*</ins>. The <ins>*outputs-raw*</ins> directory is then deleted
to save memory.

Finally, the batch script is run and the ID is gotten as before.